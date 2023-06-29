-- create metastore for hive
CREATE DATABASE metastore;

-- create hive user for mysql
CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'hivepassword';
GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
