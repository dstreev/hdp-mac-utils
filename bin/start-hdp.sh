# Once installed with the 'do.sh', use this script to start everything.

cd /usr/hdp/current/hadoop/sbin
echo "*************************"
echo "*"
echo "*"
echo "*"
echo "*"
echo "    Start HDFS and YARN"
echo "*"
echo "*"
# Start the Core
./start-dfs.sh
./start-yarn.sh


# Start ZooKeeper (For HS2)
echo "**********************"
echo "*"
echo "*"
echo "*"

cd /usr/hdp/current/zookeeper/bin
./zkServer.sh start
echo "*"
echo "*"
echo "**********************"
echo "*"
echo "*"
echo "   Starting HS2"

# Start HS2
# Start MySql (Installed by Brew)
mysql.server start

cd /usr/hdp/current/hive/bin
nohup ./hiveserver2 &
echo "*"
echo "*"
echo "**********************"




