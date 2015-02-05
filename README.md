# NOTE: This repo is branched by HDP distribution.  The master branch represents (mostly) the latest version of HDP.

# HDP 2.2.0.0 (in-progress)
A collection of scripts with instructions for installing HDP 2.2.0.0 (from tarballs) on a Mac.

I'm currently in the process of validating the changes needed to get 2.2 working.  Initially, you should be able to use the libraries install with this to interact with another 2.2 cluster, assuming you've install the target environment configuration files.

## License
>   Licensed under the Apache License, Version 2.0 (the "License");
>   you may not use this file except in compliance with the License.
>   You may obtain a copy of the License at
>
>       http://www.apache.org/licenses/LICENSE-2.0
>
>   Unless required by applicable law or agreed to in writing, software
>   distributed under the License is distributed on an "AS IS" BASIS,
>   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
>   See the License for the specific language governing permissions and
>   limitations under the License.

## Disclaimer
This effort doesn't imply in any way a supported HDP version of Hadoop on the Mac.  The efforts here are purely academic and should only be used for local experimentation.

## Motivation

Provide a working HDP installation on a mac for local use.  Even with the HDP Sandbox, it's sometimes nice to have something on your main OS.  This also proved a valuable exercise to become acquainted with (and still) the various aspects of an HDP manual installation via "tarballs".

## Assumptions
This process assumes you have "[brew](http://mxcl.github.io/homebrew/)" installed.  Before starting, you will need to install "wget" (ie: <code>brew install wget</code>), which we use to pull files down from the web.

You will also need to install "MySQL" via brew (ie: <code>brew install mysql</code>).

Everything will be install AND run from you local user account. 

## Where to Start
The <code>do.sh</code> script will kickoff the installation process.  It requires a single parameter that identifies a storage location for the artifacts it retrieves from the HDP Repo.  If you are going to rerun the installation, use the same directory and the script will use previously retrieved artifacts.
<code>./do.sh $HOME/temp</code>

## Configurations
The install will create a default configuration located in '/var/hadoop/local/$HDP_VER'.  If you would like to interact with another cluster, download the client configurations for HDFS, MapReduce and YARN.  Extract the contents of all 3 configuration extracts to '/var/hadoop/local/$HDP_VER/<config_name>'.

Use the script 'set_hdp_conf.sh' to change the default config.
<code>./set_hdp_conf.sh <config_name></code>

## Helper Startup Script
Use this script to start basic HDP services.  If this is a first time installation, read the items below to ensure everything is initialized.

'start-hdp.sh'

## Post Installation

### Namenode
> If this is the first-time you've installed HDP, you will need to initialize the Hadoop filesystem with:
	<pre><code>hadoop namenode -format</code></pre>
> If your upgrade to a new HDP version, you may need to update the namenode before starting HDFS.

### Component Libraries
After the initialization of the Namenode (above), you need to create some basic directories in HDFS and install some required libraries for HDFS, MapReduce, Hive, Tez and Oozie.  Run the 'init-hdfs.sh' script to do this.

### Hive
Create a 'hive' user in your MySql instance running locally.  The password should be set to 'hive' as well.

Create a 'hive' database and ensure this user has access to it.  Goto the /usr/hdp/current/hive/scripts/metastore/upgrade/mysql directory and run the latest revision of 'hive-schema-0.xxx.sql' to initialize your hive metastore.

When launching HS2, it will run with an embedded Metastore, so it is not necessary to launch a separate metastore unless you'll be using the HiveCLI.  Check the logs during start to ensure it's connecting to your MySql instance correctly.  The 'hive.log' will be in '/tmp/<user>/hive.log'.

### Oozie
> TODO: Get the extjs-2.2 jar and add it to the libs for oozie web.

## Starting Hadoop
### HDFS and MAPRED:
<pre><code>cd /usr/hdp/current/hadoop/sbin
./start-dfs.sh
./start-yarn.sh</code></pre>

### Hive and Hiveserver2
NOTE: The current configuration assumes that you've created a local hive metastore in MySql with user/pass of hive:hive and Database name of 'hive'.

1. Start Zookeeper
>   <pre><code>cd /usr/hdp/current/zookeeper/bin
./zkServer.sh start</code></pre>
2. Start Hive Server 2
>	<pre><code>cd /usr/hdp/current/hive/bin
nohup ./hiveserver2 &</code></pre>
3. Smoke Test HiveServer2.
	1. Open Beeline command line shell to interact with HiveServer2.
	   <pre><code>beeline</code></pre>
	2. Establish connection to server.
		<pre><code>!connect jdbc:hive2://localhost:10000</code></pre>
    3. Run sample commands.
		<pre><code>show databases;
		create table test2(a int, b string);
		show tables;</code></pre>
		
### HBase
<pre><code>cd /usr/hdp/current/hbase/bin
./start-hbase.sh</code></pre>

#### Smoke Test via HBase Shell
<pre><code>hbase shell</code></pre>

## Status of Components install here

### Working
> * HDFS
> * YARN
> * Hive
> * Tez

### Todo's
> * Pig
> * HBase
> * Flume
> * Sqoop
> * Oozie
> * HCat

## Scripts

### do.sh [temp_dir]
> This is the main script that will complete the installation and configuration.  Once this is complete, everything will be in the correct place and the environment will be configured to "localhost".

### mac_env.sh
> Used to control the parameters used by the rest of the scripts.

### get_artifacts.sh [temp_dir]
> A subscript used to fetch the HDP base artifacts and a few
> other helper file sets used to complete the installation.

### expand_link.sh
> Subscript used to expand and link the artifacts retrieved.

### hdp_artifacts.txt
> A list of HDP artifacts and links to use for each.

### set_hdp_conf.sh
> Use this to change the configurations used by Hadoop.  All configurations rooted under /var/hadoop/local/$HDP_VERSION
>   'default' is set on installation.
>
> To create another configuration, pull the configs from the target cluster and expand them into a new directory under /var/hadoop/local/$HDP_VERSION

### init-hdfs.sh
> For the local hdfs installation, this will build out the base directories and load the appropriate libs onto HDFS.