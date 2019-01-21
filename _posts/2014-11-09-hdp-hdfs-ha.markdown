---
layout: post
title:  "Contributing to OpenStack Sahara Project"
date:   2014-11-09 18:44:28
comments: true
# categories: hadoop hdfs apache openstack
---

We've been using OpenStack for a while and so recently we decided to contribute back some of our work to the OpenStack Sahara project. OpenStack Sahara aims to make it easy to do data processing on OpenStack, the project currently supports spawning Hadoop clusters and running data processing jobs on data in the OpenStack Object Store (OpenStack Switf).

## OpenStack Cinder Data Locality
The first contribution is in the form of Nova and Cinder filters and weighers to support spawning Cinder volumes on the same host as the virtual machine. The goal is to close the gap (as much as possible) between physically attached disks on a physical server and volumes on a virtual machine In terms of performance in an IO intensive environment. The contribution is still work in progress.

## Hadoop HDFS High Availability
OpenStack Sahara currently supports spawning Hadoop clusters with Apache Hadoop (Vanilla) or HortonWorks HDP2. We decided to contribute by extending the HDP2 plugin by adding the support for spawning clusters with HDFS High Availability. Before Hadoop 2, HDFS NameNode was a single point of failure in any Hadoop cluster and losing the NameNode would render the whole cluster unavailable. With Hadoop 2, HDFS got a mechanism to support NameNode High Availability by using [NFS](https://hadoop.apache.org/docs/r2.3.0/hadoop-yarn/hadoop-yarn-site/HDFSHighAvailabilityWithNFS.html) or [Quorum Journal Manager](https://hadoop.apache.org/docs/r2.3.0/hadoop-yarn/hadoop-yarn-site/HDFSHighAvailabilityWithQJM.html).
Our contribution spawns a cluster with NameNode High Availability setup using the Quorum Journal Manager.

The proposition was accepted and merged in the Openstack Sahara specs project [GitHub link](https://github.com/openstack/sahara-specs/blob/master/specs/kilo/hdp-plugin-enable-hdfs-ha.rst). The code is pending review and approval [Gerrit link](https://review.openstack.org/#/c/132051/). The code is expected to be merged in the next version of OpenStack (OpenStack Kilo expected in mid april 2015)
