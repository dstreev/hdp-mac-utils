# HDP 1.3.0 Mac Utils

A collection of scripts with instructions for installing HDP 1.3.0 (from tarballs) on a Mac.

## Motivation

Provide a working HDP installation on a mac for local use.

### working
> * HDFS
> * MAPRED
> * Hive
> * Pig

### Todo's
> * HCat
> * Flume
> * Sqoop

## Pre-requisites

There are several ways to automatically install many of the components that will be used in this document, but I've chosen to use "[brew](http://mxcl.github.io/homebrew/)" to help with the installation and configuration process.
 
## Artifacts needed for installation

* MySql - Install this with "brew":
** <code>brew install mysql</code>
* wget - install with "brew"
** <code>brew install wget</code>

## Scripts

### do.sh

> This is the main script that will complete the installation and configuration.  
> Once this is complete, everything will be in the correct place and you will only
> need to manually adjust the template configurations for you localhost environment.

### mac_env.sh

> Used to control the parameters used by the rest of the scripts.

### get_artifacts.sh

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

