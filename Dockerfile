FROM ubuntu:22.04

LABEL website="sangchul.kr"

ARG OS_USER1
ARG OS_USER1_PASSWD
ENV OS_ROOT_PASSWD="root"
ENV OS_USER1=${OS_USER1:-ubuntu}
ENV OS_USER1_PASSWD=${OS_USER1_PASSWD:-ubuntu}

USER root

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
        arping telnet inetutils-ping netcat \
        net-tools traceroute dnsutils \
        ethtool tcpdump ipcalc \
        curl wget vim \
#         sudo git make \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists /var/lib/dpkg/info /tmp/* /var/tmp/*
    
RUN echo 'root:root' | chpasswd
RUN echo 'export PS1="\[\e[33m\]\u\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]:\[\033[01;31m\]\W\[\e[m\]$ "' >> ~/.bashrc

RUN useradd -rm -d /home/$OS_USER1 -s /bin/bash -G sudo $OS_USER1 \
  && mkdir -m 700 /home/$OS_USER1/.ssh \
  && echo "$OS_USER1":"$OS_USER1_PASSWD" | chpasswd \
  && echo -e "$OS_USER1\tALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  
WORKDIR /root

CMD ["/bin/bash"]






###docker build
# docker build --tag anti1346/ubuntu-nettools:latest --no-cache .
