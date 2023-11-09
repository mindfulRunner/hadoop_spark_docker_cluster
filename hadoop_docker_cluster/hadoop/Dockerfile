FROM runner/hadoop_cluster:common

# ARG HADOOP_VERSION=3.1.1
ARG HADOOP_VERSION=3.3.0

# get hadoop
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/hadoop-$HADOOP_VERSION.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/hadoop-$HADOOP_VERSION /home/hadoop/hadoop
RUN rm -rf /home/hadoop/hadoop-$HADOOP_VERSION*

# set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME /home/hadoop/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV YARN_HOME $HADOOP_HOME
ENV PATH $JAVA_HOME/bin:$PATH
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# set up hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_NAMENODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_DATANODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_SECONDARYNAMENODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_OPTS=-Djava.library.path=$HADOOP_HOME/lib/native" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh

# configure other config files
RUN mkdir -p /home/hadoop/data/nameNode /home/hadoop/data/dataNode /home/hadoop/data/nameNodeSecondary /home/hadoop/data/tmp
RUN mkdir -p /home/hadoop/hadoop/logs
# ADD configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
# ADD configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
# ADD configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
# ADD configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD configs/workers $HADOOP_HOME/etc/hadoop/workers

# configure core-site.xml
RUN cp $HADOOP_HOME/etc/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml.original && \
	sed -i 's|</configuration>|<property>\n<name>fs.default.name</name>\n<value>hdfs://nodemaster:9000</value>\n</property>\n<property>\n<name>hadoop.proxyuser.root.groups</name>\n<value>*</value>\n</property>\n<property>\n<name>hadoop.proxyuser.root.hosts</name>\n<value>*</value>\n</property>\n</configuration>|' $HADOOP_HOME/etc/hadoop/core-site.xml

# configure hdfs-site.xml
RUN cp $HADOOP_HOME/etc/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml.original && \
	sed -i 's|</configuration>|<property>\n<name>dfs.replication</name>\n<value>1</value>\n</property>\n<property>\n<name>dfs.name.dir</name>\n<value>file:///home/hadoop/hadoopinfra/hdfs/namenode</value>\n</property>\n<property>\n<name>dfs.data.dir</name>\n<value>file:///home/hadoop/hadoopinfra/hdfs/datanode</value>\n</property>\n</configuration>|' $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# configure yarn-site.xml
RUN cp $HADOOP_HOME/etc/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml.original && \
	sed -i 's|</configuration>|<property>\n<name>yarn.nodemanager.aux-services</name>\n<value>mapreduce_shuffle</value>\n</property>\n</configuration>|' $HADOOP_HOME/etc/hadoop/yarn-site.xml

# configure mapred-site.xml
RUN cp $HADOOP_HOME/etc/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml.original && \
	sed -i 's|</configuration>|<property>\n<name>mapreduce.framework.name</name>\n<value>yarn</value>\n</property>\n<property>\n<name>yarn.app.mapreduce.am.env</name>\n<value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>\n</property>\n<property>\n<name>mapreduce.map.env</name>\n<value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>\n</property>\n<property>\n<name>mapreduce.reduce.env</name>\n<value>HADOOP_MAPRED_HOME=$HADOOP_HOME</value>\n</property>\n</configuration>|' $HADOOP_HOME/etc/hadoop/mapred-site.xml

RUN chown hadoop:hadoop -R /home/hadoop/data
RUN chown hadoop:hadoop -R /home/hadoop/hadoop

RUN usermod -aG sudo hadoop

CMD service ssh start && bash
