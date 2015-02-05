#!/bin/sh

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
#ALL_ELEMENTS="hadoop,hbase,hive,pig,oozie,zookeeper,accumulo,storm,falcon,falcon-server,knox,phoenix,tez,tez-full,flume,sqoop,mahout"
#ALL_ELEMENTS="hadoop,hbase,hive,pig,hcatalog,oozie,flume,sqoop,mahout"

cd $APP_DIR
APP_DIR=`pwd`
. ./mac_env.sh

echo "===> Expand and Link"

if [ $# -lt 1 ]; then
	echo "Usage: expand_link.sh $STAGE_DIR [elements]"
else
    if [ ! -d $LIB_BASE_DIR ]; then
        sudo mkdir -p $LIB_BASE_DIR
    fi
	cd $LIB_BASE_DIR
	if [ ! -d $HDP_VER ]; then
		sudo mkdir $HDP_VER	
	fi

	# Cleanup old links
	sudo rm -rf current

	if [ ! -d current ]; then
	    sudo mkdir current
	fi

	ELEMENTS="${2:-$ALL_ELEMENTS}"
	SOURCE_DIR=$1


	cat $APP_DIR/hdp_artifacts.txt | while read next; do
		T_FILE=`echo $next | awk '{print $1}'`
		T_LINK=`echo $next | awk '{print $2}'`
		
		cd $LIB_BASE_DIR
		
		if [[ "$ELEMENTS" =~ $T_LINK ]]; then
		
			echo "Reseting: $T_LINK libraries and links"
			sudo rm -rf $HDP_VER/$T_FILE $T_LINK
			cd $HDP_VER

			# Tez Package in 2.2 doesn't include root dirs like the rest of the distro.
			if [ "${T_LINK}" == "tez" ]; then
			    sudo mkdir $T_FILE
				sudo tar xzf $SOURCE_DIR/$T_FILE.tar.gz -C $T_FILE
			else
				sudo tar xzf $SOURCE_DIR/$T_FILE.tar.gz
			fi

			cd $LIB_BASE_DIR
		
			# The Oozie distribution is inconsistent when extracted
			T_FILE_FIXED=`echo $T_FILE | sed s/-distro//`
		
			# Get the version information
			APP_VER=`echo $T_FILE_FIXED | sed s/$T_LINK\-//`
			echo "App: $T_LINK"
			echo "	Fixed File: $T_FILE_FIXED"
			echo "	Version: $APP_VER"
		
			sudo ln -s $LIB_BASE_DIR/$HDP_VER/$T_FILE_FIXED $LIB_BASE_DIR/current/$T_LINK

			if [ "${T_LINK}" == "hive" ]; then
				sudo ln -s ../$HDP_VER/$T_FILE_FIXED/hcatalog current/hive-hcatalog
			fi

			# Add the adjusted bin scripts to distro.
			sudo cp -v $APP_DIR/configs/bin/$T_LINK/* $LIB_BASE_DIR/current/$T_LINK/bin/

			# Reset the local conf's to link to /etc/$app/conf
			# Because of the lack of consistency of the startup scripts across products
# 			cd $T_LINK
			sudo rm -rf $T_LINK/conf
			sudo ln -s /etc/$T_LINK/conf $T_LINK/conf

			# Special hcatalog symlinks required
# 			if [ "hcatalog" == "$T_LINK" ]; then
# 				cd share/hcatalog
# 				for j in hcatalog-core hcatalog-pig-adapter hcatalog-server-extensions; do
# 					sudo ln -s $j-$APP_VER.jar $j.jar 						
# 				done
# 			fi

			cd $LIB_BASE_DIR
		else
			echo "Skipping $T_LINK, not a requested element"
		fi		
	done
	
	sudo chown -R root:wheel $LIB_BASE_DIR

	# Link in path binaries
	# hadoop,yarn,mapred,hdfs
	sudo rm -f /usr/bin/hadoop
	sudo rm -f /usr/bin/hdfs
	sudo rm -f /usr/bin/mapred
	sudo rm -f /usr/bin/yarn
	sudo rm -f /usr/bin/accumulo
	sudo rm -f /usr/bin/falcon
	sudo rm -f /usr/bin/flume-ng
	sudo rm -f /usr/bin/hbase
	sudo rm -f /usr/bin/hive
	sudo rm -f /usr/bin/beeline
	sudo rm -f /usr/bin/hiveserver2
	sudo rm -f /usr/bin/pig
    sudo rm -f /usr/bin/sqoop
    sudo rm -f /usr/bin/sqoop-codegen
    sudo rm -f /usr/bin/sqoop-create-hive-table
    sudo rm -f /usr/bin/sqoop-eval
    sudo rm -f /usr/bin/sqoop-export
    sudo rm -f /usr/bin/sqoop-help
    sudo rm -f /usr/bin/sqoop-import
    sudo rm -f /usr/bin/sqoop-import-all-tables
    sudo rm -f /usr/bin/sqoop-job
    sudo rm -f /usr/bin/sqoop-list-databases
    sudo rm -f /usr/bin/sqoop-list-tables
    sudo rm -f /usr/bin/sqoop-merge
    sudo rm -f /usr/bin/sqoop-metastore
    sudo rm -f /usr/bin/sqoop-version


	sudo ln -s $LIB_BASE_DIR/current/hadoop/bin/hadoop /usr/bin/hadoop
	sudo ln -s $LIB_BASE_DIR/current/hadoop/bin/hdfs /usr/bin/hdfs
	sudo ln -s $LIB_BASE_DIR/current/hadoop/bin/mapred /usr/bin/mapred
	sudo ln -s $LIB_BASE_DIR/current/hadoop/bin/yarn /usr/bin/yarn

	sudo ln -s $LIB_BASE_DIR/current/accumulo/bin/accumulo /usr/bin/accumulo
	sudo ln -s $LIB_BASE_DIR/current/falcon/bin/falcon /usr/bin/falcon
	sudo ln -s $LIB_BASE_DIR/current/flume/bin/flume-ng /usr/bin/flume-ng
	sudo ln -s $LIB_BASE_DIR/current/hbase/bin/hbase /usr/bin/hbase
	sudo ln -s $LIB_BASE_DIR/current/hive/bin/hive /usr/bin/hive
	sudo ln -s $LIB_BASE_DIR/current/hive/bin/beeline /usr/bin/beeline
	sudo ln -s $LIB_BASE_DIR/current/hive/bin/hiveserver2 /usr/bin/hiveserver2
	sudo ln -s $LIB_BASE_DIR/current/pig/bin/pig /usr/bin/pig
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop /usr/bin/sqoop
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-codegen /usr/bin/sqoop-codegen
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-create-hive-table /usr/bin/sqoop-create-hive-table
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-eval /usr/bin/sqoop-eval
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-export /usr/bin/sqoop-export
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-help /usr/bin/sqoop-help
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-import /usr/bin/sqoop-import
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-import-all-tables /usr/bin/sqoop-import-all-tables
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-job /usr/bin/sqoop-job
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-list-databases /usr/bin/sqoop-list-databases
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-list-tables /usr/bin/sqoop-list-tables
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-merge /usr/bin/sqoop-merge
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-metastore /usr/bin/sqoop-metastore
    sudo ln -s $LIB_BASE_DIR/current/sqoop/bin/sqoop-version /usr/bin/sqoop-version

	# Add SymLink to resolve Default Hadoop Configuration
	for i in hadoop accumulo hive hbase oozie pig sqoop tez zookeeper; do
		if [ -d $LIB_BASE_DIR/current/$i/conf ]; then
			sudo rm -rf $LIB_BASE_DIR/current/$i/conf
		fi
		sudo ln -s /etc/$i/conf $LIB_BASE_DIR/current/$i/conf

	done

	# Backup existing
	if [ -d $HADOOP_CONF_DIR/default ]; then
		sudo mv $HADOOP_CONF_DIR/default $HADOOP_CONF_DIR/default.`date +%Y%m%d%H%M%S`
	fi

	# Setup the default configurations
	sudo mkdir -p $HADOOP_CONF_DIR/default

	sudo cp -R $APP_DIR/configs/accumulo $HADOOP_CONF_DIR/default
	sudo mkdir -p $HADOOP_CONF_DIR/default/hadoop
	sudo cp -R $APP_DIR/configs/core_hadoop/* $HADOOP_CONF_DIR/default/hadoop

	sudo cp -R $APP_DIR/configs/hbase $HADOOP_CONF_DIR/default
	sudo cp -R $APP_DIR/configs/hive $HADOOP_CONF_DIR/default
	sudo cp -R $APP_DIR/configs/oozie $HADOOP_CONF_DIR/default
	sudo cp -R $APP_DIR/configs/pig $HADOOP_CONF_DIR/default
	sudo cp -R $APP_DIR/configs/sqoop $HADOOP_CONF_DIR/default
	sudo cp -R $APP_DIR/configs/tez $HADOOP_CONF_DIR/default
	sudo cp -R $APP_DIR/configs/zookeeper $HADOOP_CONF_DIR/default

	# Reset the links in /etc
	if [ -d /etc/hadoop ]; then
		sudo rm -rf /etc/hadoop
	fi
	if [ -d /etc/accumulo ]; then
	  	sudo rm -rf /etc/accumulo
	fi
	if [ -d /etc/hbase ]; then
	  	sudo rm -rf /etc/hbase
	fi
	if [ -d /etc/hive ]; then
	  	sudo rm -rf /etc/hive
	fi
	if [ -d /etc/oozie ]; then
		sudo rm -rf /etc/oozie
	fi
	if [ -d /etc/pig ]; then
		sudo rm -rf /etc/pig
	fi
	if [ -d /etc/sqoop ]; then
		sudo rm -rf /etc/sqoop
	fi
	if [ -d /etc/tez ]; then
		sudo rm -rf /etc/tez
	fi
	if [ -d /etc/zookeeper ]; then
		sudo rm -rf /etc/zookeeper
	fi

	sudo mkdir /etc/accumulo
	sudo ln -s $HADOOP_CONF_DIR/default/accumulo /etc/accumulo/conf
	sudo mkdir /etc/hadoop
	sudo ln -s $HADOOP_CONF_DIR/default/hadoop /etc/hadoop/conf

	sudo mkdir /etc/hbase
	sudo ln -s $HADOOP_CONF_DIR/default/hbase /etc/hbase/conf
	sudo mkdir /etc/hive
	sudo ln -s $HADOOP_CONF_DIR/default/hive /etc/hive/conf
	sudo mkdir /etc/oozie
	sudo ln -s $HADOOP_CONF_DIR/default/oozie /etc/oozie/conf
	sudo mkdir /etc/pig
	sudo ln -s $HADOOP_CONF_DIR/default/pig /etc/pig/conf
	sudo mkdir /etc/sqoop
	sudo ln -s $HADOOP_CONF_DIR/default/sqoop /etc/sqoop/conf
	sudo mkdir /etc/tez
	sudo ln -s $HADOOP_CONF_DIR/default/tez /etc/tez/conf
	sudo mkdir /etc/zookeeper
	sudo ln -s $HADOOP_CONF_DIR/default/zookeeper /etc/zookeeper/conf

	# Link JDBC drivers
	if [[ "$ELEMENTS" =~ oozie|hive ]]; then
		cd $SOURCE_DIR
		sudo tar xzf $MYSQL_ARCHIVE.tar.gz
		sudo mkdir -p /usr/share/java
		sudo cp $MYSQL_ARCHIVE/$MYSQL_ARCHIVE-bin.jar /usr/share/java
		sudo chmod -R 0555 /usr/share/java
		cd $CUR_DIR
	
		J_FILE="/usr/share/jdbc/$MYSQL_ARCHIVE-bin.jar"
		J_LINK="$MYSQL_ARCHIVE-bin.jar"
		
		echo "Set HIVE jdbc link: $J_FILE -> $J_LINK"
		sudo ln -s $J_FILE $LIB_BASE_DIR/hive/lib/$J_LINK
		echo "Set OOZIE jdbc link: $J_FILE -> $J_LINK"
		sudo ln -s $J_FILE $LIB_BASE_DIR/oozie/libtools/$J_LINK
	fi
	
	# Expand the Defaults
	if [ ! -d $DEFAULT_DIR ]; then
		echo "Creating: $DEFAULT_DIR"
		sudo mkdir -p $DEFAULT_DIR	
	fi	

fi
