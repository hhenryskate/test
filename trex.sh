#!/bin/bash
sed -i -e 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/g' /etc/apt/apt.conf.d/20auto-upgrades
sudo apt install nvidia-cuda-toolkit -y
wget https://github.com/NVIDIA/cuda-samples/archive/v11.1.tar.gz
tar xvf v11.1.tar.gz
cd cuda-samples-11.1
export CUDA_PATH=/usr
source ~/.bashrc
export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
make SMS="75"
cd && mkdir trex && cd trex
wget https://github.com/trexminer/T-Rex/releases/download/0.20.0/t-rex-0.20.0-linux.tar.gz
tar -xvf t-rex-0.20.0-linux.tar.gz && cd trex
chmod 775 ETH-2miners.sh
cp ETH-2miners.sh /usr/local/bin
sed -i -e 's/eth.2miners.com:2020/eu-eth.hiveon.net:4444/g' /usr/local/bin/ETH-2miners.sh
ETH-2miners.sh
