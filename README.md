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

## Post Installation - House Keeping

### Namenode
> If this is the first-time you've installed HDP, you will need to initialize the Hadoop filesystem with:
	<pre><code>hadoop namenode -format</code></pre>
> If your upgrade to a new HDP version, you may need to update the namenode before starting HDFS.

### Hive
  
### Oozie
> TODO: Get the extjs-2.2 jar and add it to the libs for oozie web.

## Starting Hadoop, etc.. Short-version
### HDFS and MAPRED
<pre><code>/usr/hdp/current/hadoop/sbin/start-all.sh</code></pre>

### Hive Metastore
<pre><code>start-hive-metastore.sh</code></pre>
> See below for instructions to smoke test hive.

## Starting Hadoop, etc.. Long-version
### HDFS and MAPRED:
<pre><code>cd /usr/hdp/current/hadoop/sbin
./start-dfs.sh
./start-yarn.sh</code></pre>

### Hive and Hiveserver2
1. Start Hive Metastore service.
>	<pre><code>nohup hive --service metastore&gt;$HIVE_LOG_DIR/hive.out 2&gt;$HIVE_LOG_DIR/hive.log & </code></pre>
2. Smoke Test Hive.
	1. Open Hive command line shell. <pre><code>hive</code></pre>
	2. Run sample commands.
		<pre><code>show databases;
		create table test(col1 int, col2 string);
		show tables;</code></pre> 
3. Start HiveServer2.
	<pre><code>nohup /usr/hdp/current/hive/bin/hiveserver2>$HIVE_LOG_DIR/hiveserver2.out 2>$HIVE_LOG_DIR/hiveserver2.log &</code></pre>
4. Smoke Test HiveServer2.
	1. Open Beeline command line shell to interact with HiveServer2.
	   <pre><code>beeline</code></pre>
	2. Establish connection to server.
		<pre><code>!connect jdbc:hive2://localhost:10000 $USER password org.apache.hive.jdbc.HiveDriver</code></pre>
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

### Todo's
> * Hive
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