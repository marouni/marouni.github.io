---
layout: post
title:  "Battle of the AIs: Which Model Delivers the Best Value for Financial Insights?"
date:   2024-08-31 11:59:11
comments: true
---

In the rapidly evolving world of AI, finding the right model for financial analysis can make or break your investment strategy. I put several top models to the test, comparing their performance and cost-effectiveness to see which one truly delivers the best value.
<br/>
<br/>
This benchmark aims to evaluate various AI models' ability to interpret and analyze financial news in the context of a specific investment portfolio.
<br/>
<br/>
Each model was asked to analyze a financial news snippet given a very simple investment portfolio, the models then provided insights on how these developments might affect the portfolio.

## Financial News Snippet
> WTI crude oil futures fell more than 2.5% below $75 per barrel on Monday, continuing a 1.9% decline from the previous session amid ongoing cease-fire talks in Gaza and concerns about weakening demand, particularly from China. This push for peace could ease geopolitical tensions, reducing the risk premium on oil. Additionally, China's recent economic data has been disappointing, with slowing growth, falling home prices, and rising unemployment. This has led Chinese refineries to cut back on crude processing, further dampening demand. Last week, both OPEC and the IEA lowered their global oil demand growth forecasts for 2024, citing weaker-than-expected data and declining demand from China, which is adding pressure to the oil market.


## Portfolio
* **US : Long**
* **Europe : Long**
* **Oil and Fossil Fuels : Short**

## Expected Analysis
If we had conducted the analysis ourselves, we would expect a detailed and nuanced evaluation of how the declining oil prices would impact the portfolio. Specifically, we would consider:
* Since the portfolio holds a short position in oil and fossil fuels, **falling oil prices would likely lead to gains.**
* We would also consider how the decline in oil prices might influence other aspects of the portfolio, particularly the long positions in U.S. and European markets.
* Additionally, we would factor in the broader economic environment, such as how weakening demand from China.

## Performance
### Budget Models
#### OpenAI GPT 4o Mini (gpt-4o-mini)
Pricing :
* $0.150 / 1M input tokens
* $0.600 / 1M output tokens

> The significant decline in oil prices, driven by geopolitical factors and disappointing economic data from China, suggests a strong negative impact on the portfolio, particularly given the short position in oil and fossil fuels, which could lead to increased losses.

❌ Wrong analysis, the model doesn't understand the concept of a short position.

---

#### Claude Haiku (claude-3-haiku-20240307)
Pricing :
* $0.250 / 1M input tokens
* $1.250 / 1M output tokens

> The article suggests that the decline in oil prices and weakening global oil demand, especially from China, could have a significant positive impact on the investment portfolio. The portfolio has a short position in oil and fossil fuels, which would benefit from the falling oil prices. 
Additionally, the portfolio's exposure to global markets and equities, such as the S&P 500, European markets, and major tech companies, could also benefit from the reduced geopolitical tensions and weakening demand, as it may lead to improved economic conditions and market performance.

✅ Spot-on analysis, both short and long term impacts are correctly figured out.

---

#### Google Gemini Flash (gemini-1.5-flash-001)
Pricing (Prompts up to 128k tokens) :
* $0.075 / 1M input tokens
* $0.300 / 1M output tokens

> The article mentions falling oil prices, which is likely to negatively impact the portfolio due to its short position in oil and fossil fuels. The article also highlights weakening demand, which could negatively affect the portfolio's holdings in energy-related sectors.

❌ Wrong analysis, the model doesn't understand the concept of a short position.

---

#### Mistral Nemo (open-mistral-nemo-2407)
Pricing :
* $0.300 / 1M input tokens
* $0.300 / 1M output tokens

> The significant drop in oil prices, coupled with reduced demand growth forecasts, will negatively impact the portfolio's short position in oil and fossil fuels, potentially leading to substantial losses. This could also have a spillover effect on other energy-related positions.

❌ Wrong analysis, the model doesn't understand the concept of a short position.

---

### Flagship Models
#### OpenAI GPT 4o (gpt-4o)
Pricing :
* $5.00 / 1M input tokens
* $15.00 / 1M output tokens

> The decline in oil prices is beneficial for the portfolio's short position in oil and fossil fuels, which is a significant component. Additionally, lower oil prices can positively impact companies like Apple, Microsoft, and Costco by reducing operational costs. The overall impact is significant due to the substantial short position in oil and the broad positive effects on major holdings.

🟠 Correctly identifying the positive impact of falling oil prices but with slightly less detailed analysis.

---

#### Claude Sonnet (claude-3-5-sonnet-20240620)
Pricing :
* $3.00 / 1M input tokens
* $15.00 / 1M output tokens

> The significant drop in oil prices is beneficial for the portfolio, which has a short position in oil and fossil fuels. The decline is driven by multiple factors including potential easing of geopolitical tensions and weakening demand, particularly from China. This aligns well with the portfolio's strategy and could lead to gains on the short position. However, the impact is moderated by the potential negative effects on other sectors and the overall market, which make up a larger portion of the portfolio.


✅ The most accurate and nuanced analysis.

---

#### Google Gemini Pro (gemini-1.5-pro-001)
Pricing (Prompts up to 128k tokens) :
* $3.50 / 1M input tokens
* $10.50 / 1M output tokens

> The article describes a decline in oil prices driven by both supply and demand factors.  Increased supply due to easing geopolitical tensions and reduced demand from China contribute to a bearish outlook on oil. The portfolio holds a short position in oil and fossil fuels, suggesting a potential moderate positive impact.


🟠 Correctly identifying the positive impact of falling oil prices but with slightly less detailed analysis.

---

#### Mistral Large (mistral-large-2407)
Pricing :
* $3.00 / 1M input tokens
* $9.00 / 1M output tokens

> The decline in oil prices and reduced global demand forecasts are positive for the portfolio, which has a short position in oil and fossil fuels, potentially leading to gains in this segment.


🟠 Good analysis, correctly aligning with the portfolio's strategy, but its insights were more general compared to the others.

---

# Models Recap
## Budget Models

| Model | Price   | Performance |
|:----------------|:-------------------|:---------------|
| Claude Haiku        | 💲💲   | 🟢🟢🟢        |
| GPT 4o Mini        | 💲💲 | 🔴         |
| Google Gemini Flash     | 💲 | 🔴        |
| Mistral Nemo     | 💲💲 | 🔴        |

🏆 **Claude Haiku** offers the best combination of price and performance.

## Flagship Models

| Model | Price   | Performance |
|:-----------------|:-------------------|:---------------|
| Claude Sonnet        | 💲💲   | 🟢🟢🟢  
| GPT 4o        | 💲💲 | 🟢🟢         |      |
| Google Gemini Pro     | 💲💲 | 🟢🟢        |
| Mistral Large     | 💲 | 🟢        |

🏆 **Claude Sonnet** provides the most detailed and accurate analysis, making it the best choice despite its higher cost.