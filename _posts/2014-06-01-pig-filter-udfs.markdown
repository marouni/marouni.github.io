---
layout: post
title:  "Extending Apache Pig to filter your Big Data"
date:   2014-06-01 12:14:20
comments: true
# categories: hadoop hdfs apache pig
---

[Apache Pig](http://pig.apache.org/) provides a simple to use abstraction layer on top of Hadoop MapReduce. Pig allows us to define complex data flows using its scripting language Pig-Latin. Pig-Latin is a procedural scripting language with a gradual learning curve and a lot of built-in functions and a fairly large open source community. 

A data flow, written in Pig-Latin, hides all of the low level complexities of MapReduce so that we can focus on data and avoid writing low level Java code. Developing complex data flows with Pig-Latin is easy using the built-in functions, but sometimes we need to implement our own functions that are specific to our data or that apply a specific business logic to the data. 

For these reasons Pig provides User Defined Functions (UDFs) that can be written in Java or Python and easily integrated with Pig-Latin. The Pig community has a public repository called [PiggyBank](https://github.com/apache/pig/tree/branch-0.12/contrib/piggybank) where you can find user contributed functions, you should always check this repository before writing your own UDF.

### Pig ETL
Pig is best suited for doing ETL (Extract Transform Load) operations on raw data-sets. Other common Pig tasks include data cleaning and data exploration, data cleaning removes bad records from the data-set so that the next step in the data flow can operate on cleaned data-set. For example we can remove bad records from the data set by adding a filter in the data flow :

{% highlight bash %}
A = LOAD '/user/hdfs/raw-data-set' USING PigStorage(',') AS (id:int, weight:int, age:int);
B = FILTER A BY $3 > 0; 
C = ...
D = ...
{% endhighlight %}

In the above example we're filtering records with negative age, once cleaned we can continue developing our data flow by adding more relations and/or implementing our specific data processing steps.
Cleaning a data-set gets complicated when deciding whether a record is clean or not is not straight forward or difficult to do with the built-in functions. For these situations we can write our own filter function that will examine each record and decide if it's clean or not, these filter functions can also call other functions from our libraries that can execute complex processing.

## Setup
Filter UDFs are user defined functions that return a boolean, these functions are mostly used with FILTER expression to filter records. To implement a filter UDF in java we need to extend a class then override a method, this method is called for every record in our data set and its return value (true or false) decides whether the record passes the filter or not.

To setup a quick development environment I'll use Eclipse with Gradle plugin, you can use Maven or Ant + Ivy even !
Here's the dependencies section of my build.gradle file :


{% highlight groovy %}
dependencies {
    compile group: 'commons-collections', name: 'commons-collections', version: '3.2'
    testCompile group: 'junit', name: 'junit', version: '4.+'
    compile 'org.apache.pig:pig:0.12.0'
    compile 'org.apache.hadoop:hadoop-core:1.2.0'
        
}
{% endhighlight %}

We need the hadoop-core and pig jars + other jars if you're using external libs in the filter UDF.

## Filter UDF
When writing filter UDF for Pig-Latin all we need to do, after preparing a development environment and creating a project with the correct set of dependencies, is to extend the _FilterFunc_ class of org.apache.pig :

{% highlight java %}
package io.ushabti;

import java.io.IOException;

import org.apache.pig.FilterFunc;
import org.apache.pig.data.Tuple;

public class FilterA extends FilterFunc {

	@Override
	public Boolean exec(Tuple input) throws IOException {
		// Logic to filter the records
		return null;
	}

}
{% endhighlight %}

After extending the _FilterFunc_ we should override the _exec_ method. The _exec_ method takes a tuple as argument and should return _true_ or _false_. The logic inside _exec_ method depends on how you'll decide if a record is clean or not. The _exec_ takes a variable number of raguments presented as a tuple, we simply use the get method of the Tuple to extract the arguments that we're going to use in our function. We must also cast the fields of the tuple before using them.

## Demonstration
For the purpose of this demonstration we'll consider a simple data-set where each record is a line with multiple fields separated by ','. Suppose now that we'll decide if a record is clean or not by applying our Filter UDF to the fourth field of the record and returning _ture_ if the record is clean or _false_ otherwise. We'll start by writing our Filter UDF : 

{% highlight java %}
package io.ushabti;

import java.io.IOException;

import org.apache.pig.FilterFunc;
import org.apache.pig.data.Tuple;
import io.ushabti.ZetaFilter;

public class FilterA extends FilterFunc {

	@Override
	public Boolean exec(Tuple input) throws IOException {
		// cast the field we want to examine
		field4 = (int) input.get(0);
		// Implement your filtering logic here. I'm calling a custom filter that I prepared :
		clean = ZetaFilter.filter((int) input.get(4));
		// return true or false
		return clean;
	}
	
}
{% endhighlight %}

The Filter UDF will examine the 4 field, after casting it to integer, by passing it to a special filter function (in my case a custom filter called ZetaFilter). You can do whatever you want inside the _exec_ method to decide if the record/field is clean or not.

Next I'll compile and package my Filter UDF in a jar (the details depend on your build tool), in gradle we just have to execute the gradle tasks _clean jar_. After compiling and packaging, we'll end up with a jar containing out Filter UDF. Next we'll register the jar in Pig-Latin and call it from there :


{% highlight bash %}
register '/home/abbass/zeta_filter-1.0.jar'
raw_data = load 'dataset' USING PigStorage(',');
// Here we'll call the Filter UDF to clean the data set
cleaned_data = FILTER A by io.ushabti.FilterA($3);
cleaned_data_trans1 = ...
cleaned_data_trans2 = ...
{% endhighlight %}

We register the jar with _register_ keyword in Pig-Latin, the jar is looked up locally on the machine executing the pig script. The location of the jar can be for example the build output folder of our UDF development. Next, we load the data-set (relation raw_data) then we'll call our Filter UDF in the cleaned_data relation. The subsequent relations will work with the output of cleaned_data relation to transform the data or apply other logic to the cleaned data-set.


## Counters
We can make use of MapReduce counters to count the number of bad records in our data-set by augmenting the counter each time we encounter a bad record :

{% highlight java %}
package io.ushabti;

import java.io.IOException;

import org.apache.pig.FilterFunc;
import org.apache.pig.data.Tuple;
import org.apache.pig.tools.counters.PigCounterHelper;
import io.ushabti.ZetaFilter;

public class FilterA extends FilterFunc {

    enum zetaCounter {
		bad
		}
	PigCounterHelper counterHelper = new PigCounterHelper();

	@Override
	public Boolean exec(Tuple input) throws IOException {
		// cast the field we want to examine
		field4 = (int) input.get(0);
		// Implement your filtering logic here. I'm calling a custom filter that I prepared. My function returns a boolean :
		clean = ZetaFilter.filter((int) input.get(4));
		// increment bad records counter each time we encounter a bad record
		if !clean
		  counterHelper.incrCounter(zetaCounter.bad, 1);
		// return true or false
		return clean;
	}
}
{% endhighlight %}

We implement the counters by importing PigCounterHelper and instantiating a counter outside the _exec_ method. We increment the counter for each bad record we detect. By adding the counter then examining the counter (on MapReduce jobHistory webui) we can get an idea about the percentage of bad records in our data-set.

You can also estimate the number of bad records in your data-set by applying your Filter UDF with counter on a sample of the data-set :


{% highlight bash %}
register '/home/abbass/zeta_filter-1.0.jar'
raw_data = load 'dataset' USING PigStorage(',');
// a 10% sample of the data-set
data_sample = SAMPLE raw_data 0.1
// Here we'll call the Filter UDF to clean the data set
cleaned_data = FILTER data_sample by io.ushabti.FilterA($3);
{% endhighlight %}

This way you don't have to apply your complex your Filter UDF on all of the data-set, and you can estimate the percentage of bad records in your data-set by using the counter and extrapolating to the entire data-set size.

## Fin
Cleaning big-data-sets becomes easy with Pig and the ability to implement specific Filter UDFs make the task easier and more customizable.  

