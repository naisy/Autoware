########################################
# Package Install
########################################
apt-get update
apt-get install -y --allow-unauthenticated build-essential cmake libeigen3-dev libatlas-base-dev gfortran wget libavresample-dev ffmpeg pkg-config unzip qtbase5-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng++-dev libopenexr-dev libtiff-dev libwebp-dev libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev v4l-utils qv4l2 v4l2ucp liblapacke-dev libopenblas-dev checkinstall libgdal-dev libgphoto2-dev libjasper-dev libx264-dev qt5-default freeglut3-dev libgdcm2-dev libvtk6-dev libvtk6-qt-dev libfreetype6-dev tzdata

apt-get install -y libopenni2-dev libvtkgdcm2.6 libvtkgdcm2-dev libgdcm2.6 libgdcm2-dev libgdcm-tools libvtkgdcm-tools libgdcm-cil libvtkgdcm-cil python-gdcm python-vtkgdcm

apt-get install -y software-properties-common wget curl git cmake cmake-curses-gui libboost-all-dev libflann-dev libgsl0-dev libgoogle-perftools-dev libeigen3-dev
apt-get install -y libgoogle-glog-dev

apt-get install -y libproj-dev
# https://stackoverflow.com/questions/37369369/compiling-pcl-1-7-on-ubuntu-16-04-errors-in-cmake-generated-makefile

# Intall some basic GUI and sound libs
# https://www.linuxquestions.org/questions/linux-general-1/nvidia-driver-all-vers-glxgears-works-as-root-segmentation-fault-as-user-solved-589149/
# 目標はglxgearsが実行出来るようになること。rvizのために必要。
apt-get install -y mesa-utils xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme fonts-dejavu fonts-liberation hicolor-icon-theme libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module libasound2 libgtk-3-0 libdbus-glib-1-2 libxt6 libexif12 libgl1-mesa-glx libgl1-mesa-dri language-pack-en \
&& update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Intall some basic GUI tools
apt-get install -y cmake-qt-gui gnome-terminal

# -- Failed to find installed gflags CMake configuration, searching for gflags build directories exported with CMake.
# -- Failed to find gflags - Failed to find an installed/exported CMake configuration for gflags, will perform search for installed gflags components.

ln -s /usr/lib/python2.7/dist-packages/vtk/libvtkRenderingPythonTkWidgets.aarch64-linux-gnu.so /usr/lib/aarch64-linux-gnu/libvtkRenderingPythonTkWidgets.so
ln -s /use/bin/vtk6 /usr/bin/vtk
ln -s /usr/lib/aarch64-linux-gnu/libvtkCommonCore-6.2.so /usr/lib/libvtkproj4.so

#ln -s /usr/local/cuda/targets/aarch64-linux/lib/stubs/libcuda.so /usr/local/cuda/targets/aarch64-linux/lib/stubs/libcuda.so.1

sed -i 's|/lib/python/dist-packages/libvtkgdcmPython.so|/lib/python2.7/dist-packages/libvtkgdcmPython.aarch64-linux-gnu.so|g' /usr/lib/aarch64-linux-gnu/gdcm-2.6/GDCMTargets-none.cmake

sed -i 's|/lib/aarch64-linux-gnu/libvtkgdcmsharpglue.so|/lib/cli/vtkgdcm-sharp-2.6/libvtkgdcmsharpglue.so|g' /usr/lib/aarch64-linux-gnu/gdcm-2.6/GDCMTargets-none.cmake

