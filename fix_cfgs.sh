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

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
. ./mac_env.sh

# Core
CORE_SITE_FILE=$HADOOP_CONF_DIR/core_hadoop/core-site.xml
HADOOP_ENV_FILE=$HADOOP_CONF_DIR/core_hadoop/hadoop-env.sh
. $APP_DIR/replace.sh $CORE_SITE_FILE TODO-NAMENODE-HOSTNAME $HOSTNAME
. $APP_DIR/replace.sh $CORE_SITE_FILE TODO-FS-CHECKPOINT-DIR $HDFS_BASE_DIR/snn
. $APP_DIR/replace.sh $HADOOP_ENV_FILE "JAVA_HOME=/usr/java/default" "JAVA_HOME=\`/usr/libexec/java_home\`" "|"

. $APP_DIR/replace.sh $HADOOP_ENV_FILE "export HADOOP_SECURE_DN_USER=hdfs" "export HADOOP_SECURE_DN_USER=\$USER" "|"

# Adjust PID Dirs
. $APP_DIR/replace.sh $HADOOP_ENV_FILE "export HADOOP_PID_DIR=/var/run/hadoop/\$USER" "export HADOOP_PID_DIR=\$HOME/var/run/hadoop" "|"
. $APP_DIR/replace.sh $HADOOP_ENV_FILE "export HADOOP_SECURE_DN_PID_DIR=/var/run/hadoop/\$HADOOP_SECURE_DN_USER" "export HADOOP_SECURE_DN_PID_DIR=\$HOME/var/run/hadoop" "|"

# Adjust LOG Dirs
. $APP_DIR/replace.sh $HADOOP_ENV_FILE "export HADOOP_LOG_DIR=/var/log/hadoop/\$USER" "export HADOOP_LOG_DIR=\$HOME/var/log/hadoop" "|"
. $APP_DIR/replace.sh $HADOOP_ENV_FILE "export HADOOP_SECURE_DN_LOG_DIR=/var/log/hadoop/\$HADOOP_SECURE_DN_USER" "export HADOOP_SECURE_DN_LOG_DIR=\$HOME/var/log/hadoop" "|"

# Remove codecs for mac installation, if not done, causes issues with 'hive cli'
#   Manifest as an issue loading TextInputFormat when running a hive query.
# TODO: Figure out how to add the appropriate codecs to the mac.
OLD_CODEC="org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.DefaultCodec,com.hadoop.compression.lzo.LzoCodec,com.hadoop.compression.lzo.LzopCodec,org.apache.hadoop.io.compress.BZip2Codec,org.apache.hadoop.io.compress.SnappyCodec"
# TODO: Weird..  I needed to add the BZip2Codec back in, or else the Secondary Namenode wouldn't start.
NEW_CODEC="org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.BZip2Codec"
. $APP_DIR/replace.sh $CORE_SITE_FILE $OLD_CODEC $NEW_CODEC

# HDFS
HDFS_SITE_FILE=$HADOOP_CONF_DIR/core_hadoop/hdfs-site.xml
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-DFS-NAME-DIR $HDFS_BASE_DIR/name
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-DFS-DATA-DIR $HDFS_BASE_DIR/data
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-NAMENODE-HOSTNAME $HOSTNAME
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-SECONDARYNAMENODE-HOSTNAME $HOSTNAME

# MAPRED
MAPRED_SITE_FILE=$HADOOP_CONF_DIR/core_hadoop/mapred-site.xml
. $APP_DIR/replace.sh $MAPRED_SITE_FILE TODO-MAPRED-LOCAL-DIR $HDFS_BASE_DIR/mapred
. $APP_DIR/replace.sh $MAPRED_SITE_FILE TODO-JTNODE-HOSTNAME $HOSTNAME
. $APP_DIR/replace.sh $MAPRED_SITE_FILE "org.apache.hadoop.io.compress.SnappyCodec" "org.apache.hadoop.io.compress.GzipCodec"

# Hive
HIVE_SITE_FILE=$HADOOP_CONF_DIR/hive/hive-site.xml
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-JDBC-URL "jdbc:mysql://localhost:3306/$HIVE_DB_NAME?createDatabaseIfNotExist=true" "|"
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-JDBC-DRIVER com.mysql.jdbc.Driver
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-METASTORE-USER-NAME $HIVE_DB_USER
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-METASTORE-USER-PASSWD $HIVE_DB_PASSWORD
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-METASTORE-SERVER-HOST $HOSTNAME
# Removed for Mac, causes load issue with Hive CLI
. $APP_DIR/replace.sh $HIVE_SITE_FILE "org.apache.hcatalog.security.HdfsAuthorizationProvider" ""
HIVE_ENV_FILE=$HADOOP_CONF_DIR/hive/hive-env.sh
. $APP_DIR/replace.sh $HIVE_ENV_FILE "export JAVA_HOME=/usr/java/default" "export JAVA_HOME=\`/usr/libexec/java_home\`" "|"

# Pig (TODO)
# Need to adjust JAVA_HOME

# OOZIE
OOZIE_ENV_FILE=$HADOOP_CONF_DIR/oozie/oozie-env.sh
# TODO - Adjust JAVA_HOME
OOZIE_SITE_FILE=$HADOOP_CONF_DIR/oozie/oozie-site.xml
# TODO - Need to reset the oozie.service.JPAService.create.db.schema to 'true'
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-SERVER $HOSTNAME
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-JDBC-DRIVER com.mysql.jdbc.Driver
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-JDBC-URL "jdbc:mysql://localhost:3306/$OOZIE_DB_NAME?createDatabaseIfNotExist=true" "|"
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-DATABASE-USER-NAME $OOZIE_DB_USER
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-DATABASE-USER-PASSWD $OOZIE_DB_PASSWORD 

# SQOOP (Doesn't appear to need adjustments)

# WebHCat (Don't think any changes needed..)

# ZooKeeper (TODO)
ZOO_ENV_FILE=$HADOOP_CONF_DIR/zookeeper/zookeeper-env.sh
# Need to adjust JAVA_HOME

ZOO_CFG_FILE=$HADOOP_CONF_DIR/zookeeper/zoo.cfg
# Need to adjust the server list 

