#!/bin/bash

function startServices {
    docker start nodemaster node2 node3
    sleep 5
    echo ">> Starting HDFS..."
    docker exec -u hadoop -d nodemaster start-dfs.sh
    sleep 5
    echo ">> Starting Yarn..."
    docker exec -u hadoop -d nodemaster start-yarn.sh
    sleep 5
    echo ">> Starting NameNode..."
    docker exec -u hadoop -d nodemaster hdfs --daemon start namenode
    sleep 5
    echo ">> Starting DataNode..."
    docker exec -u hadoop -d nodemaster hdfs --daemon start datanode
    sleep 5
    echo ">> Starting MR-JobHistory Server..."
    docker exec -u hadoop -d nodemaster mr-jobhistory-daemon.sh start historyserver
    sleep 5
    echo ">> Preparing HDFS for Hive..."
    docker exec -u hadoop -d nodemaster hdfs dfs -mkdir -p /tmp
    docker exec -u hadoop -d nodemaster hdfs dfs -mkdir -p /user/hive/warehouse
    docker exec -u hadoop -d nodemaster hdfs dfs -chmod g+w /tmp
    docker exec -u hadoop -d nodemaster hdfs dfs -chmod g+w /user/hive/warehouse
    sleep 5
    #echo ">> Starting Derby Server for Hive..."
    #docker exec -u hadoop -d nodemaster startNetworkServer
    echo ">> Starting MySQL Server for Hive..."
    #docker exec -u root -d nodemaster /usr/sbin/mysqld
    docker exec -u root -d nodemaster mysqld
    sleep 5
    echo ">> Starting Hive Metastore..."
    docker exec -u hadoop -d nodemaster hive --service metastore
    docker exec -u hadoop -d nodemaster hive --service hiveserver2
    sleep 5
    echo ">> Starting Spark..."
    docker exec -u hadoop -d nodemaster start-master.sh
    docker exec -u hadoop -d node2 start-slave.sh nodemaster:7077
    docker exec -u hadoop -d node3 start-slave.sh nodemaster:7077
    sleep 5
    echo ">> Starting Spark History Server..."
    docker exec -u hadoop -d nodemaster start-history-server.sh
    echo ">> Starting Nifi Server..."
    docker exec -u hadoop -d nifi /home/hadoop/nifi/bin/nifi.sh start
    echo ">> Starting Kafka & Zookeeper..."
    docker exec -u hadoop -d edge /home/hadoop/kafka/bin/zookeeper-server-start.sh -daemon /home/hadoop/kafka/config/zookeeper.properties
    docker exec -u hadoop -d edge /home/hadoop/kafka/bin/kafka-server-start.sh -daemon /home/hadoop/kafka/config/server.properties
    echo ">> Starting Zeppelin..."
    docker exec -u hadoop -d zeppelin /home/hadoop/zeppelin/bin/zeppelin-daemon.sh start
    echo ">> Starting Cassandra..."
    docker exec -u hadoop -d cassandra /home/hadoop/cassandra/bin/cassandra -f -R
    echo "Hadoop info @ nodemaster: http://172.20.1.1:8088/cluster"
    echo "DFS Health @ nodemaster: http://172.20.1.1:50070/dfshealth"
    echo "MR-JobHistory Server @ nodemaster: http://172.20.1.1:19888"
    echo "Spark info @ nodemaster: http://172.20.1.1:8080"
    echo "Spark History Server @ nodemaster: http://172.20.1.1:18080"
    echo "Zookeeper @ edge: http://172.20.1.5:2181"
    echo "Kafka @ edge: http://172.20.1.5:9092"
    echo "Nifi @ edge: http://172.20.1.5:8080/nifi & from host @ http://localhost:8080/nifi"
    echo "Zeppelin @ zeppelin: http://172.20.1.6:8081 & from host @ http://localhost:8081"
}

