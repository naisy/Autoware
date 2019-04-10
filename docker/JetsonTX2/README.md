# Install
After flash JetPack 3.3,
login as ubuntu user. (Not nvidia user.)

## TX2 Setup
```
sudo apt-get update
sudo apt-get install git
sudo nvpmodel -m 0
sudo ./jetson_clocks.sh
```

```
mkdir ~/github
cd ~/github

git clone https://github.com/naisy/Autoware
cd Autoware/docker/JetsonTX2/scripts
find ./ -type f | xargs -n1 sed -i "s/\r//g"
chmod 755 *.sh
sudo su
./setup.sh
```

## After reboot
### Xauthority settings
* ubuntu user
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

## Docker
```
sudo docker pull naisy/tx2-jp33-autoware:1.9.1
```
### if you don't have M.2 SSD
edit run.sh
```
vi ~/github/Autoware/docker/JetsonTX2/run.sh

# before
HOST_MOUNT_PATH=/media/ubuntu/SSD_M2/AutowareData
#after
HOST_MOUNT_PATH=/home/ubuntu/AutowareData
```

### if you have M.2 SSD
set automount and change default docker directory.
Sorry, document is japanese only. But you can see image and set automount.
[https://faboplatform.github.io/AutowareDocs/00.Install/00.TX2_setup/](https://faboplatform.github.io/AutowareDocs/00.Install/00.TX2_setup/)


### docker run
```
cd /home/ubuntu/github/Autoware/docker/JetsonTX2/
chmod 755 run.sh
sudo run.sh
```

## in docker container
### device permission
```
sudo su
./scripts/setfacl.sh
exit
```
This permission needs for rviz.

### launch autoware
```
cd Autoware/ros
./run
```

