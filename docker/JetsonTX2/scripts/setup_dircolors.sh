#!/bin/bash
########################################
# dircolors
########################################
cp setup_dircolors.txt /home/ubuntu/.dircolors
chown ubuntu:ubuntu /home/ubuntu/.dircolors
chmod 600 /home/ubuntu/.dircolors

cp setup_dircolors.txt /root/.dircolors
chmod 600 /root/.dircolors
