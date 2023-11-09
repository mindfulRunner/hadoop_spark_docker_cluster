README



Tutorial
==============================

	- docker
		Setup a 3-node Hadoop-Spark-Hive cluster from scratch using Docker
		https://medium.com/@aditya.pal/setup-a-3-node-hadoop-spark-hive-cluster-from-scratch-using-docker-332dae6b98d0

		https://github.com/sciencepal/dockers

		D:\aaa\workout\techs\bigdata\a_courses\coursera\scientpal\dockers-master
		
	- course
		D:\aaa\workout\techs\bigdata\a_courses\pluralsight\2_develop_spark_app_with_scala_&_cloudera


Component versions
==============================
	
	Cloudera Docs/Cloudera Runtime7.2.14?(Public Cloud � latest)

	CLOUDERA RUNTIME RELEASE NOTESPDF version

	Cloudera Runtime Component Versions

	https://docs.cloudera.com/runtime/7.2.14/release-notes/topics/rt-pubc-runtime-component-versions.html

		- a followup for https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/release-notes/content/comp_versions.html
			bigdata/a_docker/README.txt
			bigdata/a_docker/hadoop-suite-hdp-3.1.5
			
			# D:\aaa\workout\techs\bigdata\a_docker\hadoop-suite-hdp-3.1.5\Dockerfile
			DERBY_VERSION=10.14.1.0
			HADOOP_VERSION=3.1.1
			HBASE_VERSION=2.1.6
			HIVE_VERSION=3.1.0
			KAFKA_MAJOR_VERSION=2.12
			KAFKA_MINOR_VERSION=2.0.0
			PIG_VERSION=0.16.0
			PRESTO_VERSION=0.243.2
			SCALA_VERSION=2.12.10
			SPARK_VERSION=3.0.0
			SQOOP_VERSION=1.4.7
			STORM_VERSION=2.2.0
			ZOOKEEPER_VERSION=3.4.6
			
	
	For Cloudera Runtime 7.2.14
	
	https://archive.apache.org/dist/
	
	https://archive.apache.org/dist/hadoop/core/hadoop-3.1.1/hadoop-3.1.1.tar.gz
	https://archive.apache.org/dist/hbase/2.4.6/hbase-2.4.6-bin.tar.gz
	https://archive.apache.org/dist/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz (?)
	https://archive.apache.org/dist/impala/4.0.0/apache-impala-4.0.0.tar.gz
	https://archive.apache.org/dist/kafka/2.8.1/kafka_2.13-2.8.1.tgz
	https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8.tgz
	https://archive.apache.org/dist/lucene/solr/8.4.1/solr-8.4.1.tgz
	https://archive.apache.org/dist/oozie/5.1.0/oozie-5.1.0.tar.gz
	https://archive.apache.org/dist/avro/avro-1.8.2/avro-doc-1.8.2.tar.gz
	https://archive.apache.org/dist/parquet/apache-parquet-1.10.1/apache-parquet-1.10.1.tar.gz (?)
	https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.tar.gz
	https://archive.apache.org/dist/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2.tgz
	https://archive.apache.org/dist/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5.tar.gz
	https://archive.apache.org/dist/cassandra/4.1.2/apache-cassandra-4.1.2-bin.tar.gz

	- D:\aaa\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster\README.md
		CASSANDRA_VERSION=4.1.2
		DERBY_VERSION=10.14.1.0
		FLUME_VERSION=1.9.0
		HADOOP_VERSION=3.1.1
		HBASE_VERSION=2.1.6
		HIVE_VERSION=3.1.0
		KAFKA_MAJOR_VERSION=2.12
		KAFKA_MINOR_VERSION=2.0.0
		NIFI=1.10.0
		PIG_VERSION=0.16.0
		PRESTO_VERSION=0.243.2
		SCALA_VERSION=2.12.10
		SPARK_VERSION=3.0.0
		SQOOP_VERSION=1.4.7
		STORM_VERSION=2.2.0
		ZEPPELIN_VERSION=0.8.2
		ZOOKEEPER_VERSION=3.4.6



Cluster structure
==============================

network:
	name: hadoopnet
	subnet: 172.20.0.0/16

hostname		container		ip				component

