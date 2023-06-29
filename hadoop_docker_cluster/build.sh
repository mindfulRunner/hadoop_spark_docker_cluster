#!/bin/bash

# generate ssh key

echo "Y" | ssh-keygen -t rsa -P "" -f configs/id_rsa

docker build -f ./common/Dockerfile . -t runner/hadoop_cluster:common

docker build -f ./hadoop/Dockerfile . -t runner/hadoop_cluster:hadoop

docker build -f ./spark/Dockerfile . -t runner/hadoop_cluster:spark

docker build -f ./postgresql-hms/Dockerfile . -t runner/hadoop_cluster:postgresql-hms

docker build -f ./hive/Dockerfile . -t runner/hadoop_cluster:hive

docker build -f ./nifi/Dockerfile . -t runner/hadoop_cluster:nifi

docker build -f ./edge/Dockerfile . -t runner/hadoop_cluster:edge

docker build -f ./hue/Dockerfile . -t runner/hadoop_cluster:hue

docker build -f ./zeppelin/Dockerfile . -t runner/hadoop_cluster:zeppelin
