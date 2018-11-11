---
layout: post
title:  "HDFS heterogeneous storage"
date:   2014-04-19 19:10:29
comments: true
categories: hadoop hdfs apache
---

Hadoop 2.4.0 was [released](http://hadoop.apache.org/docs/r2.4.0/hadoop-project-dist/hadoop-common/releasenotes.html) last week and with it came the first part of the HDFS heterogeneous storage support.
The idea behind HDFS heterogeneous storage is to expose multiple storage types (HDD, SDD, ...) in HDFS and give HDFS clients the ability to choose a prefered storage type for their files. There's an excellent post about it on [Hortonworks blog](http://hortonworks.com/blog/heterogeneous-storages-hdfs/).
The complete implementation won't be ready before Hadoop 2.5.0, but you can find out more details and patches in the [JIRA ticket](https://issues.apache.org/jira/browse/HDFS-2832).  
