FROM centos:centos6
MAINTAINER Ray Lai rayymlai@gmail.com
 
#Helpful utils, but only sudo is required
RUN yum -y install tar
RUN yum -y install vim
RUN yum -y install nc
RUN yum -y install sudo
## for CentOS6 enable EPEL
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Upgrading system
RUN yum -y upgrade
RUN yum -y install wget
RUN yum -y install unzip git zip

#  Download nodejs
RUN yum -y install nodejs npm

RUN yum -y clean all && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /src

RUN cd /src; npm install

EXPOSE 8080

CMD ["node", "/src/index.js"]

