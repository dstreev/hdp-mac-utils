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

#TODO: Validate/add support for:
#	hcat
#	hbase
#	flume
# 	zookeeper
ALL_ELEMENTS="hadoop,hbase,hive,pig,hcatalog,oozie,zookeeper,flume,sqoop,mahout"

if [ $# -lt 1 ]; then
	echo "Usage: ./go.sh TEMP_DIR [elements]"
	echo"    elements: one or more of hadoop,hbase,pig,hive,sqoop,flume,oozie,mahout,zookeeper"
else

	USER=`whoami`
	SOURCE_DIR=$1
	
	ELEMENTS="${2:-$ALL_ELEMENTS}"
	echo "Elements: $ELEMENTS"

	APP_DIR=`dirname $0`
	. $APP_DIR/mac_env.sh

	if [ ! -d $SOURCE_DIR ]; then
		mkdir -p $SOURCE_DIR
	fi
	
	# Get Artifacts
	. $APP_DIR/get_artifacts.sh $@

	# Deploy Defaults, Template and Link

	# Create Hadoop HDFS and Storage Directories
	if [ ! -d $HDFS_BASE_DIR ]; then
		mkdir -p $HDFS_BASE_DIR
		#sudo chown `whoami` $HDFS_BASE_DIR
		mkdir $HDFS_BASE_DIR/name $HDFS_BASE_DIR/data $HDFS_BASE_DIR/checkpoint $HDFS_BASE_DIR/mapred
		chmod 0750 $HDFS_BASE_DIR/name $HDFS_BASE_DIR/data $HDFS_BASE_DIR/checkpoint $HDFS_BASE_DIR/mapred
		echo ""
		echo ""
		echo "NOTE: HDFS storage locations initialized for the first time."
		echo "      You will need to format the namenode file system before starting"
		echo "		with the following command:"
		echo "		> hadoop namenode -format"
		echo "		IT WOULD BE BEST TO RUN THIS IN A NEW WINDOW TO ENSURE "
		echo "		ALL ENVIRONMENTS ARE SET"
	fi

	if [ ! -d $HADOOP_CONF_DIR ]; then
		sudo mkdir -p $HADOOP_CONF_DIR
		sudo chown `whoami` $HADOOP_CONF_DIR
	else
		sudo chown `whoami` $HADOOP_CONF_DIR
	fi

	# Store pids
	if [ ! -d /var/run/hadoop/$USER ]; then
		mkdir -p $HOME/var/run/hadoop2
		#sudo chown $USER /var/run/hadoop/$USER
	fi
	# Store Logs
	if [ ! -d /var/log/hadoop/$USER ]; then
		mkdir -p $HOME/var/log/hadoop2
		#sudo mkdir -p /var/log/hadoop/mapred
		#sudo chown $USER /var/log/hadoop/$USER
		#sudo chown $USER /var/log/hadoop/mapred
	fi

	# Expand and Link
	. $APP_DIR/expand_link.sh $@

	# Setup MySql for Hive and HCatalog
	# Use a brew installation
	
	if [[ "$ELEMENTS" =~ oozie|hive ]]; then
		if [ -f /usr/local/bin/brew ]; then
			. $APP_DIR/mysql_cfg.sh	
		else
			echo "Brew is installed, you''ll need to install an manage MySql on your own."
		fi
	fi
	
	echo "Installation Complete.  Review output for issues. "
	
	echo "File locations: "
	echo "Binaries: $LIB_BASE_DIR/$HDP_VER with symlinks back to $LIB_BASE_DIR"
	echo "Data Files: $HDFS_BASE_DIR - If these existed before, they were not touched"
	echo "Configuration File: $HADOOP_CONF_DIR with symlinks to:"
	echo "	/etc/hadoop/conf"
	echo "	/etc/hbase/conf"
	echo "	/etc/hive/conf"
	echo "	/etc/zookeeper/conf"
	echo "	/etc/oozie/conf"
	echo "	/etc/sqoop/conf"
	echo "Shell Wrappers for hadoop, hive, sqoop, pig, oozie and hbase added to \/usr\/bin"
	echo "========================"
	echo ""
	echo "For Oozie Initialization YOU MUST:"
	echo "    Change /etc/oozie/conf/oozie-site.xml -> "
	echo "		'oozie.service.JPAService.create.db.schema to 'true' to initialize the oozie database"
	echo ""
fi
