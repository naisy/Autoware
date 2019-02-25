#!/bin/bash
########################################
# OpenCV package build/install
########################################
# NEED 15GB disk space with contrib
SCRIPT_DIR=$(cd $(dirname $0); pwd)

c++ -x c++ -dM -E - < /dev/null | grep cplus

# OpenCV 3.3.1 issues
#/compile/opencv-3.3.1/build/3rdparty/ippicv/ippiw_lnx/src/iw_own.c
#error: 'PTHREAD_MUTEX_RECURSIVE' undeclared (first use in this function)
#error: 'PATH_MAX' undeclared here (not in a function)
# fix issues:
#sed -i 's/PTHREAD_MUTEX_RECURSIVE/PTHREAD_MUTEX_RECURSIVE_NP/g' /compile/opencv-3.3.1/build/3rdparty/ippicv/ippiw_lnx/src/iw_own.c
#sed -i 's/#include <limits.h>/#include <linux\/limits.h>/g' /compile/opencv-3.3.1/3rdparty/ittnotify/src/ittnotify/ittnotify_static.c 
SOURCE_PATH=/compile
VERSION=3.3.1
CUDA_COMPUTE_CAPABILITIES=6.2 # Xavier:7.2, TX2:6.2, TX1:5.3
CUDA_COMPUTE_CAPABILITY
FAKE_INSTALL_PATH=/package_build

mkdir -p ${SOURCE_PATH} \
&& rm -rf ${SOURCE_PATH}/opencv-${VERSION} \
&& rm -rf ${SOURCE_PATH}/opencv_contrib-${VERSION} \
&& rm -rf ${FAKE_INSTALL_PATH}

if [ ! -e ${SOURCE_PATH}/opencv-${VERSION}.zip ]; then
    wget --no-check-certificate https://github.com/opencv/opencv/archive/${VERSION}.zip -O ${SOURCE_PATH}/opencv-${VERSION}.zip
fi
if [ ! -e ${SOURCE_PATH}/opencv_contrib-${VERSION}.zip ]; then
    wget https://github.com/opencv/opencv_contrib/archive/${VERSION}.zip -O ${SOURCE_PATH}/opencv_contrib-${VERSION}.zip
fi
cd ${SOURCE_PATH} \
&& unzip opencv-${VERSION}.zip \
&& unzip opencv_contrib-${VERSION}.zip \
&& mkdir -p opencv-${VERSION}/build \
&& cd opencv-${VERSION}/build

