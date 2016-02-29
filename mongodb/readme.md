MongoDB Docker readme
Updated: Feb 28, 2016

sudo docker run -d --name mongodb01 -h data01.autismpathfinder.org -v /home/ray/dev/data/data01:/data/db -p 8905:27017 rayymlai/mongodb --replSet "autism01"

sudo docker run -d --name mongodb02 -h data02.autismpathfinder.org -v /home/ray/dev/data/data02:/data/db -p 8906:27017 rayymlai/mongodb --replSet "autism01"

sudo docker run -d --name mongodb03 -h data03.autismpathfinder.org -v /home/ray/dev/data/data03:/data/db -p 8907:27017 rayymlai/mongodb --replSet "autism01"

autism01:PRIMARY> db.createUser({user: "admin", pwd: "johanan$", roles: [{role: "userAdminAnyDatabase", db: "admin"}]})
Successfully added user: {
	"user" : "admin",
	"roles" : [
		{
			"role" : "userAdminAnyDatabase",
			"db" : "admin"
		}
	]
}


