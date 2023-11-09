FROM ubuntu

USER root

# open port 22
EXPOSE 22

RUN apt-get update

# install python for pyspark
RUN apt-get install -y python3 python3-pip
RUN export PYSPARK_PYTHON=/usr/bin/python3
RUN export PYSPARK_DRIVER_PYTHON=/usr/bin/python3

# install OpenJDK 8
RUN apt-get install -y openjdk-8-jre openjdk-8-jdk openssh-server vim

# add hadoop user
RUN useradd -m -s /bin/bash hadoop

# set pubkey authentication
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN mkdir -p /home/hadoop/.ssh
RUN echo "PubkeyAcceptedKeyTypes +ssh-dss" >> /home/hadoop/.ssh/config
RUN echo "PasswordAuthentication no" >> /home/hadoop/.ssh/config

# copy keys
ADD configs/id_rsa.pub /home/hadoop/.ssh/id_rsa.pub
ADD configs/id_rsa /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa.pub
RUN cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
RUN chown hadoop -R /home/hadoop/.ssh

# install utilities
# dtrx is to uncompress / unzip (Do The Right eXtraction)
RUN apt-get install -y apt-utils && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y vim && \
    apt-get install -y dos2unix && \
    apt-get install -y ssh && \
    apt-get install -y openssh-client && \
    apt-get install -y net-tools && \
    apt-get install -y iputils-ping && \
    apt-get install -y telnet && \
    apt-get install -y sudo && \
    apt-get install -y dtrx
