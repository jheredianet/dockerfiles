FROM ubuntu:18.04 as builder
LABEL maintainer="Juan Carlos Heredia <jchm@infoinnova.net>"

# Install packages

ENV DEBIAN_FRONTEND noninteractive
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -yy upgrade
ENV BUILD_DEPS="git autoconf pkg-config libssl-dev libpam0g-dev \
    libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex \
    bison libxml2-dev dpkg-dev libcap-dev"
RUN apt-get -yy install  sudo apt-utils software-properties-common $BUILD_DEPS


# Build xrdp

WORKDIR /tmp
RUN apt-get source pulseaudio
RUN apt-get build-dep -yy pulseaudio
WORKDIR /tmp/pulseaudio-11.1
RUN dpkg-buildpackage -rfakeroot -uc -b
WORKDIR /tmp
RUN git clone --branch v0.9.7 --recursive https://github.com/neutrinolabs/xrdp.git
WORKDIR /tmp/xrdp
RUN ./bootstrap
RUN ./configure
RUN make
RUN make install
WORKDIR /tmp/xrdp/sesman/chansrv/pulse
RUN sed -i "s/\/tmp\/pulseaudio\-10\.0/\/tmp\/pulseaudio\-11\.1/g" Makefile
RUN make
RUN mkdir -p /tmp/so
RUN cp *.so /tmp/so

FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt install -yy apt-utils software-properties-common \
  vim wget curl ca-certificates xorgxrdp pulseaudio xrdp\
  xfce4 xfce4-terminal xfce4-screenshooter xfce4-taskmanager \
  xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-netload-plugin \
  xfce4-xkb-plugin xauth supervisor uuid-runtime locales sudo \
  firefox pepperflashplugin-nonfree openssh-server \
  calibre nano gtk2-engines-pixbuf gprename renrot \
	&& add-apt-repository -y ppa:webupd8team/java
RUN apt-get -y update \
	&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
  && apt-get install -y oracle-java8-installer oracle-java8-set-default
RUN apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/so/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/so/module-xrdp-sink.so /var/lib/xrdp-pulseaudio-installer

# RUN wget -qO - https://get.filebot.net/filebot/KEYS | sudo apt-key add - \
#    && add-apt-repository 'deb [arch=amd64] https://get.filebot.net/deb/ stable main' \
#    && apt install -yy  filebot

# Descargar Filebot
RUN wget -O /tmp/filebot.deb 'https://app.filebot.net/download.php?type=deb&arch=amd64'
RUN dpkg -i /tmp/filebot.deb && rm /tmp/filebot.deb

ADD etc /etc
ADD run /run
#ADD pulse /usr/lib/pulse-10.0/modules/
RUN chmod +x /run/*.sh


# Configure
RUN mkdir /var/run/dbus
RUN cp /etc/X11/xrdp/xorg.conf /etc/X11
RUN sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config
RUN sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini
RUN locale-gen en_US.UTF-8
RUN echo "xfce4-session" > /etc/skel/.Xclients
RUN cp -r /etc/ssh /ssh_orig
RUN rm -rf /etc/ssh/*
RUN rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem

# Add sample user
# sample user uses uid 999 to reduce conflicts with user ids when mounting an existing home dir

RUN addgroup --gid 999 ubuntu
RUN useradd -mp xkHzu52z8mnRU -s /bin/bash -g ubuntu -G sudo desktop
# RUN useradd -m -u 999 -s /bin/bash -g ubuntu ubuntu
# RUN echo "ubuntu:ubuntu" | /usr/sbin/chpasswd
# RUN echo "ubuntu    ALL=(ALL) ALL" >> /etc/sudoers

# Custom user preferences
RUN ln -s /usr/bin/gprename /home/desktop/Desktop/gprename

# Docker config
VOLUME ["/etc/ssh","/home"]
EXPOSE 3389 22 9001
ENTRYPOINT ["/run/docker-entrypoint.sh"]
#CMD ["supervisord"]
CMD /run/startup.sh