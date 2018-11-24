# Build Autoware Docker.

## PC Requirements
* Ubuntu 16.04
* NVIDIA Driver 384 or later.
* Docker docker-ce/xenial,now 18.06.1~ce~3-0~ubuntu amd64.
* NVIDIA Docker2 

## PC Setup
[Install on PC](INSTALL.md)

## docker build
```
sudo su
docker build -t autoware:1.9.1 -f Dockerfile.1.9.1 .
```

## Xauthority settings
* PC login user
user must be uid:1000, gid:1000.
```
touch $HOME/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $HOME/.docker.xauth nmerge -
```
* PC root user
```
sudo su
touch $HOME/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $HOME/.docker.xauth nmerge -
```

## Sample data
Let's forget.  

## docker run
```
sudo su
docker run --runtime=nvidia \
    -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /home/$(getent passwd 1000 | cut -d: -f1)/.docker.xauth:/home/ubuntu/.docker.xauth:rw \
    -v /root/.docker.xauth:/root/.docker.xauth:rw \
    -v /home/$(getent passwd 1000 | cut -d: -f1)/.autoware:/home/ubuntu/.autoware \
    -v /home/$(getent passwd 1000 | cut -d: -f1)/notebooks:/home/ubuntu/notebooks \
    -e DISPLAY=${DISPLAY} \
    -v /dev/bus/usb/:/dev/bus/usb \
    --privileged \
    -u ubuntu \
    --network=host \
autoware:1.9.1
```

## Autoware1.9.1
* Ubuntu 16.04
* CUDA9
* CUDNN7
* Python2.7
* OpenCV3.3.1
* OpenCVContrib3.3.1
* ROS Kinetic
* Autoware1.9.1