psqlhms			psqlhms			172.20.1.4		PostgreSQL Hive Metastore (HMS)
nodemaster		nodemaster		172.20.1.1		hadoop, spark, hive
node2			node2			172.20.1.2		hadoop, spark
node3			node3			172.20.1.3		hadoop, spark
edge			edge			172.20.1.5		hadoop, spark, hive, kafka, flume, sqoop
nifi			nifi			172.20.1.6		nifi
huenode			hue				172.20.1.7		hue
zeppelin		zeppelin		172.20.1.8		hadoop, spark, hive, zeppelin

	

Move default WSL2 / Docker location
==============================
	
	Issue:
	- Docker Desktop installation location is not customizable during installation process.
	- Docker Desktop used WSL2
	- The installation location of Docker / WSL2 is at C:\<USER>\AppData\Local\Docker
	- The installation folder is 8 GB already after initial installation and will get bigger when being in use
	- After the folder size becomes bigger and bigger, and soon it consumes all available disk space on C
	
	Trial:
	- follow https://blog.codetitans.pl/post/howto-docker-over-wsl2-location/
	- move default installation location of Docker / WSL2 to D:
	- follow the following instruction
		- quit Docker Desktop
		- wsl --list -v
		- wsl --shutdown
		- wsl --list -v (make sure docker-destop is stopped)
		- md D:\aaa\temp
		- wsl --export docker-desktop-data "D:\aaa\temp\docker-desktop-data.tar"
		- wsl --unregister docker-desktop-data
		- wsl --import docker-desktop-data "D:\aaa\tool\docker\wsl\data" "D:\aaa\temp\docker-desktop-data.tar" --version 2
		- del D:\aaa\temp
		- start Docker Desktop
	
	- resources:
		https://blog.codetitans.pl/post/howto-docker-over-wsl2-location/
		https://stackoverflow.com/questions/62441307/how-can-i-change-the-location-of-docker-images-when-using-docker-desktop-on-wsl2
		https://devops.tutorials24x7.com/blog/how-to-change-docker-data-path-on-windows-10
		
	[ERROR]
		- after moving default installation path, Docker Desktop can no longer start up
			- https://docs.docker.com/desktop/windows/troubleshoot/#diagnosing-from-the-terminal
				- "C:\Program Files\Docker\Docker\resources\com.docker.diagnose.exe" check
	
	[SOLUTION]
		- follow
			- Approach C in https://devops.tutorials24x7.com/blog/how-to-change-docker-data-path-on-windows-10
			- Anthony's answer in https://stackoverflow.com/questions/62441307/how-can-i-change-the-location-of-docker-images-when-using-docker-desktop-on-wsl2/63752264#63752264
		- follow the instruction below (may need run as administrator)
			- uninstall Docker Desktop
			- md
				- D:\tool\docker\AppData\Local\Docker
				- D:\tool\docker\ProgramData\Docker
				- D:\tool\docker\ProgramData\DockerDesktop
				- D:\tool\docker\Program_Files\Docker
			- mklink
				- mklink /j "C:\Users\yang\AppData\Local\Docker" "D:\aaa\tool\docker\AppData\Local\Docker"
				- mklink /j "C:\ProgramData\Docker" "D:\aaa\tool\docker\ProgramData\Docker"
				- mklink /j "C:\ProgramData\DockerDesktop" "D:\aaa\tool\docker\ProgramData\DockerDesktop"
				- mklink /j "C:\Program Files\Docker" "D:\aaa\tool\docker\Program_Files\Docker"
			- install Docker Desktop
			
			

Enable Docker in WSL2
==============================

	- build.sh and cluster.sh are Shell scripts, cannot be run directly in MS Command Line
	- need to run build.sh and cluster.sh in WSL2 linux terminal

	[error] - failed to run docker in WSL2 although docker is found in PATH
			(o@o:/mnt/c/a/workout/techs/bigdata/a_docker/20220308/hadoop_docker_cluster$ echo $PATH
			...:/mnt/c/Program Files/Docker/Docker/resources/bin:...)

		o@o:/mnt/c/a/workout/techs/bigdata/a_docker/20220308/hadoop_docker_cluster$ docker --help

		The command 'docker' could not be found in this WSL 2 distro.
		We recommend to activate the WSL integration in Docker Desktop settings.

		For details about using Docker Desktop with WSL 2, visit:

		https://docs.docker.com/go/wsl2/

		[investigation]
		- use wsl.exe command to check Docker state in MS Command Line
			- C:\a\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster>wsl -l -v
				NAME                   STATE           VERSION
			  * Ubuntu-22.04           Running         2
				docker-desktop-data    Stopped         2
				docker-desktop         Stopped         2
		- start Docker Desktop from Start Menu
		- Docker Desktop -> Settings -> Resources -> WSL INTEGRATION
			- enable WSL2 (Ubuntu 22.04.2 LTS)

			C:\a\workout\techs\bigdata\a_docker\20220308\hadoop_docker_cluster>wsl -l -v
				NAME                   STATE           VERSION
			  * Ubuntu-22.04           Running         2
				docker-desktop         Running         2
				docker-desktop-data    Running         2

			o@o:/mnt/c/a/workout/techs/bigdata/a_docker/20220308/hadoop_docker_cluster$ docker -v
			Docker version 24.0.2, build cb74dfc



