FROM runner/hadoop_cluster:hive

ARG ZEPPELIN_VERSION=0.8.2

USER root

# get zeppelin
RUN wget http://archive.apache.org/dist/zeppelin/zeppelin-$ZEPPELIN_VERSION/zeppelin-$ZEPPELIN_VERSION-bin-all.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/zeppelin-$ZEPPELIN_VERSION-bin-all.tgz -C /home/hadoop/
RUN mv /home/hadoop/zeppelin-$ZEPPELIN_VERSION-bin-all /home/hadoop/zeppelin
RUN rm -rf /home/hadoop/zeppelin-$ZEPPELIN_VERSION-bin-all*

RUN chown hadoop -R /home/hadoop/zeppelin

# set up zeppelin-env.sh
RUN echo "export ZEPPELIN_ADDR=0.0.0.0" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export ZEPPELIN_PORT=8081" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export SPARK_HOME=/home/hadoop/spark" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export HIVE_HOME=/home/hadoop/hive" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export ZEPPELIN_INTP_CLASSPATH_OVERRIDES=$HIVE_HOME/conf" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
