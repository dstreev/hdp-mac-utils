#!/bin/bash

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
. $APP_DIR/replace.sh $HADOOP_ENV_FILE JAVA_HOME=/usr/java/default JAVA_HOME=`/usr/libexec/java_home` |

JAVA_HOME=/usr/java/default

# HDFS
HDFS_SITE_FILE=$HADOOP_CONF_DIR/core_hadoop/hdfs-site.xml
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-DFS-NAME-DIR $HDFS_BASE_DIR/name
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-DFS-DATA-DIR $HDFS_BASE_DIR/data
. $APP_DIR/replace.sh $HDFS_SITE_FILE TODO-NAMENODE-HOSTNAME $HOSTNAME


# MAPRED
MAPRED_SITE_FILE=$HADOOP_CONF_DIR/core_hadoop/mapred-site.xml
. $APP_DIR/replace.sh $MAPRED_SITE_FILE TODO-MAPRED-LOCAL-DIR $HDFS_BASE_DIR/mapred
. $APP_DIR/replace.sh $MAPRED_SITE_FILE TODO-JTNODE-HOSTNAME $HOSTNAME

# Hive
HIVE_SITE_FILE=$HADOOP_CONF_DIR/hive/hive-site.xml
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-JDBC-URL jdbc:mysql://localhost:3306/$HIVE_DB_NAME?createDatabaseIfNotExist=true |
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-JDBC-DRIVER com.mysql.jdbc.Driver
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-METASTORE-USER-NAME $HIVE_DB_USER
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-METASTORE-USER-PASSWD $HIVE_DB_PASSWORD
. $APP_DIR/replace.sh $HIVE_SITE_FILE TODO-HIVE-METASTORE-SERVER-HOST $HOSTNAME
 
# Pig (TODO)
# Need to adjust JAVA_HOME

# OOZIE
OOZIE_ENV_FILE=$HADOOP_CONF_DIR/oozie/oozie-env.sh
# TODO - Adjust JAVA_HOME
OOZIE_SITE_FILE=$HADOOP_CONF_DIR/oozie/oozie-site.xml
# TODO - Need to reset the oozie.service.JPAService.create.db.schema to 'true'
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-SERVER $HOSTNAME
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-JDBC-DRIVER com.mysql.jdbc.Driver
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-JDBC-URL jdbc:mysql://localhost:3306/$OOZIE_DB_NAME?createDatabaseIfNotExist=true |
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-DATABASE-USER-NAME $OOZIE_DB_USER
. $APP_DIR/replace.sh $OOZIE_SITE_FILE TODO-OOZIE-DATABASE-USER-PASSWD $OOZIE_DB_PASSWORD 

# SQOOP (Doesn't appear to need adjustments)

# WebHCat (Don't think any changes needed..)

# ZooKeeper (TODO)
ZOO_ENV_FILE=$HADOOP_CONF_DIR/zookeeper/zookeeper-env.sh
# Need to adjust JAVA_HOME

ZOO_CFG_FILE=$HADOOP_CONF_DIR/zookeeper/zoo.cfg
# Need to adjust the server list 


