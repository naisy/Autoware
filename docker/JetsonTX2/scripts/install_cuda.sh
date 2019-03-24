########################################
# Add CUDA9 ldconfig path
########################################
echo /usr/local/cuda-9.0/targets/aarch64-linux/lib > /etc/ld.so.conf.d/cuda-9-0.conf
ldconfig
