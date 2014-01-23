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
ALL_ELEMENTS="hadoop,hbase,hive,pig,hcatalog,oozie,flume,sqoop,mahout"

cd $APP_DIR
APP_DIR=`pwd`
. ./mac_env.sh

echo "===> Expand and Link"

if [ $# -lt 1 ]; then
	echo "Usage: expand_link.sh $STAGE_DIR [elements]"
else

	cd $LIB_BASE_DIR
	if [ ! -d $HDP_VER ]; then
		sudo mkdir $HDP_VER	
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
			sudo tar xzf $SOURCE_DIR/$T_FILE.tar.gz
			cd $LIB_BASE_DIR
		
			# The Oozie distribution is inconsistent when extracted
			T_FILE_FIXED=`echo $T_FILE | sed s/-distro//`
		
			# Get the version information
			APP_VER=`echo $T_FILE_FIXED | sed s/$T_LINK\-//`
			echo "App: $T_LINK"
			echo "	Fixed File: $T_FILE_FIXED"
			echo "	Version: $APP_VER"
		
			sudo ln -s $HDP_VER/$T_FILE_FIXED $T_LINK

			# Reset the local conf's to link to /etc/$app/conf
			# Because of the lack of consistency of the startup scripts across products
			cd $T_LINK
			sudo rm -rf conf
			sudo ln -s /etc/$T_LINK/conf conf

			# Special hcatalog symlinks required
			if [ "hcatalog" == "$T_LINK" ]; then
				cd share/hcatalog
				for j in hcatalog-core hcatalog-pig-adapter hcatalog-server-extensions; do
					sudo ln -s $j-$APP_VER.jar $j.jar 						
				done
			fi

			cd $LIB_BASE_DIR
		else
			echo "Skipping $T_LINK, not a requested element"
		fi		
	done
	
	sudo chown -R root:wheel $LIB_BASE_DIR
	
	# Link JDBC drivers
	if [[ "$ELEMENTS" =~ oozie|hive ]]; then
		cd $SOURCE_DIR
		sudo tar xzf $MYSQL_ARCHIVE.tar.gz
		sudo mkdir -p /usr/share/jdbc
		sudo cp $MYSQL_ARCHIVE/$MYSQL_ARCHIVE-bin.jar /usr/share/jdbc
		sudo chmod -R 0555 /usr/share/jdbc
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
	
	cd $CUR_DIR
	sudo cp $APP_DIR/etc/default/* $DEFAULT_DIR
	sudo chmod -R uog+x /etc/default
	cd $DEFAULT_DIR
	
	echo "default complete"
	
	# Expand the Templates and Link
	# DON'T OVERWRITE IF THEY ARE THERE ALREADY
	if [ -d $HADOOP_CONF_DIR/core_hadoop ]; then
		echo "Configs are already present, they have NOT been overwritten"
	else
		cd $SOURCE_DIR
		#if [ ! -f $COMPANION_FILE ]; then
		#	echo "Expanding companion files"
		#	tar xzf $COMPANION_FILE.tar.gz
		#fi	
		
		cd $APP_DIR/configs	
		#cd $COMPANION_FILE/configuration_files
		cp -R * $HADOOP_CONF_DIR
		
		#echo $HOSTNAME > $HADOOP_CONF_DIR/core_hadoop/masters
		#echo $HOSTNAME > $HADOOP_CONF_DIR/core_hadoop/slaves

		#echo "NOTICE: You MUST now edit all the appropriate configs in the $HADOOP_CONF_DIR directory for your environment."
		#echo "	You need to change settings in:"
		#echo "		core_hadoop, hive, oozie, pig, sqoop, webhcat, zookeeper"
		#echo ""
		#echo "  Review the configs in these directories and configure for -localhost-"
		
		#echo ""
		echo ""
		echo "Setting up config links"
		
		# Adjust the configs that were just copied for this environment.
		#cd $CUR_DIR
		#. $APP_DIR/fix_cfgs.sh
		
		# Install helper and wrapper scripts
		sudo cp $APP_DIR/usr/bin/* /usr/bin
		
		# Link configs to standard location know by scripts
		if [ ! -d /etc/hadoop ]; then
			sudo mkdir /etc/hadoop
		fi
		if [ ! -d /etc/hbase ]; then
			sudo mkdir /etc/hbase
		fi
		if [ ! -d /etc/hive ]; then
			sudo mkdir /etc/hive
		fi
		if [ ! -d /etc/oozie ]; then
			sudo mkdir /etc/oozie
		fi
		if [ ! -d /etc/pig ]; then
			sudo mkdir /etc/pig
		fi
		if [ ! -d /etc/sqoop ]; then
			sudo mkdir /etc/sqoop
		fi
		if [ ! -d /etc/webhcat ]; then
			sudo mkdir /etc/webhcat
		fi
		if [ ! -d /etc/zookeeper ]; then
			sudo mkdir /etc/zookeeper
		fi
		#TODO: NEED VALIDATION ON FLUME CONFIGURATION
		if [ ! -d /etc/flume ]; then
			sudo mkdir /etc/flume
		fi
	fi

	# Remove old symlinks
	if [ -d /etc/hadoop/conf ]; then
		sudo rm /etc/hadoop/conf
	fi
	if [ -d /etc/hbase/conf ]; then
		sudo rm /etc/hbase/conf
	fi
	if [ -d /etc/hive/conf ]; then
		sudo rm /etc/hive/conf
	fi
	if [ -d /etc/oozie/conf ]; then
		sudo rm /etc/oozie/conf
	fi
	if [ -d /etc/pig/conf ]; then
		sudo rm /etc/pig/conf
	fi
	if [ -d /etc/sqoop/conf ]; then
		sudo rm /etc/sqoop/conf
	fi
	if [ -d /etc/webhcat/conf ]; then
		sudo rm /etc/webhcat/conf
	fi
	if [ -d /etc/zookeeper/conf ]; then
		sudo rm /etc/zookeeper/conf
	fi

	# Set/Reset symlinks
	sudo ln -s $HADOOP_CONF_DIR/core_hadoop /etc/hadoop/conf
	sudo ln -s $HADOOP_CONF_DIR/hbase /etc/hbase/conf
	sudo ln -s $HADOOP_CONF_DIR/hive /etc/hive/conf
	sudo ln -s $HADOOP_CONF_DIR/oozie /etc/oozie/conf
	sudo ln -s $HADOOP_CONF_DIR/pig /etc/pig/conf
	sudo ln -s $HADOOP_CONF_DIR/sqoop /etc/sqoop/conf
	sudo ln -s $HADOOP_CONF_DIR/webhcat /etc/webhcat/conf
	sudo ln -s $HADOOP_CONF_DIR/zookeeper /etc/zookeeper/conf

	echo "  === DONE: Don't forget to adjust your configs for 'localhost'"
fi
