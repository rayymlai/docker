FROM centos:latest
MAINTAINER Ray Lai rayymlai@gmail.com
 
#Helpful utils, but only sudo is required
RUN yum -y install tar
RUN yum -y install vim
RUN yum -y install nc
RUN yum -y install sudo
RUN yum -y install wget
## for CentOS6 enable EPEL
#RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum -y install pwgen

## for CentOS7 enable EPEL
#RUN curl -o /etc/yum.repos.d/mkosek-freeipa-epel-7.repo https://copr.fedoraproject.org/coprs/mkosek/freeipa/repo/epel-7/mkosek-freeipa-epel-7.repo

### JDK8
ENV JAVA_VERSION 8u31
ENV BUILD_VERSION b13

### tomcat 8
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.32
ENV CATALINA_HOME /opt/tomcat

ENV JAVA_MAXMEMORY 256
ENV TOMCAT_MAXTHREADS 250
ENV TOMCAT_MINSPARETHREADS 4
ENV TOMCAT_HTTPTIMEOUT 20000
ENV TOMCAT_JVM_ROUTE tomcat80
ENV DEPLOY_DIR /webapps
ENV LIBS_DIR /libs
ENV PATH $PATH:$CATALINA_HOME/bin

# Upgrading system
RUN yum -y upgrade
#RUN yum -y install wget
# Downloading Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm
RUN yum -y install /tmp/jdk-8-linux-x64.rpm
RUN alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
ENV JAVA_HOME /usr/java/latest

### install tomcat 8
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
  tar zxf apache-tomcat-*.tar.gz && \
  rm apache-tomcat-*.tar.gz && \
  mv apache-tomcat* ${CATALINA_HOME}

### clean up after install
RUN rm -rf ${CATALINA_HOME}/webapps/examples ${CATALINA_HOME}/webapps/docs ${CATALINA_HOME}/webapps/ROOT ${CATALINA_HOME}/webapps/host-manager ${CATALINA_HOME}/RELEASE-NOTES ${CATALINA_HOME}/RUNNING.txt ${CATALINA_HOME}/bin/*.bat  ${CATALINA_HOME}/bin/*.tar.gz


ADD server.xml ${CATALINA_HOME}/conf/server.xml
ADD logging.properties ${CATALINA_HOME}/conf/logging.properties
ADD create_tomcat_user.sh ${CATALINA_HOME}/bin/create_tomcat_user.sh
ADD tomcat.sh ${CATALINA_HOME}/bin/tomcat.sh
RUN chmod +x ${CATALINA_HOME}/bin/*.sh

RUN groupadd -r tomcat -g 433 && \
useradd -u 431 -r -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin -c "Docker image user" tomcat && \
chown -R tomcat:tomcat ${CATALINA_HOME}

RUN yum clean all && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8009 

USER tomcat
CMD ["/opt/tomcat/bin/tomcat.sh"]
