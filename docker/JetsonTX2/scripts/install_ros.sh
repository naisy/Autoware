########################################
# ROS Kinetic Install
########################################
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
apt-get update

apt-get install -y python-catkin-pkg python-rosdep python-wstool ros-kinetic-catkin libmosquitto-dev

apt-get install -y ros-kinetic-desktop-full ros-kinetic-catkin ros-kinetic-nmea-msgs ros-kinetic-nmea-navsat-driver ros-kinetic-sound-play ros-kinetic-jsk-visualization ros-kinetic-grid-map ros-kinetic-gps-common ros-kinetic-controller-manager ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-gazebo-ros-control ros-kinetic-joystick-drivers libnlopt-dev freeglut3-dev qtbase5-dev libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev gksu libgl1-mesa-dev libglew-dev python-wxgtk3.0 software-properties-common libmosquitto-dev libyaml-cpp-dev python-flask python-requests ros-kinetic-uvc-camera ros-kinetic-velodyne ros-kinetic-gmapping ros-kinetic-openslam-gmapping ros-kinetic-map-server pcl-tools ros-kinetic-automotive-platform-msgs

cd /opt/ros/kinetic/ \
&& grep -rl . -e 'libvtkproj4-6.2.so.6.2.0' | xargs -n1 file | grep "ASCII text" | cut -d':' -f1 | xargs sed -i 's|/usr/lib/aarch64-linux-gnu/libvtkproj4-6\.2\.so\.6\.2\.0|/usr/lib/libvtkproj4.so|g'

echo "source /opt/ros/kinetic/setup.bash" >> /home/ubuntu/.bashrc \
&& echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc \
&& echo "export QT_X11_NO_MITSHM=1" >> /home/ubuntu/.bashrc \
&& echo "export QT_X11_NO_MITSHM=1" >> /root/.bashrc \
&& echo "export LANG=en_US.UTF-8" >> /home/ubuntu/.bashrc \
&& echo "export LANG=en_US.UTF-8" >> /root/.bashrc \
&& echo "export LC_ALL=\$LANG" >>  /home/ubuntu/.bashrc


rosdep init \
&& rosdep update
