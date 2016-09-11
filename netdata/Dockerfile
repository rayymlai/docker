# Program: Dockerfile (for NetData)
# Purpose: docker image for NetData, display real time system metrics from docker host
# Authors: Tit Petric, Costa Tsaousis
# Updated: Sep 9, 2016
#
FROM debian:jessie

# create debian build
ADD build.sh /build.sh
RUN chmod +x /build.sh; sync; sleep 1; /build.sh
WORKDIR /

# ports exposed
ENV NETDATA_PORT 19999
EXPOSE $NETDATA_PORT

# entry point
CMD /usr/sbin/netdata -D -s /host -p ${NETDATA_PORT}
