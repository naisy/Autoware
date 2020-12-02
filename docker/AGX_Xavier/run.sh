#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH_FILE=.docker.xauth
HOST_USER_HOME=/home/$(getent passwd 1000 | cut -d: -f1)
HOST_USER_XAUTH=$HOST_USER_HOME/$XAUTH_FILE
HOST_ROOT_XAUTH=/root/$XAUTH_FILE
HOST_MOUNT_PATH=$HOST_USER_HOME/data
DOCKER_USER_HOME=/home/jetson
DOCKER_ROOT_HOME=/root
DOCKER_USER_XAUTH=$DOCKER_USER_HOME/$XAUTH_FILE
DOCKER_ROOT_XAUTH=$DOCKER_ROOT_HOME/$XAUTH_FILE
DOCKER_MOUNT_PATH=/home/jetson/data

if [ ! -d "$HOST_MOUNT_PATH" ]; then
    mkdir $HOST_MOUNT_PATH
    chown $(getent passwd 1000 | cut -d: -f1):$(getent group 1000 | cut -d: -f1) $HOST_MOUNT_PATH
fi

IMG=naisy/jetson-xavier-jp441-ml

docker run \
    --runtime=nvidia \
    -it \
    -v $XSOCK:$XSOCK:rw \
    -v $HOST_USER_XAUTH:$DOCKER_USER_XAUTH:rw \
    -v $HOST_ROOT_XAUTH:$DOCKER_ROOT_XAUTH:rw \
    -v $HOST_MOUNT_PATH:$DOCKER_MOUNT_PATH \
    -e DISPLAY \
    -e QT_GRAPHICSSYSTEM=native \
    -e QT_X11_NO_MITSHM=1 \
    -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
    -v /dev/:/dev/ \
    -u jetson \
    --privileged \
    --network=host \
$IMG

