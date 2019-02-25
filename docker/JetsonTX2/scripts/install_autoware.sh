########################################
# Install Autoware
########################################
VERSION="tags/1.10.0"
#INSTALL_PATH=/media/ubuntu/SSD_M2
INSTALL_PATH=$HOME

if [ ! -d "$INSTALL_PATH" ]; then
    echo "No install path: $INSTALL_PATH"
    exit
fi

cd $INSTALL_PATH \
&& git clone https://github.com/CPFL/Autoware $INSTALL_PATH/Autoware \
&& cd Autoware \
&& git checkout $VERSION \
&& cd ros/src \
&& git submodule update --init --recursive \
&& ls ./driveworks/packages/ \
&& sed -i 's/cameraparameters\.background=Eigen::Vector4d(0,0,0,1);/cameraparameters.background=Eigen::Vector4d(0.5,0.5,0.5,1);/g' $INSTALL_PATH/Autoware/ros/src/util/packages/RobotSDK/glviewer/GLViewer/glviewer.cpp \
&& grep -rl . -e '-lpthread' | xargs -n1 file | grep "ASCII text" | cut -d':' -f1 | xargs sed -i 's/-lpthread/-pthread/g' \
&& bash -c 'source /opt/ros/kinetic/setup.bash; catkin_init_workspace; cd ../; ./catkin_make_release -DCATKIN_BLACKLIST_PACKAGES="autoware_driveworks_interface;autoware_driveworks_gmsl_interface" -j3' \
&& mkdir -p $HOME/.local/share

#echo "source $INSTALL_PATH/Autoware/ros/devel/setup.bash" >> /home/ubuntu/.bashrc \
#&& sudo sh -c 'echo "source $INSTALL_PATH/Autoware/ros/devel/setup.bash" >> /root/.bashrc'
