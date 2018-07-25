# College-NoteTaker

An application that allows easier and more efficient note taking by:
- allowing ***speech to text*** for faster note-taking and ease in writing
- ability to add articles and fully interpret through ***sentiment analysis*** and ***subject classification***
- having a capability to ***summarize*** text for article and note summaries

Article Analysis for [this NYTimes article](https://www.nytimes.com/2018/07/14/world/europe/uk-trump-scotland-golf.html?action=click&module=TrendingGrid&region=TrendingTop&pgtype=collection):

<img src="SummaryOfArticle.png" width="300">

## Requirements

Xcode 10 and iOS 11

## Model

Scikit-Learn's [Pipeline](http://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html) was created using a [Dict Vectorizer](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.DictVectorizer.html) and a [Linear SVM](http://scikit-learn.org/stable/modules/generated/sklearn.svm.LinearSVC.html) and was then converted into the [CoreML Model](https://developer.apple.com/documentation/coreml) using the [coremltools](https://developer.apple.com/documentation/coreml/converting_trained_models_to_core_ml) python package. This classifier was used to distinguish between positive and negative phrases with the **best test score = 0.841726618705036** and was trained with the [Epinions](http://boston.lti.cs.cmu.edu/classes/95-865-K/HW/HW3/) set.

### Running and Converting the Model 

To run the model, python and pip should already be installed, inlcuding several other libraries such as:
- pandas: ```pip install --user pandas```
- numpy: ```pip install --user numpy```
- coremltools: ```pip install -U coremltools```
- nltk: ```pip install -U nltk```

Then, the following code can be run:
```
cd SentimentPolarity
python sentiment.py
```

### Features

- Best test score: 0.841726618705036
- Best CV score: 0.7884151246983105

## Summarizer

Created using the steps outlined by [DEV](https://dev.to/davidisrawi/build-a-quick-summarizer-with-python-and-nltk). The process involves using Apple's [Natural Language Framework](https://developer.apple.com/documentation/naturallanguage) to tokenize words, identify languages, and use tag schemes.

### Usage

To use the summarizer alone, copy ```summarizer.swift``` into your project. 

```
let summarizer = Summarizer()
let text = "Article's Text"
let summary = summarizer.summarize(text: text)
```
The variable ```summaryIntensity``` can be altered for favored summary length. 

### Example

This [NYTimes article](https://www.nytimes.com/2018/07/14/world/europe/uk-trump-scotland-golf.html?action=click&module=TrendingGrid&region=TrendingTop&pgtype=collection) is summarized as:

```
Trump’s preferred pastime — the president managed repeatedly to plug Turnberry, one of two Scottish resorts that bear his name, as he dealt with some of the most pressing diplomatic problems facing his administration to date.  It is a tactic that has alarmed ethics watchdogs, who say he is using his presidential platform to promote a resort that, according to financial filings, has been a burden on the family business.  He also plugged the Turnberry golf course again: “The weather is beautiful,” he wrote on Twitter, “and this place is incredible!” Ethics experts tend to be cynical about the president’s sentimental references to his resort.  Trump’s visits to properties owned, managed or branded by the Trump Organization amount to free publicity for the company and blur the line between his family business and presidential duties.  Trump appears to hold a special place in his heart for Turnberry, perhaps because of his love of golf and because his mother, Mary Anne MacLeod Trump, was born in Tong, a village some 300 miles from Turnberry, in the north of Scotland “I feel very comfortable here,” Mr.  Eisen said, “the president is forcing his foreign hosts and the United States to spend enormous amounts of money so that he can get free advertising for his resort.  politics politics New York business tech science sports obituaries today's paper corrections corrections opinion today's opinion today's opinion op-ed columnists editorials editorials contributing writers op-ed Contributors letters letters sunday review sunday review taking note video: opinion arts today's arts art & design books dance movies music television theater video: arts living automobiles automobiles crossword food food education fashion & style health jobs magazine real estate t magazine travel weddings listings & more Reader Center tools & services N.  politics politics New York business tech science sports obituaries today's paper corrections corrections opinion today's opinion today's opinion op-ed columnists editorials editorials contributing writers op-ed Contributors letters letters sunday review sunday review taking note video: opinion arts today's arts art & design books dance movies music television theater video: arts living automobiles automobiles crossword food food education fashion & style health jobs magazine real estate t magazine travel weddings more Reader Center tools & services.
```

## App Installation
```
git clone https://github.com/cocoa-ai/College-NoteTaker.git
cd College-NoteTaker
open College-NoteTaker.xcworkspace/
```
## Built With
- [Firebase](https://firebase.google.com/)
- [SiriKit](https://developer.apple.com/sirikit/)
- [CoreML Framework](https://developer.apple.com/documentation/coreml)
- [Scikit-Learn](http://scikit-learn.org/stable/)
- [SwiftSoup](https://github.com/scinfu/SwiftSoup)
- [DocumentClassifier](https://github.com/toddkramer/DocumentClassifier)

## Creators

[Vismita Uppalli](https://github.com/vuppalli)

## Note

The application can be useful in several settings such as real-time transciption of a professor, or reading a textbook out loud for studying purposes. Furthermore, the app can be used in meetings as a final summarizer for everything that was spoken.
