# Edit docker storage to M.2 SSD
# vi /lib/systemd/system/docker.service
# ExecStart=/usr/bin/dockerd -H fd:// -g /media/ubuntu/SSD_M2/docker
# service docker stop; systemctl daemon-reload; service docker start;

# time docker build -t naisy/tx2-py27-autoware:1.9.1 -f Dockerfile
# docker login
# docker push naisy/tx2-py27-autoware:1.9.1
# need nvidia-driver 410.48 or later for cuda10 on host os.

# Need separate build.
#
########################################
# Underlying OS repogitory
########################################
FROM arm64v8/ubuntu:16.04

########################################
# Maintainer Info
########################################
MAINTAINER Yoshiroh Takanashi <takanashi@gclue.jp>


########################################
# LABEL
########################################
LABEL Description="Autoware for Jetson TX2" Vendor="GClue" Version="1.0"


ARG DEBIAN_FRONTEND=noninteractive
# Because somethime the repository is 404, use with --fix-missing option.
RUN apt-get --fix-missing update && apt-get install -y apt-utils



########################################
# XAuthority
########################################
RUN apt-get update && apt-get install -y sudo xauth xterm
#Add new sudo user
ENV USERNAME ubuntu
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        # Replace 1000 with your user/group id
        usermod  --uid 1000 $USERNAME && \
        groupmod --gid 1000 $USERNAME

########################################
# bash setting
########################################
# sed
# escape characters \'$.*/[]^
# 1. Write the regex between single quotes.
# 2. \ -> \\
# 3. ' -> '\''
# 4. Put a backslash before $.*/[]^ and only those characters.

####################
# USER
####################
# before
# #force_color_prompt=yes
# after
# force_color_prompt=yes

# before
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# after
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[01;37m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '

# before
# alias ls='ls --color=auto'
# after
# alias ls='ls -asiF --color=auto'

RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/$USERNAME/.bashrc \
&& sed -i 's/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\\[\\033\[01;31m\\\]autoware\\\[\\033\[00m\\\]:\\\[\\033\[01;35m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/g' /home/$USERNAME/.bashrc \
&& sed -i 's/alias ls='\''ls --color=auto'\''/alias ls='\''ls -asiF --color=auto'\''/g' /home/$USERNAME/.bashrc \
&& echo 'alias xterm='"'"'xterm -fa '"'"'Monospace'"'"' -fs 10'"'"'\n' >> /home/$USERNAME/.bashrc \
&& echo 'export XAUTHORITY=$HOME/.docker.xauth' >> /home/$USERNAME/.bashrc \
&& echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/lib' >> /home/$USERNAME/.bashrc \
&& echo 'export __GL_PERFMON_MODE=1' >> /home/$USERNAME/.bashrc \
&& echo 'LANG=en_US.UTF-8' >> /home/$USERNAME/.bashrc \
&& echo 'cd' >> /home/ubuntu/.bashrc

####################
# ROOT
####################
# before
#    xterm-color) color_prompt=yes;;
# after
#    xterm-color|*-256color) color_prompt=yes;;

# before
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# after
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;37m\]\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '

# before
# alias ls='ls --color=auto'
# after
# alias ls='ls -asiF --color=auto'

RUN sed -i 's/xterm-color) color_prompt=yes;;/xterm-color|\*-256color) color_prompt=yes;;/g' /root/.bashrc \
&& sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc \
&& sed -i 's/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;37m\\\]\\u@\\\[\\033\[01;31m\\\]autoware\\\[\\033\[00m\\\]:\\\[\\033\[01;35m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/g' /root/.bashrc \
&& sed -i 's/alias ls='\''ls --color=auto'\''/alias ls='\''ls -asiF --color=auto'\''/g' /root/.bashrc \
&& echo 'alias xterm='"'"'xterm -fa '"'"'Monospace'"'"' -fs 10'"'"'\n' >> /root/.bashrc \
&& echo 'export XAUTHORITY=$HOME/.docker.xauth' >> /root/.bashrc \
&& echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/lib' >> /root/.bashrc \
&& echo 'export __GL_PERFMON_MODE=1' >> /root/.bashrc \
&& echo 'LANG=en_US.UTF-8' >> /root/.bashrc


#########################################
# .dircolors
########################################
COPY scripts /home/ubuntu/scripts/
RUN find /home/$USERNAME/scripts/ -type f | xargs -n1 sed -i "s/\r//g" \
&& cd /home/$USERNAME/scripts/ \
&& chmod 755 *.sh \
&& ./setup_dircolors.sh


########################################
# Default Command
########################################
CMD bash -c "/usr/bin/xterm -fa 'Monospace' -fs 10"

### END GUI ###


########################################
# Command Tools Install
########################################
RUN apt-get -y install vim less htop unzip locate git curl wget arp-scan \
&& apt-get install -y software-properties-common


########################################
# Add Java8 repository
########################################
RUN apt-get update \
&& add-apt-repository -y ppa:webupd8team/java \
&& apt-get update \
&& echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections \
&& apt-get install -y oracle-java8-installer


########################################
# Python 2.7 Install
########################################
RUN apt-get install -y python2.7 python2.7-dev \
&& update-alternatives --install /usr/bin/python python /usr/bin/python2.7 0


#c++ -x c++ -dM -E - < /dev/null | grep cplus
#define __cplusplus 199711L


########################################
# Package Install
########################################
#RUN /home/$USERNAME/scripts/install_packages.sh


########################################
# Pip Install
########################################
#RUN /home/$USERNAME/scripts/install_pip.sh


########################################
# OpenCV Install
########################################
#RUN /home/$USERNAME/scripts/build_opencv_3.3.1.sh


########################################
# Docker run xterm 
########################################
#docker run \
#    --runtime=nvidia \
#    -it \
#    -v /media/ubuntu/SSD_M2/AutowareData:/home/ubuntu/AutowareData
#    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#    -v /home/$(getent passwd 1000 | cut -d: -f1)/.docker.xauth:/home/ubuntu/.docker.xauth:rw \
#    -v /root/.docker.xauth:/root/.docker.xauth:rw \
#    -v /usr/local/cuda:/usr/local/cuda \
#    -e "DISPLAY" \
#    --privileged \
#    --network=host \
#    --user ubuntu \
#    naisy/tx2-py27-autoware:1.9.1
