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
    libsqlite3-dev libjs-sphinxdoc tzdata software-properties-common python3-dev 

wget https://www.sqlite.org/2023/sqlite-autoconf-3420000.tar.gz
tar xvfz sqlite-autoconf-*.tar.gz
cd sqlite-autoconf-3420000
./configure --prefix=/usr
make -j 8
make install
cd /
rm -rf sqlite-autoconf-3420000/
rm sqlite-autoconf-3420000.tar.gz

#curl https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tgz -o Python-3.9.12.tgz
#tar -xf Python-3.9.12.tgz
#cd Python-3.9.12
#./configure --enable-optimizations
#make -j 12
#make altinstall

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

pip3 install cython pycrypto \
    defusedxml requests "llfuse >= 1.0, < 2.0" "dugong >= 3.4, < 4.0" "pytest >= 2.7" 
pip3 install --upgrade google-auth-oauthlib
#pip3 install https://github.com/rogerbinns/apsw/releases/download/3.8.2-r1/apsw-3.8.2-r1.zip
#pip3 install https://github.com/rogerbinns/apsw/releases/download/3.42.0.1/apsw-3.42.0.1.zip

# Fuse3
apt install -y fuse3 libfuse3-dev
pip3 install apsw pyfuse3 cryptography

#cd /
#rm -rf Python-3.9.12
#rm Python-3.9.12.tgz

echo "download s3ql code"
git clone https://github.com/s3ql/s3ql.git
#git clone https://github.com/jheredianet/s3ql.git -b gdrive
#wget https://github.com/s3ql/s3ql/releases/download/s3ql-5.1.1/s3ql-5.1.1.tar.gz
#tar xvfz s3ql-*.tar.gz

cd s3ql
echo "compile s3ql"
python3 setup.py build_cython
python3 setup.py build_ext --inplace

echo "install s3ql"
python3 setup.py install

cd /
#rm -rf s3ql-5.1.1/
rm -rf s3ql/
#rm s3ql-5.1.1.tar.gz

# make a symbolic link 
#ln -s /usr/local/bin/python3.9 /usr/local/bin/python3  

echo "cleanup compilations tools"
apt-get remove --purge -y git
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
