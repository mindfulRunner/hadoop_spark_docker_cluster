#!/bin/bash


# Copied from `uninstall` in cluster.sh
# This is not a regular operation and should only be run extremely rarely.
# So separate it from cluster.sh
read -p "Have you run \"./cluster.sh uninstall\" first?  Are you sure to continue tearing down everything (y or n)? " yn
if [[ "$yn" == "y" ]]; then
    # docker rmi -f $(docker images -q)
    docker rmi -f runner/hadoop_cluster:common runner/hadoop_cluster:hadoop runner/hadoop_cluster:postgresql-hms runner/hadoop_cluster:spark runner/hadoop_cluster:hive runner/hadoop_cluster:hue runner/hadoop_cluster:edge runner/hadoop_cluster:nifi runner/hadoop_cluster:zeppelin runner/hadoop_cluster:spark-cassandra
    docker system prune -a
fi