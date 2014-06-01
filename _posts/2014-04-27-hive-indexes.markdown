---
layout: post
title:  "Hive indexes"
date:   2014-04-27 12:14:20
categories: jekyll update
---

# Apache Hive Indexes

[Apache Hive](http://hive.apache.org/) provides a data warehousing layer on top of Hadoop. Hive uses Hadoop's MapReduce as its query engine to execute complex SQL-like queries over data in Hadoop's file system (HDFS).
Hive was developed at Facebook to deal with the ever increasing volume of data in their data warehouses. It's still in use at Facebook as the recently published [blog post](https://code.facebook.com/posts/229861827208629/scaling-the-facebook-data-warehouse-to-300-pb/) speaks of numerous innovations in Hive's ecosystem to scale to 600TB of daily data rate.       

Hive's query language HiveQL supports a large subset of the ANSI-SQL standard, both in the [Data Definition Language](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL) and the [Data Manipulation Language](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DML). Among the DDL supported features is the ability to create indexes on tables using the standard SQL _'CREATE INDEX ...'_ statement.  
Before diving into the details of Hive indexes it's worth mentioning what happens under the covers when we execute a Hive query. In fact Hive is just an abstraction layer on top of MapReduce to support SQL queries on HDFS files. We create Hive tables with schemas that map directly to files in HDFS, then we execute SQL queries on these tables (files). SQL queries are processed by Hive's query engine and a series of MapReduce jobs are executed on the tables (files) and output is stored in new tables (files) or dumped to the screen.  
The fact that Hive relies on MapReduce jobs to execute queries means that a query is divided into a series of Map and Reduce tasks. Map tasks will read data from tables (files) and do some processing if necessary then output from these tasks is shuffled to the reduce tasks (if necessary also) that process it and write back to HDFS. As I mentioned earlier Hive tables are just schemas over HDFS files, these files are managed by HDFS that will divide them into blocks. Blocks in HDFS are the standard working units for MapReduce jobs, so a single mapper will, by defualt, process a single block (from a list of blocks that make up a file/table) and the more blocks we have the more mappers we need to process them.  
One way to reduce processing time is to process less blocks for a given file/table, here's where Hive Indexes come into play. Hive will index a column in a table by creating a second table with mappings between column values and HDFS blocks, so to execute a query on the indexed column of the table we process fewer blocks thanks to the index that told our mappers which blocks have the column value we're interested in. The details and benefits of Hive indexes will become clearer in the next sections. Indexes in Hive are supported as of version 0.7, any recent Hadoop distribution (HortonWorks, Cloudera, ...) has a recent version of Hive that supports indexes.

## HDFS setup
For this demostration we'll use a file with 2 integer fields (a sequence from 1 to 1000000, random integer between 1 and 32000) with 1000000 entries. Here's a sample of this file :

```bash
[root@sandbox]$ head input 
1 3256
2 1356
3 6995
4 3327
5 6470
6 8457
7 1235
8 59
9 8687
10 4095
``` 

Next we'll put the file in HDFS with a smaller block size, so as to simulate the case where a single file is divided into several blocks :

```bash
[root@sandbox]$ hadoop fs -Ddfs.blocksize=1048576 -put input /user/index/ds1
```

Using the minimum block size we get 12 blocks:

```bash
[root@sandbox]$ hdfs fsck -blocks /user/index/ds1/input
...
Total blocks (validated):	12 (avg. block size 979415 B)
...
```

## Hive setup
The input file is now in HDFS and divided into 12 blocks, next we'll create a Hive table with a schema with 2 columns that map to our input file. In the Hive shell  :

```sql
hive> CREATE TABLE tab1 (id INT, pass INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ';
OK
Time taken: 0.453 seconds

hive> load data inpath '/user/index/ds1' into table tab1;
OK
Time taken: 12.212 seconds

```

Next we'll test a simple dump query to check the table's schema :

```sql
hive> SELECT * FROM tab1 LIMIT 10;
OK
1	3256
2	1356
3	6995
4	3327
5	6470
6	8457
7	1235
8	59
9	8687
10	4095
```
Simple 'SELECT * FROM' queries do not need any MapReduce processing, so we get an instantaneous response.

## un-indexed table query

For the first test, we'll run a simple query on the un-indexed table so that we can later compare it to a query on an indexed table.

```sql
hive> SELECT * FROM tab1 WHERE id=45;

OK
45	1795

```

Hive's query planner examines the query 'SELECT * FROM tab1 WHERE id=45' and decides to execute a Map-only MapReduce job. The job executes in *30.397* *seconds* and returns a response :

```sql
OK
45	179
```

Examining the job logs (on the job history server) reveal some details about the executed job. Namely the blocks read by the Map-only job :

```bash
2014-04-27 03:37:13,457 INFO [main] org.apache.hadoop.mapred.MapTask: Processing split: Paths:
/apps/hive/warehouse/tab1/input:0+1048576,
/apps/hive/warehouse/tab1/input:1048576+1048576,
/apps/hive/warehouse/tab1/input:2097152+1048576,
/apps/hive/warehouse/tab1/input:3145728+1048576,
/apps/hive/warehouse/tab1/input:4194304+1048576,
/apps/hive/warehouse/tab1/input:5242880+1048576,
/apps/hive/warehouse/tab1/input:6291456+1048576,
/apps/hive/warehouse/tab1/input:7340032+1048576,
/apps/hive/warehouse/tab1/input:8388608+1048576,
/apps/hive/warehouse/tab1/input:9437184+1048576,
/apps/hive/warehouse/tab1/input:10485760+1048576,
/apps/hive/warehouse/tab1/input:11534336+218655
InputFormatClass: org.apache.hadoop.mapred.TextInputFormat 
```
The logs show that all of the 12 blocks were read by the Map-only job. Notice the _1048576_ which was our block size.

## Index setup

In this section we'll take our table tab1 and create an index on the _id_ column. Creating an index on a column is straight forward :

```sql
hive> CREATE INDEX tab1_index on TABLE tab1(id) AS 'COMPACT' WITH DEFERRED REBUILD;
hive> ALTER INDEX tab1_index ON tab1 REBUILD;
```

The first statement declares an index on the _id_ column of the _tab1_ table, the second statement actually builds the index.
Hive supports 2 types of indexes with the possibility of extending the _indexHandler_ Java class for implementing custom indexes. The first type of Hive indexes is the _Compact_ _index_. Using the Compact index Hive creates a table with 3 columns, the first column represent the indexed column(s) _id_ in our case, the second column is the _bucketname_ which in our case is the _filename_ (_input_) and the last column is the offset in the _bucketname_. We can see the column names using describe on the generated table :

```sql
hive> DESCRIBE default__tab1_tab1_index__;
OK
id                  	int                 	               
_bucketname         	string              	                    
_offsets            	array<bigint>       	                    
Time taken: 1.244 seconds, Fetched: 3 row(s)
```

Hive launches a MapReduce job to fill our index table, when the job ends we can query our index table to see what it looks like :

```sql
hive> SELECT * FROM default__tab1_tab1_index__ LIMIT 10;
OK
id  _bucketname                     _offsets
1	/apps/hive/warehouse/tab1/input	[0]
2	/apps/hive/warehouse/tab1/input	[7]
3	/apps/hive/warehouse/tab1/input	[14]
4	/apps/hive/warehouse/tab1/input	[21]
5	/apps/hive/warehouse/tab1/input	[28]
6	/apps/hive/warehouse/tab1/input	[35]
7	/apps/hive/warehouse/tab1/input	[42]
8	/apps/hive/warehouse/tab1/input	[49]
9	/apps/hive/warehouse/tab1/input	[54]
10	/apps/hive/warehouse/tab1/input	[61]
Time taken: 4.811 seconds, Fetched: 10 row(s)
```

As we can see from the response of the SELECT query on our index table, for each value in our _id_ column (of tab1) Hive generated the corresponding _bucketname_ (_input_ _file_) and the offset of the _id_ in the _bucketname_ (_input_ _file_). Hive uses the above table to deduce the block(s) where the _id_ value appears. For example the _id_ value of 3 is in the first block because its _offset_ (14) is less than the blocksize (1048576), so querying the table _tab1_ for _id_ = 3 using the index will cause Hive to scan the first block only.

We're done setting up our index, so let's see how we can use!

## Querying an indexed table
If you're coming from a relational database background you will probably be disappointed by the way we use indexes in Hive. But remember that Hive is a fairly recent and specially indexing which is still under development.  

Contrary to indexes in a RDBMS, we need to explicitly tell Hive to generate an index file on a given column :
 
```sql
hive> INSERT OVERWRITE DIRECTORY "/tmp/index_test_result" SELECT `_bucketname` ,
`_offsets` FROM default__tab1_tab1_index__ where id=45;

hive> SET hive.index.compact.file=/tmp/index_test_result;
hive> SET hive.input.format=org.apache.hadoop.hive.ql.index.compact.HiveCompactIndexInputFormat;
```

In the above example we generate a index file on _id_=45 by writing a file in HDFS with the _bucketname_ and _offset_ of the corresponding column. Then, we set some variables to tell Hive about our index type and our index file.  
Finally we query our table as usual :

```sql
hive> SELECT * from tab1 WHERE id=45;

OK
45	1795

```

The above query is the same as our previous query on the same table without the index. This time Hive uses the index file we supplied to scan (process) the block(s) that contain the value we're looking for (_45_). We can verify this by checking the logs of the MapReduce job (on the history server) 

```bash
2014-04-28 13:20:56,595 INFO [main] org.apache.hadoop.mapred.MapTask: Processing split:  
org.apache.hadoop.mapred.TextInputFormat:
hdfs://sandbox.hortonworks.com:8020/apps/hive/warehouse/tab1/input:0+1048576
```

We can clearly see that this MapReduce job scanned a single block to get the job done. The same job scanned all of the blocks (12) when we did not setup and use indexes.

# Fin
Hive indexes are still under development but when setup and used correctly can improve response times on big data sets. In upcoming posts we'll talk about the other type of Hive indexes the _Bitmap_ index so stay tuned !  
