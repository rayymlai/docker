# Dockerfile Images for building micro-services (Micro-services-in-a-box)
Updated: Feb 29, 2016

This project contains NodeJS Web server, MongoDB database and other infrastructure tools that can support running micro-services in a box, independent of hosting at home office, RackSpace or AWS.

Most Dockerfile definitions are from Docker registry with minor enhancement. They are accumulated from my past few jobs.  We adopt MIT license for free re-use.

## Features
* NodeJS docker image supports v6.x for lambda-like functions, and use of nodemon and forever packages for resilience.
* MongoDB docker image supports use of Docker Network (from v1.12) without manually defining static IP addresses for replica set. I also include an open source database index management tool using Python/Jython.
* Individual docker project has detailed installation instructions in readme.md.


