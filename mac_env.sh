#!/bin/bash

################################################
#   Copyright 2013 David Streever
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
################################################
ALL_ELEMENTS="accumulo,datafu,falcon,flume,hadoop,hbase,hive,kafka,knox,mahout,oozie,phoenix,pig,slider,sqoop,tez,zookeeper"

#hadoop,hbase,hive,pig,oozie,zookeeper,accumulo,storm,falcon,falcon-server,knox,phoenix,tez,tez-full,flume,sqoop,mahout"

HDP_VER=2.2.4.2-2
HTTP_BASE="http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.2.4.2/tars/"

TOOLS_BASE="http://public-repo-1.hortonworks.com/HDP/tools/2.2.0.0/"
COMPANION_FILE_BASE="hdp_manual_install_rpm_helper_files-2.2.0.0.2041"

# DEFAULT_FILES_BASE="https://raw.github.com/dstreev/HDP_1.3.0_Mac_Utils/master/"
# DEFAULT_FILES="etc_default"

LIB_BASE_DIR=/usr/hdp
DEFAULT_DIR=/etc/default

BASE_DIR=$HOME/hadoop
HDFS_BASE_DIR=$BASE_DIR/hdfs-data

MYSQL_ARCHIVE=mysql-connector-java-5.1.31

HADOOP_CONF_DIR=/var/hadoop/local/$HDP_VER

MYSQL_JDBC_JAR=/usr/share/java/

HOSTNAME=localhost

HIVE_DB_NAME=hivemetastore2
HIVE_DB_USER=hive
HIVE_DB_PASSWORD=hive

OOZIE_DB_NAME=oozie2
OOZIE_DB_USER=oozie
OOZIE_DB_PASSWORD=oozie

