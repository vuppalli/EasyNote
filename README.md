# College-NoteTaker

An application that allows easier and more efficient note taking by:
- allowing speech to text for faster note-taking and ease in writing
- ability to add articles and fully interpret through sentiment analysis and subject classification
- having a capability to summarize text for article and note summaries

Article Summary for [this NYTimes article](https://www.nytimes.com/2018/07/14/world/europe/uk-trump-scotland-golf.html?action=click&module=TrendingGrid&region=TrendingTop&pgtype=collection):

<img src="SummaryOfArticle.png" width="300">

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

### Usage

## Requirements

Xcode 10 and iOS 11

## Installation
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
