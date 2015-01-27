#!/bin/bash

# Use this script to ensure all the required libraries exists/copied to HDP_VERSION

# Script should be run as HDFS superuser


HDP_VERSION=2.2.0.0-2041
HDFS_HDP_BASE_DIR=/hdp/apps/$HDP_VERSION
DT=`date +%Y%m%d-%H%M`

REQUIRED_FILES="hadoop/mapreduce.tar.gz tez/lib/tez.tar.gz hive/hive.tar.gz pig/pig.tar.gz sqoop/sqoop.tar.gz"
echo ""
echo ""
echo "Installing/Validating Libraries for HDP Version: ${HDP_VERSION}"
echo ""
echo ""
echo "Checking for required files in:"
echo "    - /usr/hdp/current"

# Ensure that the needed files exists on this host
if [ -f /tmp/mapreduce.tar.gz ]; then
    rm /tmp/mapreduce.tar.gz
fi
if [ -f /tmp/tez.tar.gz ]; then
    rm /tmp/tez.tar.gz
fi
if [ -f /tmp/hive.tar.gz ]; then
    rm /tmp/hive.tar.gz
fi
if [ -f /tmp/pig.tar.gz ]; then
    rm /tmp/pig.tar.gz
fi
if [ -f /tmp/sqoop.tar.gz ]; then
    rm /tmp/sqoop.tar.gz
fi

cd /usr/hdp/current
tar cfL /tmp/mapreduce.tar.gz hadoop
tar cfL /tmp/tez.tar.gz tez
tar cfL /tmp/hive.tar.gz hive
tar cfL /tmp/pig.tar.gz pig
tar cfL /tmp/sqoop.tar.gz sqoop

cd `dirname $0`

hdfs dfs -test -d /user/$USER && echo "Directory for Superuser exists in HDFS" || hdfs dfs -mkdir -p /user/$USER
hdfs dfs -test -d /user/oozie && echo "Directory for Superuser exists in HDFS" || hdfs dfs -mkdir -p /user/oozie
hdfs dfs -test -d /apps/hive/warehouse && echo "Directory for Hive exists in HDFS" || hdfs dfs -mkdir -p /apps/hive/warehouse
hdfs dfs -test -d /hdp/apps/$HDP_VERSION && echo "Directory for Hive exists in HDFS" || hdfs dfs -mkdir -p /hdp/apps/$HDP_VERSION
hdfs dfs -test -d /tmp && echo "Directory for Hive exists in HDFS" || hdfs dfs -mkdir -p /tmp

hdfs dfs -chmod -R 755 /hdp

# MapReduce Framework
# "mapreduce.application.framework.path" : "/hdp/apps/${hdp.version}/mapreduce/mapreduce.tar.gz#mr-framework",
# /usr/hdp/$HDP_VERSION/hadoop/mapreduce.tar.gz
hdfs dfs -test -d $HDFS_HDP_BASE_DIR/mapreduce && echo "Directory ${HDFS_HDP_BASE_DIR}/mapreduce exists in HDFS" || hdfs dfs -mkdir -p $HDFS_HDP_BASE_DIR/mapreduce
hdfs dfs -test -f $HDFS_HDP_BASE_DIR/mapreduce/mapreduce.tar.gz && echo "File ${HDFS_HDP_BASE_DIR}/mapreduce/mapreduce.tar.gz exists in HDFS" || hdfs dfs -put /tmp/mapreduce.tar.gz $HDFS_HDP_BASE_DIR/mapreduce

# Tez Framework
# "tez.lib.uris" : "/hdp/apps/${hdp.version}/tez/tez.tar.gz",
# /usr/hdp/$HDP_VERSION/tez/lib/tez.tar.gz
hdfs dfs -test -d $HDFS_HDP_BASE_DIR/tez && echo "Directory ${HDFS_HDP_BASE_DIR}/tez exists in HDFS" || hdfs dfs -mkdir -p $HDFS_HDP_BASE_DIR/tez
hdfs dfs -test -f $HDFS_HDP_BASE_DIR/tez/tez.tar.gz && echo "File ${HDFS_HDP_BASE_DIR}/tez/tez.tar.gz exists in HDFS" || hdfs dfs -put /tmp/tez.tar.gz $HDFS_HDP_BASE_DIR/tez

