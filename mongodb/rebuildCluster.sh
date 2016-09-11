# Program: rebuildCluster.sh
# Purpose: mongo shell to set up (or rebuild) replica set, and then to restart MongoDB as replica set
# Author:  Ray Lai
# Updated: Sep 8, 2016
#
# stop and clean up Mongodb instances if exist
docker stop data01 data02 data03
docker rm data01 data02 data03

# start MongoDB with replica set and auth options
docker run -p 3101:27017 --name data01 --hostname data01.ourhome.com -d -v /mnt/data/database/data01:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --net=mongodb --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "ourhome01" --auth

docker run -p 3102:27017 --name data02 --hostname data02.ourhome.com -d -v /mnt/data/database/data02:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --net=mongodb --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "ourhome01" --auth

docker run -p 3103:27017 --name data03 --hostname data03.ourhome.com -d -v /mnt/data/database/data03:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --net=mongodb --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "ourhome01" --auth
