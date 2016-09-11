# Building GMAT on CentOS 7 with Headless VNC
Updated: Sep 9, 2016

This document is based on latest GMAT R2015a installation instructions. It re-uses CentOS 7 dockerfile with headless VNC. It does not add any customization to GMAT installation.

Caution: From early testing, GMAT on docker tends to generate enormous amount of log messages that will fill up disk space in your docker host within hours (or less than a day).  You may then experience /var/lib/docker/devicemapper is full and you cannot even delete docker instances to release disk space. This happens when any of your docker instances is writing log messages that exceeds the disk capacity under /var/lib/docker/devicemapper/devicemapper and /var/lib/docker/devicemapper/metadata. Once the devicemapper is full, you cannot release disk space. However, you can stop the docker daemon, remove /var/lib/docker and restart the docker daemon to recover. Refer to https://github.com/docker/docker/issues/9786 for details.  

# What's New
* Add a summary of GMAT installation instructions
* Update Java 8 SDK u101

# Features
This docker image will include
* NASA's GMAT for space/satellite mission operations planning and simulation
  - Orbit trajectory simulation
  - Sample scripts of Mathematical model computation and simulation
* Access to GMAT via VNC viewer
* Access to GMAT via Chrome Web browser with VNC plugin
* Java 8 SDK u101, Python 3.4, cmake and GTK support

# Installation instructions
* Download GMAT binaries and data files
For convenience, you can download GMAT R2015a for Linux:
  - GMAT R2015a binaries with patch: https://sourceforge.net/projects/gmat/files/GMAT/GMAT-R2015a/gmat-ubuntu-x64-R2015a.tar.gz/download. You can keep the filename as 'gmat-ubuntu-x64-R2015a.tar.gz'.
  - GMAT data files: https://sourceforge.net/projects/gmat/files/GMAT/GMAT-R2015a/GMAT-datafiles-R2015a.zip/download. You can keep the filename as 'GMAT-datafiles-R2015a.zip'.
  - Unzip these files into your storage, e.g. under /mnt/data/docker/src/gmat.
  - merge the GMAT datafiles with the GMAT binaries, e.g. move and merge /GMAT-datafiles-R2015a/data with /GMAT/R2015a/data. The same merge applies for /GMAT-datafiles-R2015a/bin with /GMAT/R2015a/bin.

* Create a docker instance, mapped to GMAT binaries
```
docker run -d --name gmat01 --hostname gmat.ourhome.com -p 4001:5901 -p 4002:6901 -v /mnt/data/docker/src/gmat:/opt/gmat rayymlai/gmat
```

* Open a VNC session
  - Install VNC viewer (https://www.realvnc.com/download/vnc/)
  - Launch VNC viewer with your server URL and port 5901 (default password is somethingSecretive), e.g. dockerhost.ourhome.com:4001
  - Remark: If you use Chrome Web browser VNC plugin on a Chrome box, please note that it uses "::" instead of ":" when specifying the VNC host. 

* Start GMAT GUI console
```
cd /mnt/data/docker/src/gmat/GMAT/R2015a/bin
./Gmat_Beta
```

* Start GMAT console (no GUI)
```
cd /mnt/data/docker/src/gmat/GMAT/R2015a/bin
./Gmat_Console
```

If your VNC viewer is working, GMAT console will display a graphical user interface, similar to a developer IDE front-end.

# Dependencies
* You need to download GMAT R2015a with patches and the data files from NASA website http://gmatcentral.org separately (the source codes actually reside in https://gmat.gsfc.nasa.gov/downloads.html) because the file size is too huge). Then you can mount the binaries to your pre-defined folder (e.g. /opt/gmat), which is mapped when you create the docker instance.

Remark: NASA's GMAT binaries for Ubuntu (also works for CentOS or Rehat) do not have the base image as per their documentation. However, the Linux software patch actually does include the base binaries, which is different from the Windows binaries (Windows version needs to install the base image, and then applies the patch).
