---
layout: post
title:  "Mining crypto currencies with Apache Spark"
date:   2017-12-10 19:44:30
comments: true
categories: hadoop hdfs apache spark
excerpt_separator: <!--more-->
---

![](http://dogecoin.com/imgs/dogecoin-300.png "Dogecoin") ![](https://spark.apache.org/images/spark-logo-trademark.png "Apache Spark")

## Crypto currencies
Crypto currencies are gaining more and more momentum, and the last Bitcoin surge (17/12/2017) where the exchange price almost hit the 20000$ mark [1] is just another evidence of this momentum.

<!--more-->

Developers and users alike are riding the crypto currency wave with Bitcoin adoption soaring as evidenced by the number of unique address transactions [2].

But Bitcoin isn't the only player in the crypto currency market, with a 37% market share [3] (at the time of writing) it lives along side the remaining 63% divided between more than 1300 digital currencies ! [4]. So, there's a plenty of currencies to choose from and to mine, which brings us to the main topic of this post.

## CPU mining is so 2009 !
Mining is the corner stone of all PoW (Proof of Work) based crypto currencies as it integrates and secures the transactions in the currency's public ledger (more on this in the excellent *Mastering Bitcoin* chapter on [Mining](http://chimera.labs.oreilly.com/books/1234000001802/ch08.html).

Mining rewards miners with new coins, so people started investing heavily in mining equipment, with some specialized mining hardware that costs thousands of dollars like the [Antminer S9](https://shop.bitmain.com/antminer_s9_asic_bitcoin_miner.htm). So mining on one's PC or even phone became quickly obsolete as it couldn't keep up with the dedicated mining hardware. Some new currencies are working on alternative mining approaches that are more CPU friendly, and even some less popular currencies are still profitable and *fun* with CPU mining.


The most popular CPU mining project is still the [cpu-miner](https://github.com/pooler/cpuminer) which supports a wide variety of algorithms and the latest pool mining protocols.

## Distributed mining with Apache Spark
[Apache Spark](https://spark.apache.org/) is a popular large scale distributed data processing framework with a wide range of practical use cases. While Spark provides the processing logic, the distributed execution is often delegated to separate cluster managers (Apache Yarn, Apache Mesos, Kubernetes). These cluster managers take care of all the distributed systems plumbing like running different workers on different cluster nodes and assigning appropriate cluster resources to these workers.

With this in mind, I wrote a Spark job that uses the cpu-miner as the main processing logic. In doing so I was able to run the cpu-miner on the underlying cluster without any additional cluster specific configuration.

The Spark job starts by distributing the cpu-miner to the cluster workers :
```scala
sparkContext.addFile(localScriptPath)
sparkContext.addFile(localMinerdPath)
val remoteScriptPath = SparkFiles.get(RUNNER_SCRIPT)
val remoteMinerdPath = SparkFiles.get(MINER)
```

Then prepares the cpu-miner arguments :
```scala
val scriptEnvMap: Map[String, String] = Utilities.parseArguments(args) + ("MINER_EXEC" -> remoteMinerdPath)
```

And finally uses the `pipe` transformation with the `count` action to launch the distributed mining :
```scala
sparkContext.emptyRDD[Int]
      .repartition(PARALLEL_MINERS)
      .pipe(remoteScriptPath, scriptEnvMap)
      .count()
```

The complete Spark job with instructions on how to build and tune the job are available on my Github : [https://github.com/marouni/spark-yarn-miner](https://github.com/marouni/spark-yarn-miner)

## Dogecoin meets Apache Spark !
_Now let's mine some Dogecoins with Apache Spark !_

I started by creating an account in the [Dogecoin Aika pool](https://aikapool.com/doge/index.php?page=login), which still supports CPU mining.
Then all I had to do was to launch my Spark job using `spark-submit` with the correct arguments :
```bash
spark-submit --master yarn
--class fr.marouni.spark.coins.SparkYarnMiner spark-yarn-miner.jar
--url stratum+tcp://stratum.aikapool.com:7915
--username 59427323640714255344
--worker-id worker0001
--password password
```

The complete argument list is available on the project's [Github page](https://github.com/marouni/spark-yarn-miner).
The job output shows the distributed miners starting to accept work from the pool :
```
[2018-01-02 21:41:38] 4 miner threads started, using 'scrypt' algorithm.
[2018-01-02 21:41:38] Starting Stratum on stratum+tcp://stratum.aikapool.com:7915
[2018-01-02 21:41:38] Binding thread 2 to cpu 2
[2018-01-02 21:41:38] Binding thread 1 to cpu 1
[2018-01-02 21:41:38] Binding thread 3 to cpu 3

[2018-01-02 21:41:39] Stratum requested work restart
[2018-01-02 21:41:44] thread 2: 4104 hashes, 15 khash/s
[2018-01-02 21:41:44] thread 0: 4104 hashes, 15 khash/s
[2018-01-02 21:41:44] thread 3: 4104 hashes, 15 khash/s
[2018-01-02 21:41:44] thread 1: 4104 hashes, 15 khash/s
```

Each mining worker will bind by default to all of the available threads, so some cluster tuning is required to achieve the best hash rate. Please to Spark tuning documentation of your chosen cluster.

In the above example I launched the distributed mining on Apache Yarn but I could have done the same on a Apache Mesos or even Kubernetes by changing `spark-submit` parameters without any job recompilation.

## References
* [1] : https://charts.bitcoin.com/chart/price
* [2] : https://blockchain.info/fr/stats
* [3] : https://coinmarketcap.com/
* [4] : https://coinmarketcap.com/all/views/all/
