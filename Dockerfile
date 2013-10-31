#Redis

FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list.d/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list.d/sources.list && \
    apt-get update

#Prevent daemon start during install
RUN	echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

#Supervisord
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor && \
	mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-n"]

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && \
	mkdir /var/run/sshd && \
	echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less ntp net-tools inetutils-ping curl git telnet

#Redis
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server

#Build tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y automake libtool make

#twemproxy
RUN git clone https://github.com/twitter/twemproxy.git && \
    cd twemproxy && \
    git checkout tags/v0.2.4 && \
    autoreconf -fvi && \
    ./configure --enable-debug=log && \
    make

#Configuration
ADD ./supervisord-redis.conf /etc/supervisor/conf.d/supervisord-redis.conf
ADD ./nutcracker.yml /nutcracker.yml

EXPOSE 22 6379 63790


