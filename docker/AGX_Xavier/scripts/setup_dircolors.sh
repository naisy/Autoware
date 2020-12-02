#!/bin/bash
########################################
# dircolors
########################################
cp setup_dircolors.txt /home/$(getent passwd 1000 | cut -d: -f1)/.dircolors
chown $(getent passwd 1000 | cut -d: -f1):$(getent group 1000 | cut -d: -f1) /home/$(getent passwd 1000 | cut -d: -f1)/.dircolors
chmod 600 /home/$(getent passwd 1000 | cut -d: -f1)/.dircolors

cp setup_dircolors.txt /root/.dircolors
chmod 600 /root/.dircolors

