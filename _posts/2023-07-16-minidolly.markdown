---
layout: post
title:  "Mini-Dolly: Unlocking the Potential of a Smaller LLM Model"
date:   2023-07-16 13:02:08
comments: true
---

Today, we're diving into the fascinating world of Mini-Dolly. We all know how incredible LLM models are, but their massive size can be a bit of a downer – requiring tons of resources and storage space.

<br/>
That's where Mini-Dolly comes to the rescue! It's a nifty experiment that's all about getting the best of both worlds – top-notch performance without taking up your whole hard drive.

## Mini-Dolly

<br/>
Mini-Dolly is inspired by [Databricks Dolly](https://www.databricks.com/blog/2023/04/12/dolly-first-open-commercially-viable-instruction-tuned-llm) model and the incredible open source [databricks-dolly-15k](https://huggingface.co/datasets/databricks/databricks-dolly-15k) that contains 15,000 high-quality human-generated prompt / response pairs specifically designed for instruction tuning large language models. The training was done on recent Dell PC with 32G of RAM with a core i7 CPU, it took *only* around **12 hours !**

<br/>
The most noticeable difference is the attempt to use a smaller base model :nerd_face: !

<br/>
```
|databricks/dolly-v2-12b   |EleutherAI/pythia-12b    |11,327,027,200   |23.8 GB   |
|databricks/dolly-v2-7b    |EleutherAI/pythia-6.9b   |6,444,163,072    |13.8 GB   |
|databricks/dolly-v2-3b    |EleutherAI/pythia-2.8b   |2,517,652,480    |5.68 GB   |
|marouni/miniDolly         |EleutherAI/pythia-70m    |18,915,328       |307 MB    |
```
The model is 10 times lighter than the smallest dolly model ! But that comes at a cost as we'll see in the next section.


## Performance

As expected the model performance is very bad ! Especially when compared to [Databricks dolly v2 12b model](https://huggingface.co/databricks/dolly-v2-12b).

<br/>
When prompted with `What is the capital of France ?` the model answers with :

```
"The World". It is an artwork for "working time" called «The Middle East Today". It comes from Paris, Belgium, in local variation, including large cities as described in English language photographs which portray a crescent and sunrise of late note, Bangourt before Paris.
“Countries like Pakistan and throughout East Africa close to Australia have constructed a watered havock which can be felt ever longer. Bombardment and booby traps tend to occupy space by wind and water, as were effectively used for material and equipment which have a green signal leading in the images."
```

Compared with the following asnwer from [Databricks dolly v2 3b model](https://huggingface.co/databricks/dolly-v2-12b)
```
The capital of France is Paris.
```

## Small LLMs are the future ?!
In conclusion, the small LLM may have limited performance, but its compact size offers significant advantages. Its efficiency allows it to function on low-power devices and reduces training times. It democratizes AI adoption, making AI accessible to a broader audience. While larger models dominate headlines, the small LLM's potential for specific applications cannot be overlooked.


## How to play with the model ?
Get it on HuggingFace : [miniDolly](https://huggingface.co/marouni/miniDolly)

<br/>
:robot: : _Some parts of this blogpost were generated with OpenAI ChatGPT !_