########################################
# Add Device permmission
########################################
#getfacl /dev/video0 
#setfacl -m u:ubuntu:rw- /dev/video0
#getfacl /dev/video0 

setfacl -m u:ubuntu:rw- /dev/nvhost-as-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-ctrl
setfacl -m u:ubuntu:rw- /dev/nvhost-ctrl-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-ctxsw-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-dbg-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-prof-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-sched-gpu
setfacl -m u:ubuntu:rw- /dev/nvhost-tsg-gpu
setfacl -m u:ubuntu:rw- /dev/nvmap
setfacl -m u:ubuntu:rw- /dev/snd
