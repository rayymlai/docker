#!/bin/bash
# Program: start.sh
# Purpose: Create user and sudo admin using a shell script
# Author:  Ray Lai
# Updated: Sep 7, 2016
# Remark:  A better way is to create keyless SSH with 128-bit RSA keys
# License: MIT
#
__provision_users() {
# Define user and password here
SSH_USER=user1
SSH_ADMIN1=admin1
SSH_ADMIN2=user2
SSH_ADMIN3=user3
SSH_USERPASS=xxx

# Execute useradd
groupadd powerusers
groupadd staff
useradd -g powerusers $SSH_USER 
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_USER)
echo ssh user password: $SSH_USERPASS

useradd -g staff $SSH_ADMIN1
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_ADMIN1)
echo ssh admin-user  password: $SSH_USERPASS

useradd -g staff $SSH_ADMIN2
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_ADMIN2)
echo ssh admin-user  password: $SSH_USERPASS

useradd -g staff $SSH_ADMIN3
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_ADMIN3)
echo ssh admin-user  password: $SSH_USERPASS
}

__make_sudoers() {
  echo "$SSH_USER    ALL=(ALL:ALL) ALL" >> /etc/sudoers;
  echo "$SSH_ADMIN1  ALL=(ALL:ALL) ALL" >> /etc/sudoers;
  echo "$SSH_ADMIN2  ALL=(ALL:ALL) ALL" >> /etc/sudoers;
  echo "$SSH_ADMIN3  ALL=(ALL:ALL) ALL" >> /etc/sudoers;
}


# execute create user
__provision_users
__make_sudoers
