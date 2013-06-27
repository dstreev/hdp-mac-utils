#!/bin/bash

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
. ./mac_env.sh

# Check for mysql installation via Brew
if [ "mysql" == `brew list | grep mysql` ]; then
	echo "MySQL Found"
	echo -n " Checking Status... "
	if [ "SUCCESS!" == `mysql.server status | awk '{print $1}'` ]; then
		echo "Running"
	else
		echo "Stopped"
		echo -n " --- Attempting to start.."
		mysql.server start
		if [ "SUCCESS!" == `mysql.server status | awk '{print $1}'` ]; then
			echo "   STARTED"
			
		else
			echo "Failed to start mysql."
			exit -1
		fi	
	fi
	# Create accounts and DB's
	mysql -u root -e "CREATE USER '$HIVE_DB_USER'@'localhost' IDENTIFIED BY '$HIVE_DB_PASSWORD';"
	mysql -u root -e "CREATE DATABASE $HIVE_DB_NAME DEFAULT CHARACTER SET latin1 DEFAULT COLLATE latin1_swedish_ci;"
	mysql -u root -e "GRANT ALL PRIVILEGES ON $HIVE_DB_NAME.* TO '$HIVE_DB_USER'@'localhost' WITH GRANT OPTION;"
	mysql -u root -e "flush privileges;"

	mysql -u $HIVE_DB_USER -p$HIVE_DB_PASSWORD -D $HIVE_DB_NAME -hlocalhost < /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.10.0.mysql.sql

	echo "Hive Metastore created and initialized"
	
	
	
else
	echo "MySQL (via Brew) not found"
fi