########################################
# Add GL/EGL ldconfig path
########################################

#【発生した問題】
#docker autowareでrvizを起動しようとすると、以下のエラーが発生して起動しない。
#libGL error: No matching fbConfigs or visuals found
#libGL error: failed to load driver: swrast
#Could not initialize OpenGL for RasterGLSurface, reverting to RasterSurface.
#libGL error: No matching fbConfigs or visuals found
#libGL error: failed to load driver: swrast
#/home/ubuntu/Autoware/ros/src/util/packages/runtime_manager/../../../.config/rv#iz/cmd.sh: line 44:  2211 Segmentation fault      (core dumped) rosrun rviz rviz


#【原因】
#docker container内の
#/etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf
#が
#/usr/lib/aarch64-linux-gnu/mesa/ld.so.conf
#を参照しているのが原因。


#【解決方法】
#シンボリックリンク
#/etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf
#の参照先が
#/usr/lib/aarch64-linux-gnu/tegra/ld.so.conf
#になるように書き換える

apt-get install -y mesa-utils

rm /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf
ln -s /usr/lib/aarch64-linux-gnu/tegra/ld.so.conf /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf

rm /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf
ln -s /usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf
ldconfig

cd /usr/lib/aarch64-linux-gnu
rm libGL.so
ln -s tegra/libGL.so libGL.so
rm libGLESv2.so
ln -s tegra/libGLESv2.so libGLESv2.so

glxinfo | grep "OpenGL version"

#glxgears
