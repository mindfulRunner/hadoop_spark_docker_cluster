FROM runner/hadoop_cluster:spark

ARG CASSANDRA_VERSION=4.1.2

USER root

RUN wget https://archive.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz -C /home/hadoop
RUN mv /home/hadoop/apache-cassandra-$CASSANDRA_VERSION /home/hadoop/cassandra
RUN rm -rf /home/hadoop/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz

ENV CASSANDRA_HOME /home/hadoop/cassandra
ENV PATH $CASSANDRA_HOME/bin:$PATH

RUN chown hadoop:hadoop -R /home/hadoop/cassandra
