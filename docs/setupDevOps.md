How to start DevOps Environment for Office Dev
Updated: Feb 5, 2016


Goals
To install a DevOps environment to streamline Web app dev (e.g. data visualization framework)
and test automation later by:
- install Jenkins to run build from GitHub
- set up web server instances (Node.js with express.js, or better: nginx) and load balancer (haproxy)
- set up docker instances using docker-compose to automate infrastructure setup
- set up demo server for data visualization prototype

Node.js server
1. start up docker container
%sudo docker run --name node01  -v /home/ray/dev/proto01:/opt/proto01 -p 8903:10001 -d  rayymlai/nodejs

2. install express.js and start web server
%sudo docker exec -ti node01 bash
%npm init
%npm install express
%cd proto1
%node express.js &

3. set up jenkins for continuous integration/test automation
%sudo docker run --name jenkins01 -d -p 8906:8080 -p 50000:50000 -v /mnt/data01/jenkins:/var/jenkins_home jenkins

- create a docker container
- enable security, use jenkins db for authentication/user management
- signup with admin user id, and then disable signup
- install plugins
- configure github

yamcs open source mission control software
1. download yamcs 
%curl -sSL https://get.docker.com/ | sh

%cd /home/ray/dev/yamcs/leo_spacecraft

assumption: you install docker, and also download docker-compose (e.g. sudo wget https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname  -s`-`uname -m` -O /usr/local/bin/docker-compose)

2. install and run yamcs docker 
http://www.yamcs.org/running/

%curl -sSL http://www.yamcs.org/yss/leo_spacecraft.sh | sh
%cd leo_spacecraft
%docker-compose up 

3. install yamcs studio client
download client from https://github.com/yamcs/yamcs-studio/releases
Details at http://www.yamcs.org/docs/studio/Installation/

- launch yamcs studio client
- connect as per instructions at http://www.yamcs.org/docs/studio/Connecting_to_Yamcs/
yamcs instance=simulator
user=operator
password=(leave it blank)
primary server=(your server ip address, e.g. rezel)
port=8090

assumption - your yamcs server is started using docker-compose under the docker host rezel.


------
to be added


Pre-requisites
1. Create docker host (e.g. install CentOS 7)
- install minimal Linux with your user id and sudo access rights (add user id in /etc/sudoers)
- use wired connection whenever possible
- install Oracle JDK 8+ not JRE (refer to tomcat8 dockerfile for example)
- do a "sudo yum update"
- for ssh, make sure to disable dns in sshd (otherwise ssh will be very slow)
  Set "UseDNS No" in /etc/ssh/sshd_config
- install X11 if possible. On MacOS, install XQuartz package from apple site. On Linux,
  run "sudo yum install xorg-x11-xauth xterm". From your client, run "ssh -YC hostName -l userId"

2. Install docker software
- Install latest docker
Option 1 (official, good for docker 1.8+):
$ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

----
sudo yum install docker-engine
sudo service docker start


Option 2 (good to use systemctl to enable docker as a service):
yum -y install docker docker-registry
systemctl enable docker.service
systemctl start docker.service
systemctl status docker.service

http://www.liquidweb.com/kb/how-to-install-docker-on-centos-7/

----
2/10/2016
[ray@devops01 ~]$ export JAVA_VERSION=8u31
[ray@devops01 ~]$ export BUILD_VERSION=b13
[ray@devops01 ~]$ sudo wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm
[ray@devops01 ~]$ sudo yum -y install /tmp/jdk-8-linux-x64.rpm
[ray@devops01 ~]$ sudo alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000
[ray@devops01 ~]$ sudo alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
[ray@devops01 ~]$ sudo alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
[ray@devops01 ~]$ sudo service docker start
Redirecting to /bin/systemctl start  docker.service
[ray@devops01 ~]$ sudo systemctl enable docker.service
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
[ray@devops01 ~]$ sudo systemctl start docker.service
[ray@devops01 ~]$ sudo systemctl status docker.service

to use attached volume (block storage created from rackspace, and attached to linux)
%sudo fdisk -l
%sudo fdisk /dev/xvdb
- select m (list all options)
- select n (new partition)
- select p (primary partition)
- select 1 (first partition)
- select first and last prompted sectors to use the entire disk
- select w to write the change
%sudo mkfs -t ext3 /dev/xvdb1
[ray@devops01 /]$ sudo mkdir -p /mnt/data01
[ray@devops01 /]$ sudo mount /dev/xvdb1 /mnt/data01

[ray@devops01 data01]$ sudo vim /etc/sysconfig/docker
(you can specify your docker images to be stored in a specific location, indicated by -g of the OPTIONS. 
Make sure you restart docker daemon).
# /etc/sysconfig/docker

# Modify these options if you want to change the way the docker daemon runs
OPTIONS='--selinux-enabled -g /mnt/data01/dockerImages'
#OPTIONS='--selinux-enabled'
DOCKER_CERT_PATH=/etc/docker

# Enable insecure registry communication by appending the registry URL
# to the INSECURE_REGISTRY variable below and uncommenting it
# INSECURE_REGISTRY='--insecure-registry '

# On SELinux System, if you remove the --selinux-enabled option, you
# also need to turn on the docker_transition_unconfined boolean.
# setsebool -P docker_transition_unconfined

# Location used for temporary files, such as those created by
# docker load and build operations. Default is /var/lib/docker/tmp
# Can be overriden by setting the following environment variable.
# DOCKER_TMPDIR=/var/tmp

# Controls the /etc/cron.daily/docker-logrotate cron job status.
# To disable, uncomment the line below.
# LOGROTATE=false

# Allow creation of core dumps
GOTRACEBACK=crash


[ray@devops01 data01]$ sudo mkdir -p /mnt/data01/dockerImages
[ray@devops01 data01]$ ls -al /mnt/data01/dockerImages/

%sudo docker run --name node01  -v /home/ray/dev/jenkins/build/nodejs:/opt/nodejs/missionOps -p 8903:8080 -d  rayymlai/nodejs

%sudo docker run --name node01  -v /mnt/data01/jenkins/build/nodejs:/opt/nodejs/missionOps -p 8903:8080 -d  rayymlai/nodejs
%sudo docker exec -ti node01 bash
cd /opt/proto01
npm init
npm install express
node express.js &


to create new users (developers)
%sudo /usr/sbin/groupadd staff
%sudo /usr/sbin/useradd -g staff masaki
%sudo passwd masaki

Reference https://support.rackspace.com/how-to/prepare-your-cloud-block-storage-volume/
