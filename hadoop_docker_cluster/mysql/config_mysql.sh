#!/bin/bash

# create metastore, hive user for mysql
source /home/hadoop/mysql/conf/create_metastore.sql;

USE metastore;

# upgrade hive schema for mysql
source /home/hadoop/hive/scripts/metastore/upgrade/mysql/hive-schema-3.1.0.mysql.sql;
