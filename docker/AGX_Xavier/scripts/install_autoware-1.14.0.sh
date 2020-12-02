#!/bin/bash -e

set -e

password='jetson'

# Keep updating the existing sudo time stamp
sudo -v
while true; do sudo -n true; sleep 120; kill -0 "$$" || exit; done 2>/dev/null &

sudo apt-get update
sudo apt-get install -y lsb-release
sudo apt-get install -y gnupg2

########################################
# Pass tzdata's interactive interface with default values
########################################
sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata'
sudo ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata


########################################
# Pass interactive interface with service restart
########################################
# https://unix.stackexchange.com/questions/146283/how-to-prevent-prompt-that-ask-to-restart-services-when-installing-libpq-dev
sudo apt-get -y install debconf-utils
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections


########################################
# Install ROS
########################################
# http://wiki.ros.org/melodic/Installation/Ubuntu
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install -y ros-melodic-desktop-full


########################################
# Install Autoware
########################################
#https://github.com/Autoware-AI/autoware.ai/wiki/Source-Build
sudo apt install -y python-catkin-pkg python-rosdep ros-melodic-catkin
sudo apt install -y python3-pip python3-colcon-common-extensions python3-setuptools python3-vcstool
sudo apt install -y git
pip3 install -U setuptools


# for CUDA
cd && wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz #Download Eigen
mkdir eigen && tar --strip-components=1 -xzvf eigen-3.3.7.tar.gz -C eigen #Decompress
cd eigen && mkdir build && cd build && cmake .. && make && sudo make install #Build and install
cd && rm -rf eigen-3.3.7.tar.gz && rm -rf eigen #Remove downloaded and temporary files

source /opt/ros/melodic/setup.bash

# Autoware 1.14
mkdir -p autoware.ai/src
cd autoware.ai
wget -O autoware.ai.repos "https://raw.githubusercontent.com/Autoware-AI/autoware.ai/master/autoware.ai.repos"
vcs import src < autoware.ai.repos

sudo rosdep init
rosdep update
rosdep install -y --from-paths src --ignore-src --rosdistro melodic # Yes

sed -i 's/"10\.0"/"10.2"/g' ./src/autoware/common/autoware_build_flags/cmake/autoware_build_flags-extras.cmake

# with CUDA <= 10.0
AUTOWARE_COMPILE_WITH_CUDA=1 colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
# Without CUDA
#colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

#10W 2core: Summary: 154 packages finished [2h 41min 50s]
#15W 4core: Summary: 154 packages finished [1h 27min 37s]


sudo apt-get install -y dbus-x11
sudo apt-get install -y libcanberra-gtk-module libcanberra-gtk3-module
sudo apt-get install -y gnome-terminal

#vi /home/jetson/autoware.ai/install/runtime_manager/share/runtime_manager/scripts/run

# launch
cd ~/autoware.ai
source install/setup.bash
roslaunch runtime_manager runtime_manager.launch

