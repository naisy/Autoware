#!/bin/bash

########################################
# CPU Fan Daemon
########################################
./setup_cpufun.sh


########################################
# CPU Fan Launch Now
########################################
# ref: http://elinux.org/Jetson/TX1_Controlling_Performance
sh -c 'echo 255 > /sys/kernel/debug/tegra_fan/target_pwm'


########################################
# Symbolic Link
########################################
ln -s /usr/local/cuda-9.0 /usr/local/cuda
ln -s /usr/local/cuda/targets/aarch64-linux/lib/stubs/libcuda.so /usr/local/cuda/targets/aarch64-linux/lib/stubs/libcuda.so.1


########################################
# Ubuntu Package Update
########################################
./setup_update.sh


########################################
# .bashrc (ubuntu/root)
########################################
./setup_bash.sh


########################################
# dircolors
########################################
./setup_dircolors.sh


########################################
# reboot
########################################
reboot

