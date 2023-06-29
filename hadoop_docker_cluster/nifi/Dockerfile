FROM runner/hadoop_cluster:common

ARG NIFI_VERSION=1.10.0

# get nifi
RUN wget http://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/nifi-$NIFI_VERSION-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/nifi-$NIFI_VERSION /home/hadoop/nifi
RUN rm -rf /home/hadoop/nifi-$NIFI_VERSION*

# set environment variables
RUN echo -e "\n" >> /home/hadoop/nifi/bin/nifi-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/hadoop/nifi/bin/nifi-env.sh
RUN echo "export TOOLS_JAR=${JAVA_HOME}/lib/tools.jar" >> /home/hadoop/nifi/bin/nifi-env.sh

ADD configs/nifi.properties /home/hadoop/nifi/conf/nifi.properties
RUN chown hadoop -R /home/hadoop/nifi

CMD service ssh start && bash
