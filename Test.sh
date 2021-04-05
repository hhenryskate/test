# https://askubuntu.com/questions/799184/how-can-i-install-cuda-on-ubuntu-16-04
# https://www.perfacilis.com/blog/crypto-currency/mining-ethereum-on-ubuntu-with-ethminer.html
# https://gist.github.com/johnstcn/add029045db93e0628ad15434203d13c
# https://wiki.archlinux.org/index.php/NVIDIA/Tips_and_tricks

sudo apt update
sudo apt upgrade

sudo apt-get purge nvidia-cuda*
sudo apt-get purge nvidia-*
sudo apt-get install cmake git mesa-common-dev htop screen build-essential
sudo bash
 cat <<EOT >> /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOT

sudo update-initramfs -u

## Install CUDA
sudo sh cuda_9.1.85_387.26_linux.run --override

-   PATH includes /usr/local/cuda-9.1/bin
sudo vi /etc/environment

sudo bash
cat <<EOT >>  /etc/profile.d/cuda-toolkit.sh
export PATH="/usr/local/cuda-9.1/bin:$PATH"
EOT

printf "/usr/local/cuda-9.1/lib64\n" >> /etc/ld.so.conf 
exit

sudo sh cuda_9.1.85.1_linux.run

reboot now

nvcc --version
## Install Ethminer
git clone https://github.com/ethereum-mining/ethminer 
cd ethminer; git checkout tags/v0.13.0; mkdir build; cd build
cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF
cmake --build .
sudo make install

ethminer -U -M

ethminer -U -M --cuda-parallel-hash 4 -SP 2


# setup nvidia
sudo nvidia-xconfig --enable-all-gpus --cool-bits=31 --allow-empty-initial-configuration --connected-monitor=DFP-0
sudo cp /etc/X11/XF86Config /etc/X11/xorg.conf

cd  /usr/share/nvidia/
sudo mv nvidia-application-profiles-390.25-key-documentation nvidia-application-profiles-key-documentation
reboot now

# OverClock
export XAUTHORITY=/var/run/lightdm/root/:0 
export DISPLAY=:0
sudo nvidia-smi -pm ENABLED


# EVGA ###############
MEM=2000
CLO=150
MY_FAN=20
POWER=80

for GPU in 0 1; do
	sudo nvidia-smi -pl $POWER -i $GPU
	sudo nvidia-settings -a "[gpu:$GPU]/GPUPowerMizerMode=1"
	sudo nvidia-settings -a "[gpu:$GPU]/GPUFanControlState=1"
	sudo nvidia-settings -a "[fan:$GPU]/GPUTargetFanSpeed=$MY_FAN"
	sudo nvidia-settings -a "[gpu:${GPU}]/GPUGraphicsClockOffset[3]=${CLO}"
	sudo nvidia-settings -a "[gpu:${GPU}]/GPUMemoryTransferRateOffset[3]=${MEM}"
done

#ethminer -U -M --cuda-parallel-hash 4 -SP 2 --cuda-devices 0 3


# ASUS ###############
MEM=1500
CLO=140
MY_FAN=10
POWER=80

for GPU in 2 3 4 5; do
	sudo nvidia-smi -pl $POWER -i $GPU
	sudo nvidia-settings -a "[gpu:$GPU]/GPUPowerMizerMode=1"
	sudo nvidia-settings -a "[gpu:$GPU]/GPUFanControlState=1"
	sudo nvidia-settings -a "[fan:$GPU]/GPUTargetFanSpeed=$MY_FAN"
	sudo nvidia-settings -a "[gpu:${GPU}]/GPUGraphicsClockOffset[3]=${CLO}"
	sudo nvidia-settings -a "[gpu:${GPU}]/GPUMemoryTransferRateOffset[3]=${MEM}"
done

#ethminer -U -M --cuda-parallel-hash 4 -SP 2 --cuda-devices 1 2 4 5

ethminer -U -M -SP 2 --cuda-parallel-hash 4

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
ethminer --farm-recheck 200 -U -S naw-eth.hiveon.net:4444 -FS naw-eth.hiveon.net:4444 -O 0xCC947ba6E262893E7AAb3bdAb34DfcE926CC7Eb4.dig --report-hashrate


# Monitor
nvidia-smi --query-gpu=index,power.draw,temperature.gpu,fan.speed,clocks.mem,clocks.gr --format=csv -l


