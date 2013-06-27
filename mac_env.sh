HDP_VER=hdp_1.3.0
HTTP_BASE="http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/"

TOOLS_BASE="http://public-repo-1.hortonworks.com/HDP/tools/1.3.0.0/"
COMPANION_FILE="hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107"

DEFAULT_FILES_BASE="https://raw.github.com/dstreev/HDP_1.3.0_Mac_Utils/master/"
DEFAULT_FILES="etc_default"

LIB_BASE_DIR=/usr/lib
DEFAULT_DIR=/etc/default

BASE_DIR=/var/hadoop
HDFS_BASE_DIR=$BASE_DIR/hdfs/localhost

MYSQL_ARCHIVE=mysql-connector-java-5.1.25

HADOOP_CONF_DIR=$BASE_DIR/local/$HDP_VER

MYSQL_JDBC_JAR=/var/share/jdbc/

HOSTNAME=localhost

HIVE_DB_NAME=hivemetastore
HIVE_DB_USER=hive
HIVE_DB_PASSWORD=hive

OOZIE_DB_NAME=oozie
OOZIE_DB_USER=oozie
OOZIE_DB_PASSWORD=oozie
