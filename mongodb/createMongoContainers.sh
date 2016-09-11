# Program: createMongoDBContainers.sh
# Purpose: create docker network and mongodb primary node
# Author:  Ray Lai
# Updated: Sep 10, 2016
#
# create internal network so that replicaset does not need to bind static IP addresses 
docker network create mongodb
# start docker container
docker run --net=mongodb -p 3101:27017 --name data01 --hostname data01.ourhome.com -d -v /mnt/data/database/data01:/data/db -v /mnt/data/database/keyfile:/opt/keyfile --memory 4000M rayymlai/mongodb
