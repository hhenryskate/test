sudo apt update
sudo apt install ubuntu-desktop -y
sudo apt update
sudo apt install xubuntu-desktop -y
sudo apt install xrdp -y 
sudo adduser xrdp ssl-cert  
sudo ufw allow from 192.168.33.0/24 to any port 3389
sudo ufw allow 3389
