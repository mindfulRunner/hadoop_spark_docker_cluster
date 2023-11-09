FROM runner/hadoop_cluster:hadoop

ARG SBT_VERSION=1.6.2
# ARG SCALA_VERSION=2.12.10
ARG SCALA_VERSION=2.13.0
# ARG SPARK_VERSION=3.0.0
ARG SPARK_VERSION=3.5.0

USER root

# install python for pyspark
# RUN apt install -y python python3

# install scala
RUN mkdir /usr/share/scala
RUN wget https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz -P /tmp/
RUN tar -xzf /tmp/scala-$SCALA_VERSION.tgz -C /tmp/
RUN mv /tmp/scala-$SCALA_VERSION/* /usr/share/scala
RUN rm -rf /tmp/scala-$SCALA_VERSION /tmp/scala-$SCALA_VERSION.tgz
RUN cp /usr/share/scala/bin/* /usr/bin/

# install sbt
RUN mkdir /usr/share/sbt
RUN wget https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz -P /tmp/
RUN tar -xzf /tmp/sbt-$SBT_VERSION.tgz -C /tmp/
RUN mv /tmp/sbt/* /usr/share/sbt
RUN rm -rf /tmp/sbt /tmp/sbt-$SBT_VERSION.tgz

# get spark
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/spark-$SPARK_VERSION-bin-without-hadoop.tgz -C /home/hadoop/
RUN mv /home/hadoop/spark-$SPARK_VERSION-bin-without-hadoop /home/hadoop/spark
RUN rm /home/hadoop/spark-$SPARK_VERSION-bin-without-hadoop.tgz

RUN mkdir /home/hadoop/spark/logs
RUN chown hadoop:hadoop -R /home/hadoop/spark/logs

# set environment variables
ENV SBT_HOME /usr/share/sbt
ENV SCALA_HOME /usr/share/scala
ENV SPARK_HOME /home/hadoop/spark
ENV SPARK_LOG_DIR /home/hadoop/spark/logs
ENV LD_LIBRARY_PATH /home/hadoop/lib/native
ENV PATH $SBT_HOME/bin:$SCALA_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

# config
RUN export SPARK_DIST_CLASSPATH=$(hadoop classpath)
RUN mv /home/hadoop/spark/conf/spark-env.sh.template /home/hadoop/spark/conf/spark-env.sh
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export SPARK_LOG_DIR=/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-env.sh
RUN mv /home/hadoop/spark/conf/spark-defaults.conf.template /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.eventLog.dir file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.history.fs.logDirectory file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
ADD configs/workers /home/hadoop/spark/conf/slaves
RUN chown hadoop:hadoop -R /home/hadoop/spark
