FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
    bzip2 \
    cpio \
    curl \
    daemontools \
    entr \
    git \
    language-pack-en-base \
    net-tools \
    openssh-server \
    python \
    tmux \
    sudo \
    vim-gtk 

RUN mkdir -p /services/sshd /var/run/sshd 
COPY run /services/sshd
RUN sed -i -e 's/PermitRootLogin without-password/PermitRootLogin yes/' -e 's/#X11UseLocalhost.*/X11UseLocalhost no/' /etc/ssh/sshd_config

ARG id
ARG key

ENV DEVL devl
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' | tee -a /etc/sudoers
RUN adduser --disabled-password --gecos '' --uid $id $DEVL
RUN adduser $DEVL sudo 
USER $DEVL
RUN mkdir ~/.ssh
RUN echo "$key" | tee ~/.ssh/authorized_keys

RUN git clone https://github.com/reflex-frp/reflex-platform.git /tmp/reflex-platform

USER root


