FROM runner/hadoop_cluster:hive

ARG FLUME_VERSION=1.9.0
ARG KAFKA_MAJOR_VERSION=2.12
ARG KAFKA_MINOR_VERSION=2.0.0
ARG SQOOP_VERSION=1.4.7

USER root

# get flume
RUN wget http://archive.apache.org/dist/flume/$FLUME_VERSION/apache-flume-$FLUME_VERSION-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/apache-flume-$FLUME_VERSION-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/apache-flume-$FLUME_VERSION-bin /home/hadoop/flume
RUN rm -rf /home/hadoop/apache-flume-$FLUME_VERSION-bin*
RUN chown hadoop -R /home/hadoop/flume

# get kafka
RUN wget https://archive.apache.org/dist/kafka/$KAFKA_MINOR_VERSION/kafka_$KAFKA_MAJOR_VERSION-$KAFKA_MINOR_VERSION.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/kafka_$KAFKA_MAJOR_VERSION-$KAFKA_MINOR_VERSION.tgz -C /home/hadoop/
RUN mv /home/hadoop/kafka_$KAFKA_MAJOR_VERSION-$KAFKA_MINOR_VERSION /home/hadoop/kafka
RUN rm -rf /home/hadoop/kafka_$KAFKA_MAJOR_VERSION-$KAFKA_MINOR_VERSION*
RUN chown hadoop -R /home/hadoop/kafka
ENV KAFKA_HOME=/home/hadoop/kafka
ENV PATH $KAFKA_HOME/bin:$PATH

# get sqoop
RUN wget http://archive.apache.org/dist/sqoop/$SQOOP_VERSION/sqoop-$SQOOP_VERSION.bin__hadoop-2.6.0.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/sqoop-$SQOOP_VERSION.bin__hadoop-2.6.0.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/sqoop-$SQOOP_VERSION.bin__hadoop-2.6.0 /home/hadoop/sqoop
RUN rm -rf /home/hadoop/sqoop-$SQOOP_VERSION*
RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.9.jar -P /home/hadoop/sqoop/lib/
RUN wget https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar -P /home/hadoop/sqoop/lib/
RUN chown hadoop -R /home/hadoop/sqoop

ENV SQOOP_HOME /home/hadoop/sqoop
ENV PATH $SQOOP_HOME/bin:$PATH

CMD service ssh start && bash
