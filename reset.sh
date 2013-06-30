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

if [ $# -ne 1 ]; then
	echo "Usage needs to include a temp storage directory."
	exit -1
fi

SOURCE_DIR=$1

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
. ./mac_env.sh

# Clean up the installation.

# Remove binaries
cat $APP_DIR/hdp_artifacts.txt | while read next; do
	T_FILE=`echo $next | awk '{print $1}'`
	T_LINK=`echo $next | awk '{print $2}'`
		
	cd $LIB_BASE_DIR
	sudo rm -rf $T_LINK
done

sudo rm -rf $LIB_BASE_DIR/$HDP_VER		

# Clean the $SOURCE_DIR
#sudo rm -rf $SOURCE_DIR

# Backup the Configs (move)
DATE=`date +%y%m%d%H%M`
sudo mv $HADOOP_CONF_DIR $HADOOP_CONF_DIR/../$DATE

# Remove the symlinks
sudo rm /etc/hadoop/conf
sudo rm /etc/hbase/conf
sudo rm /etc/hive/conf
sudo rm /etc/oozie/conf
sudo rm /etc/pig/conf
sudo rm /etc/sqoop/conf
sudo rm /etc/webhcat/conf
sudo rm /etc/zookeeper/conf

# Remove /etc/default
cd /etc/default
sudo rm -rf hadoop hbase hcatalog

cd /usr/bin
sudo rm hadoop hive sqoop* zookeeper* pig oozie hbase
