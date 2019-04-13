#!/bin/bash

echo "install rclon tool and dependencies"
echo "Begining..."
apt-get update -qq
apt-get install -y nano man curl unzip fuse restic
curl https://rclone.org/install.sh | bash

echo "cleanup compilations tools"
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
