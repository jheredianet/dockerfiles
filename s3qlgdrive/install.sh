#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq
apt install -yy git rsync nano curl \
   python3 python3-pip psmisc pkg-config \
   libattr1-dev libfuse-dev \
   fuse3 libfuse3-dev \
   libsqlite3-dev libjs-sphinxdoc tzdata
   #fuse texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-generic-extra \
   #texlive-fonts-recommended
#pip3 install --upgrade pip
#pip3 install https://github.com/rogerbinns/apsw/releases/download/3.8.2-r1/apsw-3.8.2-r1.zip
pip3 install https://github.com/rogerbinns/apsw/releases/download/3.31.1-r1/apsw-3.31.1-r1.zip
pip3 install https://github.com/python-trio/trio/archive/v0.16.0.zip
pip3 install prometheus_client cython pycrypto \
    defusedxml requests cryptography \
    "dugong >= 3.4, < 4.0" "pytest >= 3.7" "pyfuse3<4.0,>=3.0"
    
pip3 install --upgrade google-api-python-client
pip3 install --upgrade oauth2client
pip3 install --upgrade google-auth-oauthlib

echo "download s3ql code"
git clone https://github.com/segator/s3ql.git -b gdrive
#git clone https://github.com/jheredianet/s3ql.git -b skipfsck

cd s3ql
echo "compile s3ql"
python3 setup.py build_cython
python3 setup.py build_ext --inplace

echo "install s3ql"
python3 setup.py install

echo "cleanup compilations tools"
apt-get remove --purge -y git
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