# Templeton Hive Archive
# "templeton.hive.archive" : "hdfs:///hdp/apps/${hdp.version}/hive/hive.tar.gz",
# /usr/hdp/$HDP_VERSION/hive/hive.tar.gz
hdfs dfs -test -d $HDFS_HDP_BASE_DIR/hive && echo "Directory ${HDFS_HDP_BASE_DIR}/hive exists in HDFS" || hdfs dfs -mkdir -p $HDFS_HDP_BASE_DIR/hive
hdfs dfs -test -f $HDFS_HDP_BASE_DIR/hive/hive.tar.gz && echo "File ${HDFS_HDP_BASE_DIR}/hive/hive.tar.gz exists in HDFS" || hdfs dfs -put /tmp/hive.tar.gz $HDFS_HDP_BASE_DIR/hive

# Templeton Pig Archive
# "templeton.pig.archive" : "hdfs:///hdp/apps/${hdp.version}/pig/pig.tar.gz",
#/usr/hdp/$HDP_VERSION/pig/pig.tar.gz
hdfs dfs -test -d $HDFS_HDP_BASE_DIR/pig && echo "Directory ${HDFS_HDP_BASE_DIR}/pig exists in HDFS" || hdfs dfs -mkdir -p $HDFS_HDP_BASE_DIR/pig
hdfs dfs -test -f $HDFS_HDP_BASE_DIR/pig/pig.tar.gz && echo "File ${HDFS_HDP_BASE_DIR}/pig/pig.tar.gz exists in HDFS" || hdfs dfs -put /tmp/pig.tar.gz $HDFS_HDP_BASE_DIR/pig

# Templeton Sqoop Archive
# "templeton.sqoop.archive" : "hdfs:///hdp/apps/${hdp.version}/sqoop/sqoop.tar.gz",
#/usr/hdp/$HDP_VERSION/sqoop/sqoop.tar.gz
hdfs dfs -test -d $HDFS_HDP_BASE_DIR/sqoop && echo "Directory ${HDFS_HDP_BASE_DIR}/sqoop exists in HDFS" || hdfs dfs -mkdir -p $HDFS_HDP_BASE_DIR/sqoop
hdfs dfs -test -f $HDFS_HDP_BASE_DIR/sqoop/sqoop.tar.gz && echo "File ${HDFS_HDP_BASE_DIR}/sqoop/sqoop.tar.gz exists in HDFS" || hdfs dfs -put /tmp/sqoop.tar.gz $HDFS_HDP_BASE_DIR/sqoop

# Templeton Streaming Jar
# "templeton.streaming.jar" : "hdfs:///hdp/apps/${hdp.version}/mapreduce/hadoop-streaming.jar",
# /usr/hdp/$HDP_VERSION/hadoop-mapreduce/hadoop-streaming.jar
hdfs dfs -test -d $HDFS_HDP_BASE_DIR/mapreduce && echo "Directory ${HDFS_HDP_BASE_DIR}/mapreduce exists in HDFS" || hdfs dfs -mkdir -p $HDFS_HDP_BASE_DIR/mapreduce
hdfs dfs -test -f $HDFS_HDP_BASE_DIR/mapreduce/hadoop-streaming.jar && echo "File ${HDFS_HDP_BASE_DIR}/mapreduce/hadoop-streaming.jar exists in HDFS" || hdfs dfs -put /usr/hdp/current/hadoop/share/hadoop/tools/lib/hadoop-streaming-$HDP_VERSION.jar $HDFS_HDP_BASE_DIR/mapreduce/hadoop-streaming.jar

#/usr/hdp/current/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.2.2.0.0-2041.jar
#/usr/hdp/current/oozie/oozie-sharelib-4.1.0.2.2.0.0-2041.tar.gz


# Reset the Oozie Libraries.
hdfs dfs -test -d /user/oozie/share && echo "Oozie share/lib exists. Backing up and reinstalling";hdfs dfs -mv /user/oozie/share /user/oozie/share.$DT || echo "Oozie share/lib doesn't exist, rebuilding..."

if [ -d /tmp/share ]; then
    rm -rf /tmp/share
fi

echo "Making a copy of the Oozie Sharelib tarball"
cp /usr/hdp/current/oozie/oozie-sharelib-4.1.0.$HDP_VERSION.tar.gz /tmp
cd /tmp
echo "Expanding Oozie ShareLib tarball"
tar xfz oozie-sharelib-4.1.0.$HDP_VERSION.tar.gz

echo "Installing Oozie Sharelib onto HDFS"
hdfs dfs -put /tmp/share /user/oozie/

echo "Setting Oozie Sharelib permissions on HDFS"
# Validate Permissions
hdfs dfs -chmod -R o+rx /user/oozie/share

