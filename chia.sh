sudo apt-get update
sudo apt-get upgrade -y
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
cd chia-blockchain
chmod +x ./install.sh
sh install.sh
. ./activate
chmod +x ./install-gui.sh
sh install-gui.sh
cd chia-blockchain-gui
sed -i -e 's/electron ./electron . --no-sandbox/g' /root/chia-blockchain/chia-blockchain-gui/package.json
npm run electron &
