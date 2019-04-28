#!/bin/bash

echo "Updating Linux..."
apt-get update -qq
apt-get install -y nano man curl unzip fuse htop nload mc tzdata
echo "Installing 'rclone' tool and dependencies..."
curl https://rclone.org/install.sh | bash

echo "Cleanup compilations tools..."
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
