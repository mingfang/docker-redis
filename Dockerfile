FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

RUN apt-get install -y build-essential

#Redis
RUN wget -O - http://download.redis.io/releases/redis-3.0.3.tar.gz | tar zx && \
    cd redis-* && \
    make -j4 && \
    make install && \
    cp redis.conf /etc/redis.conf && \
    rm -rf /redis-*

COPY redis.conf /etc/

#Add runit services
COPY sv /etc/service 

