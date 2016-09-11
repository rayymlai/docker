# Program: completeCluster.sh
# Purpose: mongo shell to add node2 and node3 in order to complete replica setup
# Author:  Ray Lai
# Updated: Sep 8, 2016
#
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
