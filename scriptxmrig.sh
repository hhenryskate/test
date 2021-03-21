apt-get update && apt-get upgrade -y
sudo apt-get install git build-essential cmake automake libtool autoconf -y
git clone https://github.com/xmrig/xmrig.git
mkdir xmrig/build && cd xmrig/scripts
./build_deps.sh && cd ../build
cmake .. -DXMRIG_DEPS=scripts/deps
make -j$(nproc)
wget https://raw.githubusercontent.com/hhenryskate/test/main/config.json
chmod 775 xmrig
cp xmrig /usr/local/bin
cp config.json /usr/local/bin
xmrig




