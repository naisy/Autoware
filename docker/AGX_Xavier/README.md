# Install
After flash JetPack 4.4.1
GUI login. (not remote login)

## Xauthority settings
* login user
```
touch $HOME/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $HOME/.docker.xauth nmerge -
```
* root user
```
sudo su
touch $HOME/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $HOME/.docker.xauth nmerge -
```

## Docker on SSD
After ssd mount:  
(/media/ubuntu/ssd250/)  
```
sudo service stop docker
sudo mv /var/lib/docker /media/ubuntu/ssd250
sudo vi /etc/docker/daemon.json
```
* before
```
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```
* after
```
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": [],
            "data-root": "/media/ubuntu/ssd250/docker"
        }
    }
}
```
```
sudo service docker start
```


## AGX Xavier Setup
```
sudo apt-get update
sudo apt-get install git
sudo nvpmodel -m 0
sudo jetson_clocks
```

```
mkdir ~/data
mkdir ~/github
cd ~/github

git clone https://github.com/naisy/Autoware
```

## Docker
* Make base image
```
cd ~/github/Autoware/docker/AGX_Xavier
sudo docker build -t naisy/jetson-xavier-jp441-ml -f Dockerfile-l4t-ml .
```

* Install Autoware
copy script to shared directory.
```
cp ~/github/Autoware/docker/AGX_Xavier/scripts/install_autoware-1.14.0.sh ~/data/
cd ~/github/Autoware/docker/AGX_Xavier
sudo ./run
```
install autoware in the docker container. (run on docker)
```
cd ~/data
./install_autoware-1.14.0.sh
```

## Launch Autoware
```
cd ~/autoware.ai
source install/setup.bash
roslaunch runtime_manager runtime_manager.launch
```

