# Once installed with the 'do.sh', use this script to start everything.
echo "*************************"
echo "*"
echo "*"
echo "*"
echo "*"
echo "You will need to manually kill the HS2 process.  Find the pid and kill it."
echo "*"
echo "*"
echo "*"
echo "*"
echo "*************************"

# Start ZooKeeper (For HS2)
echo "*"
echo "    Stopping Zookeeper"
echo "*"
cd /usr/hdp/current/zookeeper/bin
./zkServer.sh stop

# Stop HDFS and YARN
cd /usr/hdp/current/hadoop/sbin

echo "*"
echo "*"
echo "***********************"
echo "*"
echo "    Stopping YARN and HDFS"
echo "*"
echo "*"
# Start the Core
./stop-yarn.sh
./stop-dfs.sh




