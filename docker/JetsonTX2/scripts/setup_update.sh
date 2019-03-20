########################################
# Ubuntu Package Update
########################################
apt-get update
time apt-get dist-upgrade -y
apt-get install -y htop locate vim arp-scan
apt autoremove -y
