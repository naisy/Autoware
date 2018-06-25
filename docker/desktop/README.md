# Build Autoware Docker.

## PC Requirements
* Ubuntu 16.04
* NVIDIA Driver 384 or later.
* Docker 1.9 or later.
* NVIDIA Docker 

## docker build
```
sudo su
docker build -t autoware:1.6.3 -f Dockerfile.1.6.3 .
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
* PC login user
```
mkdir $HOME/.autoware
cd $HOME/.autoware

wget http://db3.ertl.jp/autoware/sample_data/my_launch.sh
wget http://db3.ertl.jp/autoware/sample_data/sample_moriyama_data.tar.gz
wget http://db3.ertl.jp/autoware/sample_data/sample_moriyama_150324.tar.gz
tar xf sample_moriyama_data.tar.gz
tar xf sample_moriyama_150324.tar.gz
chmod 755 ./my_launch.sh
./my_launch.sh
```


## docker run
```
sudo su
nvidia-docker run \
    -it \
    --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /home/$(getent passwd 1000 | cut -d: -f1)/.docker.xauth:/home/ubuntu/.docker.xauth:rw \
    -v /root/.docker.xauth:/root/.docker.xauth:rw \
    -v /home/$(getent passwd 1000 | cut -d: -f1)/.autoware:/home/ubuntu/.autoware:rw \
    -e DISPLAY=${DISPLAY} \
    --privileged \
    -u ubuntu \
    --network=host \
autoware:1.6.3
```

## Autoware1.7.0
* Ubuntu 16.04
* CUDA9
* CUDNN7
* Python2.7
* OpenCV3.3.1
* OpenCVContrib3.3.1
* ROS Kinetic
* Autoware1.7.0

## Autoware1.6.3
* Ubuntu 16.04
* CUDA8
* CUDNN6
* Python2.7
* OpenCV3.2.0
* OpenCVContrib3.2.0
* ROS Kinetic
* Autoware1.6.3
