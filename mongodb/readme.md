# Setting up MongoDB 3.2 replica set on docker host
Updated: Jul 8, 2016

This document outlines how to create a MongoDB replica set with minimal manual configuration. It now uses Docker Network (available in Docker 1.12) without binding static IP addresses in any MongoDB nodes.

# What's New
* MongoDB 3.2 replica set
* Use Docker network to configure static IP addresses - no manual static IP address assignment
* Enable database authentication with passwords

# Installation Steps
1. Create database folders in your docker host.
Assuming you have a mounted data volume under /mnt/data (e.g. 2TB), you can create data folders first
```
sudo mkdir -p /mnt/data/database/data01
sudo mkdir -p /mnt/data/database/data02
sudo mkdir -p /mnt/data/database/data03
```

2. Create keyfile for replicaset database security 
For database security, you also need a shared folder to store the keyfiles. The script 'createMongoDbKeyfile.sh' creates a keyfile under /mnt/data/database/keyfile where MongoDB nodes can use to authenticate before replicating data among themselves.

The script contains the following codes:
```
sudo mkdir -p /mnt/data/database/keyfile
cd /mnt/data/database/keyfile

sudo touch mongodb-keyfile
sudo chmod ugo+w mongodb-keyfile
sudo openssl rand -base64 741 > mongodb-keyfile
sudo chmod 600 mongodb-keyfile
sudo chown 999 mongodb-keyfile
```

4. Create a single node MongoDB container first
* The script 'createMongoDBContainers.sh' will create an internal network for MongoDB nodes, and initiate MongoDB database files under /mnt/data/database/data01.

The script contains the following codes:
```
docker network create mongodb
docker run --net=mongodb -p 3101:27017 --name data01 --hostname data01.ourhome.com -d -v /mnt/data/database/data01:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --memory 4000M rayymlai/mongodb
```

5. Start MongoDB replica set
* The script 'rebuildCluster.sh' will start 3 nodes with database security turned off. However, the replica set is not ready to use yet because you need to initiate the replica set and create admin user in the next step.
The script contains the following codes:
```
docker stop data01 
docker rm data01 

# start MongoDB with replica set and auth options
docker run -p 3101:27017 --name data01 --hostname data01.ourhome.com -d -v /mnt/data/database/data01:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --net=mongodb --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "ourhome01" --auth

docker run -p 3102:27017 --name data02 --hostname data02.ourhome.com -d -v /mnt/data/database/data02:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --net=mongodb --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "ourhome01" --auth

docker run -p 3103:27017 --name data03 --hostname data03.ourhome.com -d -v /mnt/data/database/data03:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --net=mongodb --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "ourhome01" --auth

```

6. Set up mongodb cluster
The script 'setupPrimaryNode.sh' will initiate the replica set, and then create system admin user.

The script contains the following codes:
```
docker exec -i  data01 bash << leftcurlybracket
mongo
  use admin
  rs.initiate()
  db.createUser( { user: "admin", pwd: "admin2016", roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "clusterAdmin", db: "admin" }, { role: "dbAdminAnyDatabase", db: "admin" } ] } )
  db.auth("admin","admin2016")
  db.createUser( { user: "root", pwd: "admin2016", roles: [ { role: "root", db: "admin" } ] });
  db.createUser( { user: "myapp", pwd: "myapp2016", roles: [ "readWriteAnyDatabase" ] } );
exit
leftcurlybracket
```

Remark:  If you encounter error complaining your MongoDB (data01) is not primary node, it is possible that your MongoDB may be slow to become the primary node. I would retry which should be successful.

7. Verify your replica set 
You can verify your setup by using mongo shell

e.g.
```
mongo -u admin -p admin2016 --authenticationDatabase admin --host dockerhost.ourhome.com --port 3101
MongoDB shell version: 3.2.4
connecting to: dockerhost.ourhome.com:3101/test
Server has startup warnings: 
2016-09-09T23:31:51.548+0000 I CONTROL  [initandlisten] ** WARNING: You are running this process as the root user, which is not recommended.
2016-09-09T23:31:51.549+0000 I CONTROL  [initandlisten] 
2016-09-09T23:31:51.549+0000 I CONTROL  [initandlisten] 
2016-09-09T23:31:51.549+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/enabled is 'always'.
2016-09-09T23:31:51.549+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2016-09-09T23:31:51.550+0000 I CONTROL  [initandlisten] 
2016-09-09T23:31:51.550+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/defrag is 'always'.
2016-09-09T23:31:51.550+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2016-09-09T23:31:51.550+0000 I CONTROL  [initandlisten] 
ourhome01:PRIMARY> rs.status()
{
	"set" : "ourhome01",
	"date" : ISODate("2016-09-11T03:05:31.789Z"),
	"myState" : 1,
	"term" : NumberLong(1),
	"heartbeatIntervalMillis" : NumberLong(2000),
	"members" : [
		{
			"_id" : 0,
			"name" : "data01.ourhome.com:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 99229,
			"optime" : {
				"ts" : Timestamp(1473464000, 6),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2016-09-09T23:33:20Z"),
			"electionTime" : Timestamp(1473463965, 2),
			"electionDate" : ISODate("2016-09-09T23:32:45Z"),
			"configVersion" : 1,
			"self" : true
		}
	],
	"ok" : 1
}
ourhome01:PRIMARY> 

```

9. Adding MongoDB nodes
The script 'completeCluster.sh' will add 2 more nodes to the replica set.

The script contains the following codes:
```
docker exec -i data01 bash << leftcurlybracket
mongo -u admin -p admin2016 --authenticationDatabase admin
  use admin
  db.auth("admin","admin2016")
  rs.add("data02.ourhome.com:27017")
  if(!rs.isMaster().ismaster){
    print("Is no longer primary after adding data02. Please add remaining nodes by hand")
    exit
  }
  rs.add("data03.ourhome.com:27017")
exit
leftcurlybracket

```

9. in case your primary node becomes secondary node unexpectedly, and you need to force secondary to primary node.
* shut down unused or other nodes
* run these steps

>cfg = rs.config()
>cfg.members = [cfg.members[0]]
>rs.reconfig(cfg, {force: true})


## Appendix - Managing credentials
To create a new admin user, you can login to your mongo shell console:
ourhome01:PRIMARY> db.createUser( { user: "myapp", pwd: "mysecretKey", roles: [ { role: "root", db: "admin" } ] });

if you want to change user password, try
db.updateUser("myapp", { pwd: "mysecretKey2016" })

## Reference
https://medium.com/@gargar454/deploy-a-mongodb-cluster-in-steps-9-using-docker-49205e231319#.oah61g53j
