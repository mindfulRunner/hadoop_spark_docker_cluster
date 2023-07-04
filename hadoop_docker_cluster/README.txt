Copied from 
    - https://medium.com/@aditya.pal/setup-a-3-node-hadoop-spark-hive-cluster-from-scratch-using-docker-332dae6b98d0 with some modifications
    - D:\aaa\workout\techs\bigdata\a_docker\hadoop-suite-hdp-3.1.5

customize Docker Desktop - see D:\aaa\workout\techs\bigdata\a_docker\20220308\README.txt

build images
build.sh

install cluster
cluster.sh install

start cluster
cluster.sh start

NOTE:
    - build.sh, cluster.sh are Shell scripts, can't run in MS Command Line
    - need to run in WSL2 Ubuntu terminal
        o@o:/mnt/c/a/workout/techs/bigdata/a_docker/20220308/hadoop_docker_cluster$ ./cluster.sh start


enter any container like this (**docker exec -u hadoop -it nodemaster /bin/bash**)
D:\aaa\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster>docker exec -u hadoop -it nodemaster /bin/bash
hadoop@nodemaster:/$

NOTE:
    - check
        - http://localhost:8088
            - cluster info
        - http://localhost:9870
            - namenode info (DFS health check)
        - http://localhost:9868
            - secondary namenode info
        - http://localhost:8042
            - nodemanager info (NOT working)

    - for configuring Mysql for Hive, need manually run config_mysql.sh
        - see below **Configure Mysql for Hive** section

stop cluster
cluster.sh stop



**Configure Mysql for Hive**

User root
    - login
        - docker exec -u root -it nodemaster /bin/bash
    - start mysql server
        - mysqld &
    - set password for hadoop
        - passwd hadoop
    - add hadoop to sudoer
        - usermod -aG sudo hadoop

User hadoop
    - login
        - docker exec -u hadoop -it nodemaster /bin/bash
    - start mysql shell
        - sudo mysql -u root -p root
    - manually run D:\aaa\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster\mysql\config_mysql.sh
        - mysql> source /home/hadoop/mysql/conf/create_metastore.sql;
        - mysql> USE metastore;
        - mysql> source /home/hadoop/hive/scripts/metastore/upgrade/mysql/hive-schema-3.1.0.mysql.sql;
    - check metastore was created
        - mysql> show databases;
    - check hiveuser were created
        - mysql> select user from mysql.user;
    - start hive shell
        - hive> show tables;
            hive> show tables;
            OK
            Time taken: 1.185 seconds
            hive>

also refer to D:\aaa\workout\techs\bigdata\hive\config_mysql_for_hive\mysql.txt



**Test with Hive**

