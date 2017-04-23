# Program: Dockerfile for NodeJS
# Purpose: NodeJS 6.x for Linux CentOS
# Author:  Ray Lai
# Updated: Sep 7, 2016
# Remark:  Based on docker registry; cange to NodeJS 6.x instead of NodeJS 0.x
#
FROM centos:centos7
MAINTAINER Ray Lai rayymlai@gmail.com

# install dependencies
RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install epel-release; yum clean all

RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install tar vim wget nc curl zip unzip sudo firefoxi git; yum clean all
ENV TERM xterm

# install nodejs 7.x
RUN cd /tmp && curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
RUN cd /tmp && yum -y install nodejs; yum clean all

#Install nodemon (nodejs CI tool)
RUN npm install nodemon -g

#Install forever (nodejs CI tool)
RUN npm install forever -g

#Update npm
# 4/22/2017 RayL: need to move this to the bottom to avoid missing/incompatible dependency  Error: Cannot find module 'semver'
RUN npm install npm -g

EXPOSE 3000 3001 3002 3003

WORKDIR /opt/nodejs
ENTRYPOINT ["forever", "--killSignal=SIGTERM", "--minUptime=10000", "--spinSleepTime=20000", "-c", "nodemon --delay 10 --exitcrash", "server.js"]
