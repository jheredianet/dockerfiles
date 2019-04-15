#!/bin/bash

echo "Installing Rclone tool and dependencies"
apt-get update -qq
apt-get install -y nano man curl unzip fuse htop nload
curl https://rclone.org/install.sh | bash

echo "Updating restic..."
restic self-update

echo "cleanup compilations tools"
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
