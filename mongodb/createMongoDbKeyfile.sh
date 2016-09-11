# Program: createMongoDbKeyfile.sh
# Purpose: create keyfile for nodes to replicate
# Author:  Ray Lai
# Updated: Sep 10, 2016
#
mkdir -p /mnt/data/database/keyfile
cd /mnt/data/database/keyfile
touch mongodb-keyfile
chmod ugo+w mongodb-keyfile
openssl rand -base64 741 > mongodb-keyfile
chmod 600 mongodb-keyfile
sudo chown 999 mongodb-keyfile
