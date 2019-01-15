# Install on PC

Install
* Ubuntu 16.04
* Intel Network Driver
* NVIDIA Graphics Driver
* CUDA deviceQuery
* SSH
* Docker-ce
* NVIDIA Docker


## Ubuntu 16.04
My target is to run Autoware on [Jetson Xavier](https://developer.nvidia.com/jetson-xavier).  
JetPack is an OS installer for Jetson TX1/TX2, and the base OS is Ubuntu 16.04.  
My plan to use docker on PC, its base OS is Ubuntu 16.04 same as JetPack OS version.  
Docker shares the kernel image on PC. Therefore, it is better to use Ubuntu 16.04 on PC as well.  

<hr>

AutowareをJetson Xavierで動かす事を目標にしています。  
JetPackはJetson TX1/TX2のOSインストーラですが、ベースOSはUbuntu 16.04です。  
PCではDockerを利用する予定で、dockerのベースOSはJetPackのOSバージョンと同じUbuntu 16.04にします。  
DockerはPC上のカーネルイメージを共有するので、PCのOSもUbuntu 16.04にしておきます。  


## Intel Network Driver
Motherboard: ASRock B360M  
In order to recognize the LAN port of this motherboard, it is necessary to install the Intel network driver.  

```
lspci
00:1f.6 Ethernet controller: Intel Corporation Device 15bc (rev 10)

ifconfig
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:154 errors:0 dropped:0 overruns:0 frame:0
          TX packets:154 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:13450 (13.4 KB)  TX bytes:13450 (13.4 KB)
```
The lspci command recognizes it as an Intel Ethernet controller, but ifconfig does not display anything. Of course apt-get update also fails.  

Driver download:  
[https://downloadcenter.intel.com/download/15817](https://downloadcenter.intel.com/download/15817)  
Copy the downloaded file to Ubuntu Desktop PC with USB memory stick.  

Install:  
```
tar fxv e1000e-3.4.0.2.tar.gz
cd e1000e-3.4.0.2/src/
sudo make install
modprobe -r e1000e
modprobe e1000e
```
If you get an error with "modprobe e1000e", you need to disable Secure Boot in BIOS.  
> Required key not availabe  

[https://askubuntu.com/questions/762254/why-do-i-get-required-key-not-available-when-install-3rd-party-kernel-modules](https://askubuntu.com/questions/762254/why-do-i-get-required-key-not-available-when-install-3rd-party-kernel-modules)  

> Since Ubuntu kernel 4.4.0-20 the EFI_SECURE_BOOT_SIG_ENFORCE kernel config has been enabled. That prevents from loading unsigned third party modules if UEFI Secure Boot is enabled.  

In a typical BIOS, press the Del key to start the BIOS setting screen when the PC starts up.  

<hr>

マザーボード：ASRock B360M  
このマザーボードのLANポートを認識させるにはIntelネットワークドライバのインストールが必要になります。  

```
lspci
00:1f.6 Ethernet controller: Intel Corporation Device 15bc (rev 10)

ifconfig
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:154 errors:0 dropped:0 overruns:0 frame:0
          TX packets:154 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:13450 (13.4 KB)  TX bytes:13450 (13.4 KB)
```

lspciコマンドではIntel Ethernet controllerと認識されていますが、ifconfigでは何も表示されません。もちろんapt-get updateも失敗します。  
ドライバダウンロード：  
[https://downloadcenter.intel.com/download/15817](https://downloadcenter.intel.com/download/15817)  
ダウンロードしたファイルをUSBメモリスティックを使ってUbuntuデスクトップPCにコピーしてください。  

インストール：  
```
tar fxv e1000e-3.4.0.2.tar.gz
cd e1000e-3.4.0.2/src/
sudo make install
modprobe -r e1000e
modprobe e1000e
```
"modprobe e1000e"の実行でエラーが発生した場合は、BIOS設定のSecure Bootをdisableにする必要があります。  
> Required key not availabe  

[https://askubuntu.com/questions/762254/why-do-i-get-required-key-not-available-when-install-3rd-party-kernel-modules](https://askubuntu.com/questions/762254/why-do-i-get-required-key-not-available-when-install-3rd-party-kernel-modules)  

>Since Ubuntu kernel 4.4.0-20 the EFI_SECURE_BOOT_SIG_ENFORCE kernel config has been enabled. That prevents from loading unsigned third party modules if UEFI Secure Boot is enabled.  
>Kernel 4.4.0-20以降のカーネルは、BIOSのUEFI Secure Bootが有効化されていると、署名されていないthird party製モジュールをロード出来なくなりました。  

一般的なBIOSは、PC起動時にDELキーを押すことでBIOS設定画面に移ります。  


## SSH
```
apt-get install ssh

# before
#   PermitRootLogin without-password
# after
#   PermitRootLogin no
sed -i 's/^PermitRootLogin without-password$/PermitRootLogin no/g' /etc/ssh/sshd_config
```


## NVIDIA Graphics Driver
```
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sh -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
apt-get update && apt-get install -y --no-install-recommends cuda-drivers

nvidia-modprobe --version
# nvidia-modprobe:  version 396.26  (root@eris-linux-build008)  Mon Apr 30 16:01:56 PDT 2018
```


## CUDA deviceQuery
```
# need nvidia-driver. so this is on host.
apt-get install -y cuda-toolkit-9-0 
cd /usr/local/cuda-9.0/samples/1_Utilities/deviceQuery \
&& make \
&& mkdir -p /usr/local/cuda/extras/demo_suite \
&& ln -s /usr/local/cuda-9.0/samples/1_Utilities/deviceQuery/deviceQuery /usr/local/cuda/extras/demo_suite \
&& /usr/local/cuda/extras/demo_suite/deviceQuery
```

## Docker-ce
[https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)    
```
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce

docker run --rm hello-world
```


## NVIDIA Docker
Autoware 1.8.0 or later needs nvidia-docker2.<br>
[https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0))<br>
[https://nvidia.github.io/nvidia-docker/](https://nvidia.github.io/nvidia-docker/)
```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
```

```
sudo apt-get install nvidia-docker2
sudo pkill -SIGHUP dockerd
# Test nvidia-smi
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
```

## ERROR CASE:
nvidia-docker2 may not correspond to the latest docker version. If apt-get install nvidia-docker2 gets an error like the following, you need to adjust the version of docker-ce to nvidia-docker2.
```
apt-get install nvidia-docker2
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 nvidia-docker2 : Depends: docker-ce (= 5:18.09.0~3-0~ubuntu-xenial) but 5:18.09.1~3-0~ubuntu-xenial is to be installed or
                           docker-ee (= 5:18.09.0~3-0~ubuntu-xenial) but it is not installable
E: Unable to correct problems, you have held broken packages.
```

```
# check avaiable docker versions
sudo apt-cache madison nvidia-docker2
sudo apt-cache madison docker-ce
# Install docker with specified version
sudo apt-get install docker-ce="5:18.09.0~3-0~ubuntu-xenial"
sudo apt-get install nvidia-docker2
```
