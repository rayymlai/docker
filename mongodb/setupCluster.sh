# Program: setupCluster.sh
# Purpose: mongo shell to set up replica set, and to provision admin users
# Author:  Ray Lai
# Updated: Sep 8, 2016
#
docker exec -i data01 bash << leftcurlybracket
mongo -u ray -p race2space --authenticationDatabase admin
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