- Hadoop
=========================================
	- hdfs namenode -format
	
	- start-dfs.sh
	- start-yarn.sh
	
	- stop-yarn.sh
	- stop-dfs.sh
	
	- jps


	- HDFS
	=============
	- hdfs dfs <command>
		- OR hadoop fs <command>
	
	- hdfs dfs -mkdir
	- hdfs dfs -ls
	- hdfs dfs -put
	- hdfs dfs -get
			
	- [error] Call From nodemaster/172.20.1.1 to nodemaster:9000 failed on connection exception: java.net.ConnectException: Connection refused
	
		[SOLUTION]
			- change core-site.xml
				<property>
					<name>fs.default.name</name>
					<value>hdfs://nodemaster:9000</value>
				</property>
				
				to
				
				<property>
					<name>fs.default.name</name>
					<!--value>hdfs://nodemaster:9000</value-->
					<value>hdfs://localhost:9000</value>
				</property>
				
	- [error] hadoop@nodemaster:/$ hdfs dfs -mkdir -p /user/hadoop/test
				error message:
					put: File /user/hadoop/test/test_data.csv._COPYING_ could only be written to 0 of the 1 minReplication nodes. There are 0 datanode(s) running and 0 node(s) are excluded in this operation.
					
		[SOLUTION]
			- jps
				- check if datanode is runninh
				hadoop@nodemaster:~/data/dataNode$ jps
					6432 NameNode
					276 JobHistoryServer
					6761 Jps
					6635 SecondaryNameNode
				- here, datanode is NOT running
			- hadoop-daemond.sh start datanode
				- start datanode individually
				hadoop@nodemaster:~/data/dataNode$ jps
					6432 NameNode
					276 JobHistoryServer
					6904 Jps
					6825 DataNode
					6635 SecondaryNameNode
				- now, datanode is running
				- to start namenode individually, run hadoop-daemond.sh start namenode
			
			
			
- how to install python?
=========================

	[error]
		hadoop@nodemaster:/$ apt install -y python3 python3-pip
		E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
		E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
		
	[SOLUTION]
		- follow Charith's answer to https://stackoverflow.com/questions/28721699/root-password-inside-a-docker-container
			- exit from docker as user hadoop
			- re-enter with root user
				- root@nodemaster:/# docker exec -u root -it nodemaster /bin/bash
			- passwd root
				- set / change root user's password
			- passwd hadoop
				- set / change hadoop user's password
			- sudo
				- check if sudo is installed, if not, do following step
			- apt-get install sudo
			- usermod -aG sudo hadoop
				- add hadoop user to sudo group
			- enter docker with hadoop user
				- docker exec -u hadoop -it nodemaster /bin/bash
			- hadoop@nodemaster:/$ sudo apt install -y python3 python3-pip
				- now it should work
				
			
- log in as root
- set password for user hadoop
- add user hadoop to the sudoer file
- 
=========================
D:\>docker exec -u hadoop -it nodemaster /bin/bash
hadoop@nodemaster:/$ sudo stop-yarn.sh
[sudo] password for hadoop:
hadoop is not in the sudoers file.  This incident will be reported.
hadoop@nodemaster:/$ usermod -aG sudo hadoop
usermod: Permission denied.
usermod: cannot lock /etc/passwd; try again later.
hadoop@nodemaster:/$ exit
exit

D:\>docker exec -u root -it nodemaster /bin/bash
root@nodemaster:/# usermod -aG sudo hadoop
root@nodemaster:/# exit
exit

D:\>docker exec -u hadoop -it nodemaster /bin/bash
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

hadoop@nodemaster:/$


