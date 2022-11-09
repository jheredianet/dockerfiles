#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq && apt upgrade -qq
apt install -y tzdata nano curl unzip fuse 
curl -sSL https://d.juicefs.com/install | sh -
curl https://rclone.org/install.sh | bash
echo "cleanup compilations tools"
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*