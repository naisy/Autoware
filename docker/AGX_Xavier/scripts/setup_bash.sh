#!/bin/bash
########################################
# .bashrc (login/root)
########################################
# sed
# escape characters \'$.*/[]^
# 1. Write the regex between single quotes.
# 2. \ -> \\
# 3. ' -> '\''
# 4. Put a backslash before $.*/[]^ and only those characters.

####################
# login user
####################
#-    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#+    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[01;37m\]\h\[\033[00;00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '
#-    alias ls='ls --color=auto'
#+    alias ls='ls -asiF --color=auto'
sed -i 's/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\\[\\033\[01;37m\\\]\\h\\\[\\033\[00;00m\\\]:\\\[\\033\[01;35m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/g' /home/$(getent passwd 1000 | cut -d: -f1)/.bashrc
sed -i 's/alias ls='\''ls --color=auto'\''/alias ls='\''ls -asiF --color=auto'\''/g' /home/$(getent passwd 1000 | cut -d: -f1)/.bashrc

localedef -i en_US -f UTF-8 en_US.UTF-8

cat <<EOF>> /home/$(getent passwd 1000 | cut -d: -f1)/.bashrc

export PATH=/usr/local/cuda-10.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:/usr/local/lib
complete -d cd
EOF

####################
# root user
####################
#-    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#+    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;37m\]\u@\[\033[01;32m\]\h\[\033[00;00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '
#-    alias ls='ls --color=auto'
#+    alias ls='ls -asiF --color=auto'
#-    xterm-color) color_prompt=yes;;
#+    xterm-color|*-256color) color_prompt=yes;;
sed -i 's/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;37m\\\]\\u@\\\[\\033\[01;32m\\\]\\h\\\[\\033\[00;00m\\\]:\\\[\\033\[01;35m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/g' /root/.bashrc
sed -i 's/alias ls='\''ls --color=auto'\''/alias ls='\''ls -asiF --color=auto'\''/g' /root/.bashrc
sed -i 's/xterm-color) color_prompt=yes;;/xterm-color|\*-256color) color_prompt=yes;;/g' /root/.bashrc

cat <<EOF>> /root/.bashrc

export PATH=/usr/local/cuda-10.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:/usr/local/lib
complete -d cd
EOF

