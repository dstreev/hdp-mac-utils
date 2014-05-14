
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

HDP_VER=hdp_1.3.7
HTTP_BASE="http://public-repo-1.hortonworks.com/HDP/centos6/1.x/updates/1.3.7.0/tars/"

# TOOLS_BASE="http://public-repo-1.hortonworks.com/HDP/tools/1.3.2.0/"
# COMPANION_FILE="hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107"

# DEFAULT_FILES_BASE="https://raw.github.com/dstreev/HDP_1.3.0_Mac_Utils/master/"
# DEFAULT_FILES="etc_default"

LIB_BASE_DIR=/usr/lib
DEFAULT_DIR=/etc/default

BASE_DIR=$HOME/data/hadoop
HDFS_BASE_DIR=$BASE_DIR/hdfs

MYSQL_ARCHIVE=mysql-connector-java-5.1.25

HADOOP_CONF_DIR=/var/hadoop/local/$HDP_VER

MYSQL_JDBC_JAR=/var/share/jdbc/

HOSTNAME=localhost

HIVE_DB_NAME=hivemetastore
HIVE_DB_USER=hive
HIVE_DB_PASSWORD=hive

OOZIE_DB_NAME=oozie
OOZIE_DB_USER=oozie
OOZIE_DB_PASSWORD=oozie

