# HDP 1.3.0 Mac Utils

A collection of scripts with instructions for installing HDP 1.3.0 (from tarballs) on a Mac.

## Motivation

Provide a working HDP installation on a mac for local use.

## Pre-requisites

There are several ways to automatically install many of the components that will be used in this document, but I've chosen to use "[brew](http://mxcl.github.io/homebrew/)" to help with the installation and configuration process.
 
## Artifacts needed for installation

* MySql - Install this with "brew":
> <code>brew install mysql</code>
* wget - install with "brew"
> <code>brew install wget</code>
* HDP 1.3.0 tarballs
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/hadoop-1.2.0.1.3.0.0-107.tar.gz</code>
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/pig-0.11.1.1.3.0.0-107.tar.gz</code>
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/hive-0.11.0.1.3.0.0-107.tar.gz</code>
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/hcatalog-0.11.0.1.3.0.0-107.tar.gz</code>
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/oozie-3.3.2.1.3.0.0-107-distro.tar.gz</code>
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/sqoop-1.4.3.1.3.0.0-107.bin__hadoop-1.2.0.1.3.0.0-107.tar.gz</code>
> <code>wget http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/tars/apache-flume-1.3.1.1.3.0.0-107-bin.tar.gz</code>


