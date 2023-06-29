FROM runner/hadoop_cluster:spark

ARG HIVE_VERSION=3.1.0
ARG DERBY_VERSION=10.14.1.0

USER root

# install postgresql JDBC driver
RUN apt-get install -y libpostgresql-jdbc-java

# get hive
RUN wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/apache-hive-$HIVE_VERSION-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/apache-hive-$HIVE_VERSION-bin /home/hadoop/hive
RUN rm -rf /home/hadoop/apache-hive-$HIVE_VERSION*

# set environment variables
ENV HIVE_HOME /home/hadoop/hive
ENV PATH $HIVE_HOME/bin:$PATH

RUN cp /usr/share/java/postgresql-jdbc4.jar /home/hadoop/hive/lib/

# configure hive-env.sh
RUN cp $HIVE_HOME/conf/hive-env.sh.template $HIVE_HOME/conf/hive-env.sh && \
	echo "export HADOOP_HOME=$HADOOP_HOME" >> $HIVE_HOME/conf/hive-env.sh

# Derby
RUN wget http://archive.apache.org/dist/db/derby/db-derby-$DERBY_VERSION/db-derby-$DERBY_VERSION-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/db-derby-$DERBY_VERSION-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/db-derby-$DERBY_VERSION-bin /home/hadoop/derby
RUN rm -rf /home/hadoop/db-derby-$DERBY_VERSION*

# configure ~/.bashrc for Derby
ENV DERBY_HOME /home/hadoop/derby
ENV PATH $DERBY_HOME/bin:$PATH
ENV CLASSPATH $CLASSPATH:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar

RUN echo "export DERBY_HOME=$DERBY_HOME" >> ~/.bashrc && \
	sed -i '/^export PATH=/d' ~/.bashrc && \
	sed -i '/^export CLASSPATH=/d' ~/.bashrc && \
	echo "export PATH=$PATH" >> ~/.bashrc && \
	echo "export CLASSPATH=$CLASSPATH" >> ~/.bashrc

RUN mkdir $DERBY_HOME/data

## configure hive-site.xml
#RUN cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml && \
#	sed -i '0,/  <property>/ s/  <property>/<property>\n<name>system:java.io.tmpdir<\/name>\n<value>\/tmp\/hive\/java<\/value>\n<\/property>\n<property>\n<name>system:user.name<\/name>\n<value>${user.name}<\/value>\n<\/property>\n  <property>/' $HIVE_HOME/conf/hive-site.xml && \
#	sed -i 's|jdbc:derby:;databaseName=metastore_db;create=true|jdbc:derby://localhost:1527/metastore_db;create=true|' $HIVE_HOME/conf/hive-site.xml && \
#	sed -i '    s|<value>org.apache.derby.jdbc.EmbeddedDriver</value>|    <value>org.apache.derby.jdbc.ClientDriver</value>|' $HIVE_HOME/conf/hive-site.xml && \
#	sed -i 's|Ensures commands with OVERWRITE (such as INSERT OVERWRITE) acquire Exclusive locks for&#8;transactional tables.  This ensures that inserts (w/o overwrite) running concurrently are not hidden by the INSERT OVERWRITE.|Ensures commands with OVERWRITE (such as INSERT OVERWRITE) acquire Exclusive locks for transactional tables.  This ensures that inserts (w/o overwrite) running concurrently are not hidden by the INSERT OVERWRITE.|' $HIVE_HOME/conf/hive-site.xml && \
#	sed -i 's|<name>datanucleus.schema.autoCreateAll</name>\n    <value>false</value>|<name>datanucleus.schema.autoCreateAll</name>\n    <value>true</value>|' $HIVE_HOME/conf/hive-site.xml && \
#	sed -i 's|<name>hive.metastore.schema.verification</name>\n    <value>true</value>|<name>hive.metastore.schema.verification</name>\n    <value>false</value>|' $HIVE_HOME/conf/hive-site.xml

## configure for mysql metastore
#
# install mysql
RUN apt-get install -y mysql-server
#
# copy hive-site.xml
ADD mysql/hive-site.xml $HIVE_HOME/conf
#
# copy mysql-connector-java jar to hive lib
ADD mysql/mysql-connector-java-8.0.30.jar $HIVE_HOME/lib
#
# create mysql conf directory
RUN mkdir -p /home/hadoop/mysql/conf
#
# copy create_metastore script
ADD mysql/create_metastore.sql /home/hadoop/mysql/conf
#
# copy config_mysql.sh
ADD mysql/config_mysql.sh /home/hadoop/mysql/conf


# ADD configs/hive-site.xml $HIVE_HOME/conf/hive-site.xml
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hive/bin/hive-config.sh
RUN chown hadoop:hadoop -R /home/hadoop/hive
RUN chown hadoop:hadoop -R /home/hadoop/derby
RUN chown hadoop:hadoop -R /home/hadoop/mysql
RUN export LANGUAGE=en_US.UTF-8
