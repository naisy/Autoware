#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH_FILE=.docker.xauth
HOST_USER_HOME=/home/$(getent passwd 1000 | cut -d: -f1)
HOST_USER_XAUTH=$HOST_USER_HOME/$XAUTH_FILE
HOST_ROOT_XAUTH=/root/$XAUTH_FILE
HOST_MOUNT_PATH=$HOST_USER_HOME/.autoware
DOCKER_USER_HOME=/home/ubuntu
DOCKER_ROOT_HOME=/root
DOCKER_USER_XAUTH=$DOCKER_USER_HOME/$XAUTH_FILE
DOCKER_ROOT_XAUTH=$DOCKER_ROOT_HOME/$XAUTH_FILE
DOCKER_MOUNT_PATH=/home/ubuntu/.autoware

nvidia-docker run \
    -it --rm \
    -v $XSOCK:$XSOCK:rw \
    -v $HOST_USER_XAUTH:$DOCKER_USER_XAUTH:rw \
    -v $HOST_ROOT_XAUTH:$DOCKER_ROOT_XAUTH:rw \
    -v $HOST_MOUNT_PATH:$DOCKER_MOUNT_PATH \
    -e DISPLAY=${DISPLAY} \
    --privileged \
    -u ubuntu \
    --network=host \
autoware:1.6.3
