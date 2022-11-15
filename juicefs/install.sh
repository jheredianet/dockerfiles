#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq && apt upgrade -qq
apt install -y tzdata nano curl unzip fuse lsb-release gpg
curl -sSL https://d.juicefs.com/install | sh -
curl https://rclone.org/install.sh | bash
curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
apt update -qq
apt install -y redis
echo "cleanup compilations tools"
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*