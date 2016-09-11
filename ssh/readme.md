# Readme.md
Updated: Sep 7, 2016

## Installation steps
1. Pre-requisites 
  - Install Docker
  - Build Docker image, e.g. docker build -t xxx/yyy .

2. Launch docker instance
```
sudo docker run --name ssh01 -d -p 8902:22 -p 8908:8080 -v /mnt/data/prod/ssh:/opt/ssh rayymlai/ssh
```