function stopServices {
    echo ">> Stopping Nifi Server..."
    docker exec -u hadoop -d nifi /home/hadoop/nifi/bin/nifi.sh stop
    echo ">> Stopping Zeppelin..."
    docker exec -u hadoop -d zeppelin /home/hadoop/zeppelin/bin/zeppelin-daemon.sh stop
    echo ">> Stopping Kafka & Zookeeper..."
    docker exec -u hadoop -d edge /home/hadoop/kafka/bin/zookeeper-server-stop.sh -daemon /home/hadoop/kafka/config/zookeeper.properties
    docker exec -u hadoop -d edge /home/hadoop/kafka/bin/kafka-server-stop.sh -daemon /home/hadoop/kafka/config/server.properties
    echo ">> Stopping Spark master and slaves..."
    docker exec -u hadoop -d nodemaster stop-master.sh
    docker exec -u hadoop -d node2 stop-slave.sh
    docker exec -u hadoop -d node3 stop-slave.sh
    echo ">> Stopping Spark History Server..."
    docker exec -u hadoop -d nodemaster stop-history-server.sh
    #echo ">> Stopping Derby Server for Hive..."
    #docker exec -u hadoop -d nodemaster stopNetworkServer
    echo ">> Stopping MySQL Server for Hive..."
    docker exec -u root -d nodemaster /usr/bin/mysqladmin shutdown
    echo ">> Stopping MR-JobHistory Server..."
    docker exec -u hadoop -d nodemaster mr-jobhistory-daemon.sh stop historyserver
    echo ">> Stopping DataNode..."
    docker exec -u hadoop -d nodemaster hdfs --daemon stop datanode
    echo ">> Stopping NameNode..."
    docker exec -u hadoop -d nodemaster hdfs --daemon stop namenode
    echo ">> Stopping Yarn..."
    docker exec -u hadoop -d nodemaster hdfs --daemon stop-yarn.sh
    echo ">> Stopping HDFS..."
    docker exec -u hadoop -d nodemaster hdfs --daemon stop-dfs.sh

    echo ">> Stopping containers..."
    docker stop nodemaster node2 node3 edge hue nifi zeppelin psqlhms
}

if [[ $1 = "install" ]]; then
    # create custom network
    docker network create --subnet=172.20.0.0/16 hadoopnet

    # start Postgresql Hive metastore
    echo ">> Starting Postgresql Hive metastore..."
    docker run -d --net hadoopnet --ip 172.20.1.4 --hostname psqlhms --name psqlhms -e POSTGRES_PASSWORD=hive -it runner/hadoop_cluster:postgresql-hms
    sleep 5

    # 3 nodes
    # http://localhost:8088  -> Cluster (All Applications)
    # http://localhost:9870  -> NameNode information
    # http://localhost:9868  -> Secondary NameNode
    # http://localhost:8042  -> NodeManager information
    # http://localhost:4040  -> Spark Web UI port
    # http://localhost:18089  -> Spark History Server port
    echo ">> Starting master and worker nodes..."
    docker run -d --net hadoopnet --ip 172.20.1.1 -p 8088:8088 -p 9870:9870 -p 9868:9868 -p 8042:8042 -p 4040:4040 -p 18089:18089 --hostname nodemaster --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --name nodemaster -it runner/hadoop_cluster:hive
    docker run -d --net hadoopnet --ip 172.20.1.2 --hostname node2 --add-host nodemaster:172.20.1.1 --add-host node3:172.20.1.3 --name node2 -it runner/hadoop_cluster:spark
    docker run -d --net hadoopnet --ip 172.20.1.3 --hostname node3 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --name node3 -it runner/hadoop_cluster:spark
    docker run -d --net hadoopnet --ip 172.20.1.5 --hostname edge --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name edge -it runner/hadoop_cluster:edge
    docker run -d --net hadoopnet --ip 172.20.1.6 -p 8080:8080 --hostname nifi --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name nifi -it runner/hadoop_cluster:nifi
    docker run -d --net hadoopnet --ip 172.20.1.7 -p 8888:8888 --hostname huenode --add-host edge:172.20.1.5 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name hue -it runner/hadoop_cluster:hue
    docker run -d --net hadoopnet --ip 172.20.1.8 -p 8081:8081 --hostname zeppelin --add-host edge:172.20.1.5 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name zeppelin -it runner/hadoop_cluster:zeppelin
    docker run -d --net hadoopnet --ip 172.20.1.9 --hostname node2 --add-host nodemaster:172.20.1.1 --add-host node3:172.20.1.3 --name cassandra -it runner/hadoop_cluster:cassandra

    # format nodemaster
    echo ">> Formatting HDFS..."
    docker exec -u hadoop -d nodemaster hdfs namenode -format
    startServices
    exit
fi

if [[ $1 = "stop" ]]; then
    stopServices
    exit
fi

if [[ $1 = "uninstall" ]]; then
    stopServices
    docker rm -f $(docker ps -a -q)
    exit
fi

if [[ $1 = "start" ]]; then
    docker start psqlhms nodemaster node2 node3 edge hue nifi zeppelin
    startServices
    exit
fi

if [[ $1 = "pull_images" ]]; then
    # docker pull -a sciencepal/hadoop_cluster
    exit
fi

echo "Usage: cluster.sh pull_images|install|start|stop|uninstall"
echo "                  pull_images - download all docker images"
echo "                  install - Prepare to run and start for first time all containers"
echo "                  start - start existing containers"
echo "                  stop - stop running processes"
echo "                  uninstall - remove all docker images"