time cmake \
     -D OPENCV_EXTRA_MODULES_PATH=${SOURCE_PATH}/opencv_contrib-${VERSION}/modules \
     -D ENABLE_NEON=ON \
     -D ENABLE_FAST_MATH=ON \
     -D ENABLE_CXX11=OFF \
     -D HAVE_CXX11=OFF \
     -D CMAKE_C_FLAGS="-march=native" \
     -D CMAKE_CXX_FLAGS="-march=native" \
     -D CMAKE_BUILD_TYPE=RELEASE \
     -D CMAKE_INSTALL_PREFIX=/usr/local \
     -D WITH_1394=ON \
     -D WITH_CAROTENE=ON \
     -D WITH_CUBLAS=ON \
     -D WITH_CUDA=ON \
     -D WITH_CUFFT=ON \
     -D WITH_NVCUVID=ON \
     -D WITH_EIGEN=ON \
     -D WITH_FFMPEG=ON \
     -D WITH_GPHOTO2=ON \
     -D WITH_GIGEAPI=OFF \
     -D WITH_GSTREAMER=ON \
     -D WITH_GSTREAMER_0_10=OFF \
     -D WITH_GTK=OFF \
     -D WITH_INTELPERC=OFF \
     -D WITH_IPP=OFF \
     -D WITH_IPP_A=OFF \
     -D WITH_JPEG=ON \
     -D WITH_ZLIB=ON \
     -D WITH_JASPER=ON \
     -D WITH_PNG=ON \
     -D WITH_OPENEXR=ON \
     -D WITH_WEBP=ON \
     -D WITH_GDAL=ON \
     -D WITH_GDCM=ON \
     -D WITH_TIFF=ON \
     -D WITH_OPENCL=ON \
     -D WITH_OPENCLAMDBLAS=ON \
     -D WITH_OPENCLAMDFFT=ON \
     -D WITH_OPENCL_SVM=ON \
     -D WITH_OPENGL=ON \
     -D WITH_OPENMP=OFF \
     -D WITH_OPENNI=OFF \
     -D WITH_OPENNI2=ON \
     -D WITH_PTHREADS_PF=ON \
     -D WITH_PVAPI=OFF \
     -D WITH_QT=ON \
     -D WITH_TBB=ON \
     -D WITH_UNICAP=OFF \
     -D WITH_V4L=ON \
     -D WITH_LIBV4L=ON \
     -D WITH_VTK=ON \
     -D WITH_XIMEA=OFF \
     -D WITH_XINE=ON \
     -D CUDA_ARCH_BIN=$CUDA_COMPUTE_CAPABILITIES \
     -D CUDA_ARCH_PTX="" \
     -D CUDA_FAST_MATH=ON \
     -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES --expt-relaxed-constexpr" \
     -D CUDA_CUDA_LIBRARY=/usr/lib/aarch64-linux-gnu/libcuda.so \
     -D BUILD_EXAMPLES=OFF \
     -D BUILD_DOCS=OFF \
     -D BUILD_TESTS=OFF \
     -D BUILD_PREF_TESTS=OFF \
     -D BUILD_opencv_python2=ON \
     -D BUILD_opencv_python3=OFF \
     -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
     -D PYTHON2_EXECUTABLE=$(which python2) \
     -D PYTHON2_NUMPY_INCLUDE_DIRS=/usr/local/lib/python2.7/dist-packages/numpy/core/include \
     -D PYTHON3_EXECUTABLE=$(which python3) \
     -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/dist-packages/numpy/core/include \
     ..
sed -i 's/PTHREAD_MUTEX_RECURSIVE/PTHREAD_MUTEX_RECURSIVE_NP/g' $SOURCE_PATH/opencv-$VERSION/build/3rdparty/ippicv/ippiw_lnx/src/iw_own.c
sed -i 's/#include <limits.h>/#include <linux\/limits.h>/g' $SOURCE_PATH/opencv-$VERSION/3rdparty/ittnotify/src/ittnotify/ittnotify_static.c
time make -j $(($(nproc) + 1))
time make install DESTDIR=$FAKE_INSTALL_PATH/opencv-${VERSION}/

mkdir -p $FAKE_INSTALL_PATH/opencv-${VERSION}/etc/ld.so.conf.d
echo "/usr/local/lib" > $FAKE_INSTALL_PATH/opencv-${VERSION}/etc/ld.so.conf.d/opencv.conf


mkdir -p $FAKE_INSTALL_PATH/opencv-${VERSION}/DEBIAN \
&& cd $FAKE_INSTALL_PATH \
&& echo -e "Source: opencv-${VERSION}
Package: opencv
Version: ${VERSION}
Priority: optional
Maintainer: Yoshiroh Takanashi <takanashi@gclue.jp>
Architecture: arm64
Depends: 
Description: OpenCV version ${VERSION}"\
> $FAKE_INSTALL_PATH/opencv-${VERSION}/DEBIAN/control \
&& fakeroot dpkg-deb --build opencv-${VERSION}

dpkg -i $FAKE_INSTALL_PATH/opencv-${VERSION}.deb
ldconfig

rm -rf $SOURCE_PATH/opencv-$VERSION.zip
rm -rf $SOURCE_PATH/opencv-$VERSION
rm -rf $SOURCE_PATH/opencv_contrib-$VERSION.zip
rm -rf $SOURCE_PATH/opencv_contrib-$VERSION
rm -rf $FAKE_INSTALL_PATH/opencv-$VERSION
