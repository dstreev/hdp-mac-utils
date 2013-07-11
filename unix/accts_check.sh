#!/bin/bash

# Check for Group "hadoop"
HADOOP_GROUP=`cat /etc/group | grep 'hadoop'`
if [ "$HADOOP_GROUP" == "" ]; then
	echo "'hadoop group not found, adding"
	groupadd hadoop
fi

# Check for users hdfs and mapred
if [[ "`id hdfs 2>&1`" =~ 'no such user' ]]; then
	echo "Missing hdfs user, adding"
	useradd -g hadoop -M hdfs
else
	# Check group membership
	if [[ "`id hdfs`" =~ hadoop ]]; then
		echo "Adding group membership 'hadoop'"
		usermod -g hadoop hdfs
	fi
fi

# Check for users hdfs and mapred
if [[ "`id mapred 2>&1`" =~ 'no such user' ]]; then
	echo "Missing mapred user, adding"
	useradd -g hadoop -M mapred
else
	# Check group membership
	HADOOP_GROUP=`id mapred | grep 'hadoop'`
	if [[ "`id mapred`" =~ hadoop ]]; then
		echo "Adding group membership 'hadoop'"
		usermod -g hadoop mapred
	fi
fi
