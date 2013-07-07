#!/bin/bash

# Check for Group "hadoop"
HADOOP_GROUP=`cat /etc/group | grep 'hadoop'`
if [ "$HADOOP_GROUP" == "" ]; then
	echo "'hadoop group not found, adding"
	groupadd hadoop
fi

# Check for users hdfs and mapred
HDFS_USER=`id hdfs | grep 'no such user'`
if [ "$HDFS_USER" != "" ]; then
	echo "Missing hdfs user, adding"
	useradd -G hadoop -M hdfs
else
	# Check group membership
	HADOOP_GROUP=`id hdfs | grep 'hadoop'`
	if [ "$HADOOP_GROUP" == "" ]; then
		echo "Adding group membership 'hadoop'"
		usermod -G hadoop hdfs
	fi
fi

# Check for users hdfs and mapred
MAPRED_USER=`id mapred | grep 'no such user'`
if [ "$MAPRED_USER" != "" ]; then
	echo "Missing mapred user, adding"
	useradd -G hadoop -M mapred
else
	# Check group membership
	HADOOP_GROUP=`id mapred | grep 'hadoop'`
	if [ "$HADOOP_GROUP" == "" ]; then
		echo "Adding group membership 'hadoop'"
		usermod -G hadoop mapred
	fi
fi
