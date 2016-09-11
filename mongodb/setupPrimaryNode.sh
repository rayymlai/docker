# Program: setupCluster.sh
# Purpose: mongo shell to set up replica set, and to provision admin users
# Author:  Ray Lai
# Updated: Sep 8, 2016
#
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
