FROM ubuntu:latest
LABEL maintainer="@jheredianet"


#RUN export DEBIAN_FRONTEND=noninteractive && \
#    apt update -yy && apt upgrade -yy && \
#    apt install --reinstall software-properties-common -yy && \
#    add-apt-repository ppa:deadsnakes/ppa -yy && \
#    apt update -yy && \
#    apt install python3.8 python3.8-distutils python3-pip libpython3.8 -yy && \
#    python3.8 -m pip install --upgrade pip
## install packages
#RUN	apt install curl wget nano htop net-tools -yy
#    #build-essential \
#    #zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
#    #libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -yy \
#    #wget https://www.python.org/ftp/python/3.8.16/Python-3.8.16.tar.xz && \
#    #tar -xf tar -xf Python-3.8.16.tar.xz && \
#    #cd Python-3.8.16 && \
#    #./configure --enable-optimizations && make -j 8 && make altinstall && \
#    #cd .. && rm -rf Python-3.8.16*
#
#    #libpython2.7 net-tools python-dev-is-python3 python-pkg-resources -yy
#    #
##RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
#    # python-apsw python-lxml python-m2crypto
#	# clean up
#	# apt-get clean && \
#	#rm --force --recursive /var/lib/apt/lists && \
#	# install server
#    
#RUN	wget "https://download.acestream.media/linux/acestream_3.1.75rc4_ubuntu_18.04_x86_64_py3.8.tar.gz" && \
#    mkdir /ace && \
#    tar -xvzf acestream_3.1.75rc4_ubuntu_18.04_x86_64_py3.8.tar.gz -C /ace && \
#    rm acestream_3.1.75rc4_ubuntu_18.04_x86_64_py3.8.tar.gz && \
#    python3.8 -m pip install -r /ace/requirements.txt

#RUN ln -s /usr/lib/x86_64-linux-gnu/libpython3.10.so.1.0 /usr/lib/x86_64-linux-gnu/libpython3.8.so.1.0

ENV ACESTREAM_VERSION="3.1.75rc4_ubuntu_18.04_x86_64_py3.8"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update -yy && apt upgrade -yy && \
    apt install --reinstall software-properties-common -yy && \
    add-apt-repository ppa:deadsnakes/ppa -yy && apt update -yy

RUN apt install -yy \
    wget \
    nano \
    htop \
    gcc \
    python3.8 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3.8-distutils \
    libpython3.8-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    swig \
    libffi-dev \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

RUN python3.8 -m pip install --no-cache-dir certifi PyNaCl pycryptodome apsw lxml

RUN wget --progress=dot:giga "https://download.acestream.media/linux/acestream_${ACESTREAM_VERSION}.tar.gz" && \
    mkdir acestream && \
    tar zxf "acestream_${ACESTREAM_VERSION}.tar.gz" -C acestream && \
    mv acestream /opt/acestream

# Document that we are exposing this as the HTTP API port
EXPOSE 6878/tcp

ENTRYPOINT ["/opt/acestream/start-engine"]
CMD ["--client-console"]
