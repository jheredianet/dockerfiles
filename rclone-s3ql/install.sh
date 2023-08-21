#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -yy && apt upgrade -yy

apt install -yy build-essential zlib1g-dev libncurses5-dev \
    libgdbm-dev libnss3-dev libssl-dev libreadline-dev \
    libffi-dev libsqlite3-dev wget curl libbz2-dev git \
    fuse psmisc pkg-config liblzma-dev\
    libattr1-dev libfuse-dev \
    libsqlite3-dev libjs-sphinxdoc tzdata software-properties-common python3-dev unzip


wget https://www.sqlite.org/2023/sqlite-autoconf-3420000.tar.gz
tar xvfz sqlite-autoconf-*.tar.gz
cd sqlite-autoconf-3420000
./configure --prefix=/usr
make -j 8
make install
cd /
rm -rf sqlite-autoconf-3420000/
rm sqlite-autoconf-3420000.tar.gz

curl https://rclone.org/install.sh | bash

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

pip3 install cython pycrypto \
    defusedxml requests "llfuse >= 1.0, < 2.0" "dugong >= 3.4, < 4.0" "pytest >= 2.7" 
pip3 install --upgrade google-auth-oauthlib

# Fuse3
apt install -y fuse3 libfuse3-dev
pip3 install apsw pyfuse3 cryptography

echo "download s3ql code"
wget https://github.com/s3ql/s3ql/releases/download/s3ql-5.1.1/s3ql-5.1.1.tar.gz
tar xvfz s3ql-*.tar.gz

cd s3ql-5.1.1
echo "compile s3ql"
python3 setup.py build_ext --inplace

echo "install s3ql"
python3 setup.py install

cd /
rm -rf s3ql-5.1.1/
rm s3ql-5.1.1.tar.gz

echo "cleanup compilations tools"
apt-get remove --purge -y git
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
