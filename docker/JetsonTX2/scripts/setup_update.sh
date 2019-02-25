########################################
# Ubuntu Package Update
########################################
apt-get update
time apt-get dist-upgrade -y
apt-get install -y htop locate vim
apt autoremove -y
