---
layout: post
title:  "Poor Man's Technology Hype Cycles"
date:   2022-02-21 11:34:12
comments: true
---

I recently stumbled upon [Gartner’s Hype Cycle Builder](https://www.gartner.com/en/documents/3992821/create-your-own-hype-cycle-with-gartner-s-hype-cycle-bui), which simply put allows you to build custom Gartner's hype cycle graphs for a given technology innovation or architecture. Unfortunately, it's only available for paying clients :dollar:

#### Poor Man's Gartner’s Hype Cycle Builder !
*So I set out to build a poor man's version of it and see if all technology trends follow this hype cycle.*

<br/>
Before moving, here's what Wikipedia has to say about Gartner Hype Cycle (it's fairly straight forward) :

> The Gartner hype cycle is a graphical presentation developed, used and branded by the American research, advisory and information technology firm Gartner to represent the maturity, adoption, and social application of specific technologies. 

<br/>
![Gartner Hype Cycle](/images/posts/hype/gartner_hype.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

#### Trend Data

Here again we'll have to improvise !
<br/>
<br/>
As we don't have access to Gartner's trend database, we will rely on [Google Trends](https://trends.google.com/trends) to find the trend curve for a given keyword. Google Trends defines interest over time as the following :

> Numbers represent search interest relative to the highest point on the chart for the given region and time. A value of 100 is the peak popularity for the term. A value of 50 means that the term is half as popular. A score of 0 means there was not enough data for this term.

#### Hype Cycle over Google Trends

Now to the fun part !
<br/>
<br/>
First we'll get the Google Trends graph for a given keyword, then we'll plot a hype cycle over it as best as we can. We'll try to generate the hype cycle by smoothing out the Google Trends graph and then try to interpret the smoothed graph as the hype cycle.
<br/>
<br/>
This method is by no means an accurate measure of hype, but it's accurate enough for our case. In addition to this I'm going to use the following assumptions :
* Sharp increase in graph's slope => more search/interest => **Technology Trigger**
* Sharp decrease in graph's slope following a sharp increase => interest quickly dwindling => **Peak of Inflated Expectations** and **Trough of Disillusionment**
* Smooth increase after local bottom => renewed serious interest => **Slope of Enlightenment**
* Stable and slightly decreasing slope => stable interest and more serious usage => **Plateau of Productivity**

## Hype Cycles

Each of the following illustrations is an attempt to draw a hype curve over Google Trends data for a given technology. The hype curve (red curve) is just the moving average of the Google Trends curve.

### Microservices hype cycle / 2004-2022
_Microservices getting to maturity_
![Microservices Hype Cycle](/images/posts/hype/ms_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Docker hype cycle / 2004-2022
_The dip in 2021 is probably related to Docker moving to paid/limited model_
![Docker Hype Cycle](/images/posts/hype/docker_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Hadoop hype cycle / 2004-2022
_Hadoop's deep dive is not over yet !_
![Hadoop Hype Cycle](/images/posts/hype/hadoop_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Big Data hype cycle / 2004-2022
_There's still some momentum behind Big Data_
![Big Data Hype Cycle](/images/posts/hype/bd_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Kubernetes hype cycle / 2004-2022
_Very tight gap between the peak and the first local bottom, we'll see how the trend moves as Kubernetes matures ... or not_
![Kubernetes Hype Cycle](/images/posts/hype/k8s_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Internet of Things (IoT) hype cycle / 2004-2022
_IoT is on its way for a stable and productive trend_
![IoT Hype Cycle](/images/posts/hype/iot_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Artificial Intelligence (AI) hype cycle / 2004-2022
_hummm..._ :thinking:
![AI Hype Cycle](/images/posts/hype/ai_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Blockchain hype cycle / 2004-2022
_It really just follows Bitcoin price curve!!_
![Blockchain Hype Cycle](/images/posts/hype/blockchain_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Web X.0 hype cycle / 2004-2022
_To understand Web 3.0 we should look at Web 2.0 trend and the confusion around Web 3.0 that it created when it first came out ..._
#### Web 3.0 hype cycle / 2004-2022
![Web X.0 Hype Cycle](/images/posts/hype/web3_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
#### Web 2.0 hype cycle / 2004-2022
![Web X.0 Hype Cycle](/images/posts/hype/web2_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### NFT hype cycle / 2004-2022
:see_no_evil: :thinking:
![NFT Hype Cycle](/images/posts/hype/nft_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

### Rust Programming Language hype cycle / 2004-2022
_Some jitter in last couple of years but it's still on an upward trend_
![Rust Hype Cycle](/images/posts/hype/rust_render.png){:style="display:block; margin-left:auto; margin-right:auto"}
<br/>

## Wanna generate your own Hype Cycles ?!
Head over to https://github.com/marouni/google_trends_hype_generator and clone the Python Notebook.