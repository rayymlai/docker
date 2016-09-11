# Setup DevOps for FiR.ai
Updated: Sep 9, 2016

## Basic CentOS Linux Setup
This is the procedure for CentOS in home lab environment. The procedures for RackSpace or AWS will vary slightly.

### iSCSI setup
Synology NAS supports iSCSI (compared to NFS mount) for faster storage access. The wiki https://www.synology.com/en-us/knowledgebase/DSM/tutorial/Virtualization/How_to_set_up_and_use_iSCSI_target_on_Linux#t1 provides more details.

In short, login to Synology NAS to define the LUN and iSCSI target from Storage Manager. For example:
* Create a new LUN called Fir01-lun with LUN type Advanced file LUN with 2000GB size using thin layer provisioning (for simple file I/O, thin provisioning will save space). Other parameters can be left as default (e.g. allocation unit size=8KB optmized for VMWare VAAI).
* Create a new iSCSI target called Fir01-target with IQN iqn.2000-01.com.synology:jesta01 where the suffix jesta01 corresponds to the hostname (e.g. jesta, rezel) I used. Do not enable CHAP because I find the iSCSI login problematic. For early development within a closed LAN environment, it is ok without enabling CHAP.  Leave the remaining tab as default.
* Map the Fir01-lun to Fir01-target.

Once you provision a new Linux host (e.g. rezel.fir.ai), you can complete the following steps:
* Login as admin user (with sudo root privilege)
* Install iSCSI package, e.g. sudo yum install iscsi-initiator-utils
* Assuming your NAS storage host has static IP address 192.168.1.195:

```
sudo iscsiadm -m discovery -t st -p 192.168.1.195
sudo iscsiadm -m node --targetname "iqn.2000-01.com.synology:jesta01" --portal "192.168.1.195:3260" --login
sudo fdisk -l
sudo fdisk /dev/sdb
sudo mkfs.ext3 /dev/sdb1

```

Edit /etc/fstab, and append the mount statement for permanent changes:
```
/dev/sdb1          /mnt/data               ext3    defaults,noatime,barrier=0 1 1
```

Note:
* If you use RackSpace hosting, you will use blocked storage volume instead of iSCSI. The device name is likely to be /dev/xvdb1 or /dev/xvdf1. In /etc/fstab, you will likely use ext3 as in the above example. Refer to https://support.rackspace.com/how-to/prepare-your-cloud-block-storage-volume/ for details.
* If you use AWS hosting, you will use either EBS or S3 instead of iSCSI. The device name is likely to be /dev/xvdf. In /etc/fstab, you will likely use ext4 instead of ext3. AWS wiki does not prompt you to edit /etc/fstab.
