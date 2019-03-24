#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH_FILE=.docker.xauth
HOST_USER_HOME=/home/$(getent passwd 1000 | cut -d: -f1)
HOST_USER_XAUTH=$HOST_USER_HOME/$XAUTH_FILE
HOST_ROOT_XAUTH=/root/$XAUTH_FILE
HOST_MOUNT_PATH=/media/ubuntu/SSD_M2/AutowareData
DOCKER_USER_HOME=/home/ubuntu
DOCKER_ROOT_HOME=/root
DOCKER_USER_XAUTH=$DOCKER_USER_HOME/$XAUTH_FILE
DOCKER_ROOT_XAUTH=$DOCKER_ROOT_HOME/$XAUTH_FILE
DOCKER_MOUNT_PATH=/home/ubuntu/AutowareData

docker run \
    -it \
    -v $XSOCK:$XSOCK:rw \
    -v $HOST_USER_XAUTH:$DOCKER_USER_XAUTH:rw \
    -v $HOST_ROOT_XAUTH:$DOCKER_ROOT_XAUTH:rw \
    -v $HOST_MOUNT_PATH:$DOCKER_MOUNT_PATH \
    -v /usr/local/cuda/:/usr/local/cuda/ \
    -v /usr/local/cuda-9.0/:/usr/local/cuda-9.0/ \
    -v /usr/share/doc/nvidia-tegra/:/usr/share/doc/nvidia-tegra/ \
    -v /usr/lib/aarch64-linux-gnu/tegra/:/usr/lib/aarch64-linux-gnu/tegra/ \
    -v /usr/lib/aarch64-linux-gnu/tegra-egl/:/usr/lib/aarch64-linux-gnu/tegra-egl/ \
    -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
    --device /dev/nvhost-as-gpu \
    --device /dev/nvhost-ctrl \
    --device /dev/nvhost-ctrl-gpu \
    --device /dev/nvhost-ctxsw-gpu \
    --device /dev/nvhost-dbg-gpu \
    --device /dev/nvhost-gpu \
    --device /dev/nvhost-prof-gpu \
    --device /dev/nvhost-sched-gpu \
    --device /dev/nvhost-tsg-gpu \
    --device /dev/nvmap \
    --device /dev/snd \
    -e DISPLAY \
    -e QT_GRAPHICSSYSTEM=native \
    -e QT_X11_NO_MITSHM=1 \
    -e DISPLAY=${DISPLAY} \
    --privileged \
    -u ubuntu \
    --network=host \
naisy/tx2-jp33-autoware:1.9.1
