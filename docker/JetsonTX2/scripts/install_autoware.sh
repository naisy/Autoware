########################################
# Install Autoware
########################################
VERSION="tags/1.9.1"
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
&& source /opt/ros/kinetic/setup.bash \
&& catkin_init_workspace \
&& cd ../ \
&& ./catkin_make_release -DCATKIN_BLACKLIST_PACKAGES="autoware_driveworks_interface;autoware_driveworks_gmsl_interface" -j3 \
&& mkdir -p $HOME/.local/share

echo "source $INSTALL_PATH/Autoware/ros/devel/setup.bash" >> /home/ubuntu/.bashrc \
&& sudo sh -c 'echo "source $INSTALL_PATH/Autoware/ros/devel/setup.bash" >> /root/.bashrc'

# Change Terminal Color
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#000000"



########################################
# Resize car model
########################################
# sed
# escape characters \'$.*/[]^
# 1. Write the regex between single quotes.
# 2. \ -> \\
# 3. ' -> '\''
# 4. Put a backslash before $.*/[]^ and only those characters.
#
# before:
#        <mesh filename="package://model_publisher/../../../.config/model/CAR_original.dae" scale="1.0 1.0 1.0"/>
# after:
#        <mesh filename="package://model_publisher/../../../.config/model/CAR_original.dae" scale="0.2 0.2 0.2"/>
TARGET=$INSTALL_PATH/Autoware/ros/src/.config/model/default.urdf
BEFORE="        <mesh filename=\"package:\/\/model_publisher\/\.\.\/\.\.\/\.\.\/\.config\/model\/CAR_original\.dae\" scale=\"1\.0 1\.0 1\.0\"\/>"
AFTER="        <mesh filename=\"package://model_publisher/../../../.config/model/CAR_original.dae\" scale=\"0.2 0.2 0.2\"/>"
echo "${BEFORE}"
echo "${AFTER}"

sed -i 's|^'"${BEFORE}"'$|'"${AFTER}"'|g' $TARGET


rm -rf /var/lib/apt/lists/*
