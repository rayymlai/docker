# Dockerfile Images for building micro-services (Micro-services-in-a-box)
Updated: Feb 29, 2016

This project contains NodeJS Web server, MongoDB database and other infrastructure tools that can support running micro-services in a box, independent of hosting at home office, RackSpace or AWS.

Most Dockerfile definitions are from Docker registry with minor enhancement. They are accumulated from my past few jobs.  We adopt MIT license for free re-use.

## What's New
* NodeJS docker image supports v6.x for lambda-like functions, and use of nodemon and forever packages for resilience.
* MongoDB docker image supports use of Docker Network (from v1.12) without manually defining static IP addresses for replica set. I also include an open source database index management tool using Python/Jython.
* Updated NetData monitoring
* Individual docker project has detailed installation instructions in readme.md.

## Scope
This project will include dockerfiles for the following areas.

For application development:
* NodeJS 6.x
* MongoDB 3.2 replicaset
* RabbitMQ server
* Tomcat 8 app server

For infrastructure:
* NetData monitoring
* Headless VNC 
* CentOS with SSH

For simulation:
* NASA GMAT R2015a

## How to use
There are individual readme.md for most of the docker images. 

In general:
* Prepare a docker host (parent machine) with docker-engine package or client CLI (Docker 1.12+)
* Mount a shared data volume or block storage, e.g. under /mnt/data
* Build docker images
  - change directory to your docker image which contains Dockerfile
  - build docker image, e.g. docker build -t rayymlai/xxx .
* Start your docker instance
  - If you want to create a docker instance with the hostname xxx.yourdomain.com with TCP port nnn, and your Linux data volume inside the docker instance /yyy is mapped to an external data volume /mnt/data/yyy, you can issue the command:

```
docker run --name xxx --hostname xxx.yourdomain.com -d -p nnn:nnn -v /mnt/data/yyy:/yyy rayymlai/yourdockername
```

In order to enable micro-services, you need to perform additional tasks (out of scope for this project), e.g.
* Create multiple docker instances
* Enable load balancer for docker instances (for scalability and availability)
* Enable heart-beat detecting for site reliability (for availability)
  - You can consider using Consul with Docker Swarm
  - Alternative technologies: Amazon Lambda
* For deploying micro-services, there are a few options
  - Configuration tools to auto-deploy, e.g. Chef/Ansible
  - Create auto-deploy tasks in Jenkins continuous integration 
  - Container management tools, e.g. Mesophere, Docker Swarm
