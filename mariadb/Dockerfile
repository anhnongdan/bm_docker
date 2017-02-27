FROM phusion/baseimage:0.9.19
MAINTAINER Victor Tran<baysao@gmail.com>
CMD ["/sbin/my_init"]
ENV VER xenial
ENV DBVER 10.2
ENV TERM xterm
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    echo "deb http://mirrors.syringanetworks.net/mariadb/repo/${DBVER}/ubuntu ${VER} main" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.syringanetworks.net/mariadb/repo/${DBVER}/ubuntu ${VER} main" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  --allow-unauthenticated mariadb-server 

#change bind address to 0.0.0.0
#RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
ADD my.cnf.orig /etc/mysql/my.cnf.orig

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/var/lib/mysql"]

#RUN ln -snf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && echo "Asia/Ho_Chi_Minh" > /etc/timezone

#RUN mkdir /etc/service/mysql
ADD mysql.sh /etc/service/mysql/run
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
