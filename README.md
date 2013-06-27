# HDP 1.3.0 Mac Utils

A collection of scripts with instructions for installing HDP 1.3.0 (from tarballs) on a Mac.

## Motivation

Provide a working HDP installation on a mac for local use.  Even with the HDP Sandbox, it's sometimes nice to have something on your main OS.  This also proved a valuable exercise to become acquainted with (and still) the various aspects of an HDP manual installation via "tarballs".

## Assumptions
This process assumes you have "[brew](http://mxcl.github.io/homebrew/)" installed.  Before starting, you will need to install "wget" (ie: <code>brew install wget</code>), which we use to pull files down from the web.

You will also need to install "MySQL" via brew (ie: <code>brew install mysql</code>).

Everything will be install AND run from you local user account. 

## Where to Start
The 'do.sh' script will kickoff the installation process.

## Post Installation - House Keeping

### Namenode
> If this is the first-time you've installed HDP, you will need to initialize the Hadoop filesystem with:
	> <code>hadoop namenode -format</code>
> If your upgrade to a new HDP version, you may need to update the namenode before starting HDFS.

### Oozie
> TODO: Get the extjs-2.2 jar and add it to the libs for oozie web.

## Status of Components install here

### Working
> * HDFS
> * MAPRED
> * Hive
> * Pig

### Todo's
> * Oozie
> * HBase
> * HCat
> * Flume
> * Sqoop

## Scripts

### do.sh [temp_dir]

> This is the main script that will complete the installation and configuration.  
> Once this is complete, everything will be in the correct place and you will only
> need to manually adjust the template configurations for you localhost environment.

### mac_env.sh

> Used to control the parameters used by the rest of the scripts.

### get_artifacts.sh [temp_dir]

> A subscript used to fetch the HDP base artifacts and a few
> other helper file sets used to complete the installation.

### expand_link.sh

> Subscript used to expand and link the artifacts retrieved.

### etc_default.tar.gz

> Contains the defaults (pulled from CentOS install) used by the hadoop scripts
> to properly run the environment.

### hdp_artifacts.txt

> A list of HDP artifacts and links to use for each.

### jdbc_cfg.txt

> A file the contains the location of jdbc drivers and the symlink to create for them.
> These are used by Hive.

### reset.sh [temp_dir]

> Use this to remove the installed HDP libraries and configuration files.