copy file from local to nodemaster container - D:\aaa\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster>**docker cp test_data.csv nodemaster:/tmp/**

enter nodemaster - D:\aaa\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster>**docker exec -u hadoop -it nodemaster /bin/bash**
hadoop@nodemaster:/$

create directory in HDFS - hadoop@nodemaster:/$ **hdfs dfs -mkdir -p /user/hadoop/test**

put file into HDFS - hadoop@nodemaster:/$ **hdfs dfs -put /tmp/test_data.csv /user/hadoop/test/**

start hive - **hive**

In hive terminal: hive> **create schema if not exists test;**

In hive terminal: hive> **create external table if not exists test.test_data(row1 int, row2 int, row3 decimal(10,3), row4 int) row format delimited fields terminated by ',' stored as textfile location 'hdfs://172.20.1.1:9000/user/hadoop/test/';**

Note:
    there are some errors.



**Test with Cassandra**

hadoop@node2:/$ /home/hadoop/cassandra/bin/cqlsh
Connected to Test Cluster at 127.0.0.1:9042
[cqlsh 6.1.0 | Cassandra 4.1.2 | CQL spec 3.4.6 | Native protocol v5]
Use HELP for help.
cqlsh> desc keyspaces;

system       system_distributed  system_traces  system_virtual_schema
system_auth  system_schema       system_views

cqlsh> quit



**Test with Spark**

hadoop@node2:/$ spark-shell
2023-07-01 06:10:35,821 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Spark context Web UI available at http://node2:4040
Spark context available as 'sc' (master = local[*], app id = local-1688191848354).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.0.0
      /_/

Using Scala version 2.12.10 (OpenJDK 64-Bit Server VM, Java 1.8.0_362)
Type in expressions to have them evaluated.
Type :help for more information.

scala> spark.range(10 * 10).count
res0: Long = 100

scala> :quit
hadoop@node2:/$



NOTE:
    - test data is coming from PluralSight tutorial 
        - D:\aaa\workout\techs\bigdata\a_courses\pluralsight\2_develop_spark_app_with_scala_&_cloudera\demo

    - reference D:\aaa\workout\techs\bigdata\a_courses\pluralsight\2_develop_spark_app_with_scala_&_cloudera\README.txt for details    


start docker nodemaster, cluster
    - cluster.sh start

go to nodemaster with root user
    - docker exec -u root -it nodemaster /bin/bash
    - set password
        - passwd root
            - r
        - passwd hadoop
            - h
    - add hadoop to sudo list
        - usermod -aG sudo hadoop
    - see D:\aaa\workout\techs\bigdata\a_docker\20220308\README.txt

install unzip
    - apt-get install unzip

install dtrx (Do The Right eXtraction) - will uncompress anything
    - apt-get install dtrx

install sbt
    - download sbt universal package (sbt-1.6.2.zip) from https://www.scala-sbt.org/1.x/docs/Installing-sbt-on-Linux.html

    - copy sbt-1.6.2.zip from local to nodemaster where Spark, Hadoop are residing
        - docker cp sbt-1.6.2.zip nodemaster:/tmp

    - move / unzip sbt-1.6.2.zip to /usr/share where Scala is residing
        - unzip sbt-1.6.2.zip
        - export PATH=/usr/share/sbt/bin:$PATH

prepare course materials
    - dump stack exchange data
        - https://archive.org/details/stackexchange
        - click on "Show All"
            - https://archive.org/download/stackexchange
        - download Stack Exchange Data Dump
            - download smaller stack exchange data dump
                - vi.stackexchange.com.7z
                    - D:\aaa\workout\techs\bigdata\a_courses\pluralsight\2_develop_spark_app_with_scala_&_cloudera\vi.stackexchange.com.7z
            - docker cp vi.stackexchange.com.7z nodemaster:/tmp
            - dtrx vi.stackexchange.com.7z

    - download exercise files from course website at https://app.pluralsight.com/library/courses/spark-scala-cloudera/exercise-files
        - D:\aaa\workout\techs\bigdata\a_courses\pluralsight\2_develop_spark_app_with_scala_&_cloudera\spark-scala-cloudera.zip

    - copy exercise files from local to nodemaster where Spark, Hadoop are residing
        - docker cp spark-scala-cloudera.zip nodemaster:/tmp

    - copy / unzip spark-scala-cloudera.zip
        - unzip spark-scala-cloudera.zip
        or
        - dtrx spark-scala-cloudera.zip

go to nodemaster with hadoop user
    - docker exec -u hadoop -it nodemaster /bin/bash

restart HDFS
    - stop-yarn.sh
    - stop-dfs.sh
    
    - hdfs namenode -format
    - start-dfs.sh
    - start-yarn.sh

    http://localhost:8088/ should be working
    http://localhost:9870/ should be working

    - check if datanode / namenode was started
        - jps

    - if datanode / namenode was not started, start it
        - hadoop-daemon.sh start datanode
        - hadoop-daemon.sh start namenode
        or
        - hdfs --daemon start datanode
        - hdfs --daemon start namenode

put stackoverflow / stackexchange data dump into HDFS
    - go to data dump dir
        hadoop@nodemaster:/tmp/vi.stackexchange.com$ ls -l
        total 171836
        -rw-r--r-- 1 hadoop hadoop  6602759 Jun  6 01:08 Badges.xml
        -rw-r--r-- 1 hadoop hadoop 15360893 Jun  6 01:08 Comments.xml
        -rw-r--r-- 1 hadoop hadoop 80356100 Jun  6 01:08 PostHistory.xml
        -rw-r--r-- 1 hadoop hadoop   418926 Jun  6 01:08 PostLinks.xml
        -rw-r--r-- 1 hadoop hadoop 45023223 Jun  6 01:08 Posts.xml
        -rw-r--r-- 1 hadoop hadoop    30338 Jun  6 01:08 Tags.xml
        -rw-r--r-- 1 hadoop hadoop 15291027 Jun  6 01:08 Users.xml
        -rw-r--r-- 1 hadoop hadoop 12854948 Jun  6 01:08 Votes.xml
        hadoop@nodemaster:/tmp/vi.stackexchange.com$
    - create dir in HDFS
        - hdfs dfs -mkdir -p /user/cloudera/stackexchange
    - put stackexchange files
        - hdfs dfs -put *.xml /user/cloudera/stackexchange/
            - already in /tmp/vi.stackexchange.com
        - verify files have been put into HDFS
            hadoop@nodemaster:/tmp/vi.stackexchange.com$ hdfs dfs -ls /user/cloudera/stackexchange
            2022-06-15 02:01:57,763 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
            Found 8 items
            -rw-r--r--   1 hadoop supergroup    6602759 2022-06-15 02:01 /user/cloudera/stackexchange/Badges.xml
            -rw-r--r--   1 hadoop supergroup   15360893 2022-06-15 02:01 /user/cloudera/stackexchange/Comments.xml
            -rw-r--r--   1 hadoop supergroup   80356100 2022-06-15 02:01 /user/cloudera/stackexchange/PostHistory.xml
            -rw-r--r--   1 hadoop supergroup     418926 2022-06-15 02:01 /user/cloudera/stackexchange/PostLinks.xml
            -rw-r--r--   1 hadoop supergroup   45023223 2022-06-15 02:01 /user/cloudera/stackexchange/Posts.xml
            -rw-r--r--   1 hadoop supergroup      30338 2022-06-15 02:01 /user/cloudera/stackexchange/Tags.xml
            -rw-r--r--   1 hadoop supergroup   15291027 2022-06-15 02:01 /user/cloudera/stackexchange/Users.xml
            -rw-r--r--   1 hadoop supergroup   12854948 2022-06-15 02:01 /user/cloudera/stackexchange/Votes.xml
            hadoop@nodemaster:/tmp/vi.stackexchange.com$

build / run scala project
    - go to hadoop@nodemaster with hadoop user
    - cp /tmp/spark-scala-cloudera/demos/2 - Getting an Environment and Data - CDH + StackOverflow/posts /tmp/posts
        - Spark, HDFS don't work well with long path with spaces in the folder name
    - build scala project
        - sbt package
    - run spark-submit command as specified in prepare_data_posts_all_csv.scala
        - spark-submit --class "PreparePostsCSVApp" target/scala-2.11/posts-project_2.11-1.0.jar
            - hadoop@nodemaster:/tmp/posts$ spark-submit --class PreparePostsCSVApp target/scala-2.11/posts-project_2.11-1.0.jar
    - there should be a directory called posts_all_csv created in HDFS below

        hadoop@nodemaster:/tmp/vi.stackexchange.com$ hdfs dfs -ls /user/cloudera/stackexchange
        2022-06-15 02:17:51,910 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
        Found 9 items
        -rw-r--r--   1 hadoop supergroup    6602759 2022-06-15 02:01 /user/cloudera/stackexchange/Badges.xml
        -rw-r--r--   1 hadoop supergroup   15360893 2022-06-15 02:01 /user/cloudera/stackexchange/Comments.xml
        -rw-r--r--   1 hadoop supergroup   80356100 2022-06-15 02:01 /user/cloudera/stackexchange/PostHistory.xml
        -rw-r--r--   1 hadoop supergroup     418926 2022-06-15 02:01 /user/cloudera/stackexchange/PostLinks.xml
        -rw-r--r--   1 hadoop supergroup   45023223 2022-06-15 02:01 /user/cloudera/stackexchange/Posts.xml
        -rw-r--r--   1 hadoop supergroup      30338 2022-06-15 02:01 /user/cloudera/stackexchange/Tags.xml
        -rw-r--r--   1 hadoop supergroup   15291027 2022-06-15 02:01 /user/cloudera/stackexchange/Users.xml
        -rw-r--r--   1 hadoop supergroup   12854948 2022-06-15 02:01 /user/cloudera/stackexchange/Votes.xml
        drwxr-xr-x   - hadoop supergroup          0 2022-06-15 02:17 /user/cloudera/stackexchange/posts_all_csv
        hadoop@nodemaster:/tmp/vi.stackexchange.com

        hadoop@nodemaster:/tmp/vi.stackexchange.com$ hdfs dfs -ls /user/cloudera/stackexchange/posts_all_csv
        2022-06-15 02:33:46,529 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
        Found 2 items
        -rw-r--r--   1 hadoop supergroup          0 2022-06-15 02:17 /user/cloudera/stackexchange/posts_all_csv/_SUCCESS
        -rw-r--r--   1 hadoop supergroup    3789603 2022-06-15 02:17 /user/cloudera/stackexchange/posts_all_csv/part-00000-09342f1f-a9be-408c-8d22-cf3c9139ec22-c000.csv
        hadoop@nodemaster:/tmp/vi.stackexchange.com$

        check result
        hadoop@nodemaster:/tmp/vi.stackexchange.com$ hdfs dfs -cat /user/cloudera/stackexchange/posts_all_csv/part-00000-09342f1f-a9be-408c-8d22-cf3c9139ec22-c000.csv
        2022-06-15 04:54:51,758 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
        1,1,5,2015-02-03T16:40:26.487,45,10084,2,2,2015-02-03T17:51:07.583,How can I add line numbers to Vim?,2018-12-12T18:05:13.460,(line-numbers),2,0,8
        2,2,"",2015-02-03T16:43:11.760,24,"",5,1109,2018-12-12T18:05:13.460,"",2018-12-12T18:05:13.460,"","",1,""
        3,1,8,2015-02-03T16:54:26.737,91,45278,11,28,2015-02-03T16:55:58.233,How can I show relative line numbers?,2017-11-20T16:51:43.517,(line-numbers),4,0,16
        4,1,43,2015-02-03T16:54:37.670,42,14206,12,21062,2019-08-06T22:20:56.890,How can I change the default indentation based on filetype?,2019-08-06T22:20:56.890,"(indentation,filetype)",4,1,9
        5,2,"",2015-02-03T16:54:58.480,58,"",19,135,2015-02-03T21:05:27.990,"",2015-02-03T21:05:27.990,"","",2,""
        6,1,"",2015-02-03T16:55:25.927,51,15456,2,24,2015-02-05T08:44:10.167,How can I use the undofile?,2020-11-25T17:31:04.880,"(persistent-state,undo-redo)",1,1,13
        7,2,"",2015-02-03T16:56:53.240,5,"",27,"","","",2015-02-03T16:56:53.240,"","",7,""
        8,2,"",2015-02-03T16:58:00.347,110,"",19,-1,2017-04-13T12:51:57.303,"",2015-02-03T21:58:31.907,"","",4,""
        9,1,23,2015-02-03T16:58:07.553,22,1360,28,343,2016-02-10T10:55:41.193,Can I script Vim using Python?,2016-02-10T10:55:41.193,(vimscript-python),2,1,2
        10,2,"",2015-02-03T16:59:52.260,12,"",27,27,2015-02-03T17:06:20.293,"",2015-02-03T17:06:20.293,"","",1,""
        11,2,"",2015-02-03T17:00:05.557,14,"",31,"","","",2015-02-03T17:00:05.557,"","",0,""
        12,1,14,2015-02-03T17:00:19.820,40,5532,24,"","","How can I generate a list of sequential numbers, one per line?",2016-12-07T20:47:09.990,"(line-numbers,text-generation)",5,0,7
        13,1,2561,2015-02-03T17:01:08.817,14,932,28,28,2015-02-11T09:12:42.553,Does any solution exist to use vim from touch screen?,2021-09-23T14:27:44.810,(input-devices),2,8,2

check result using Hue

    - go to Hue UI http://localhost:8888/
        - set up username / password
            - hadoop / hadoop

    - Hue / Hive / Hadoop were not set up correctly
    