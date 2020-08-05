#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."

apt-get update; apt-get install -y wget apt-transport-https 
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt-get update && apt-get install -y dotnet-sdk-2.1 

echo "cleanup compilations tools"
apt autoremove -y && apt autoclean -y && apt clean -y
