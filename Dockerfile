FROM ubuntu:16.04

MAINTAINER z4yx <z4yx@users.noreply.github.com>

#install dependences:
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    bc \
    u-boot-tools \
    build-essential \
    sudo \
    tofrodos \
    iproute2 \
    gawk \
    net-tools \
    expect \
    libncurses5-dev \
    tftpd \
    libssl-dev \
    flex \
    bison \
    libselinux1 \
    gnupg \
    wget \
    socat \
    gcc-multilib \
    libsdl1.2-dev \
    libglib2.0-dev \
    lib32z1-dev \
    zlib1g:i386 \
    libgtk2.0-0 \
    screen \
    pax \
    diffstat \
    xvfb \
    xterm \
    texinfo \
    gzip \
    unzip \
    cpio \
    chrpath \
    autoconf \
    lsb-release \
    libtool \
    libtool-bin \
    locales \
    kmod \
    git

ARG PETA_VERSION
ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado && \
  usermod -aG sudo vivado && \
  echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY accept-eula.sh ${PETA_RUN_FILE} /

# run the install
RUN chmod a+x /${PETA_RUN_FILE} && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /tmp /opt/Xilinx && \
  cd /tmp && \
  sudo -u vivado /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f /${PETA_RUN_FILE} /accept-eula.sh 

USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/project
RUN sudo chown vivado:vivado /home/vivado/project
WORKDIR /home/vivado/project

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc
