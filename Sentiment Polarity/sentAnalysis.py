import re
import coremltools
import pandas as pd
import numpy as np
from nltk.corpus import stopwords
from nltk import word_tokenize
from nltk.stem import WordNetLemmatizer
from nltk.stem.porter import *
from string import punctuation
from sklearn.feature_extraction import DictVectorizer
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import confusion_matrix
from sklearn import cross_validation

import nltk
nltk.download('stopwords')
nltk.download('punkt')

# Read reviews from CSV
reviews = pd.read_csv('movie-pang02.csv')
reviews = reviews.as_matrix()[:, :]

def lemTokens(tokens):
    lemmer = WordNetLemmatizer()
    return [WordNetLemmatizer().lemmatize(token) for token in tokens]

def stemTokens(tokens):
    stemmer = PorterStemmer()
    return [stemmer.stem(token) for token in tokens]

# Create features
def features(sentence):
    stop_words = stopwords.words('english') + list(punctuation)
    words = word_tokenize(sentence)
    words = lemTokens(words)
    #words = stemTokens(words)
    words = [w.lower() for w in words]
    filtered = [w for w in words if w not in stop_words and not w.isdigit()]
    words = {}
    for word in filtered:
        if word in words:
            words[word] += 1.0
        else:
            words[word] = 1.0
    return words

# Vectorize the features function
features = np.vectorize(features)

# Extract the features for the whole dataset
X = features(reviews[:, 1])
#print("X values (features): ", X)

# Set the targets
y = reviews[:, 0]
#print("Y values: ", y)

#Split data into training and testing
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y, test_size=0.1, random_state=0)

# Create grid search
clf = Pipeline([("dct", DictVectorizer()), ("svc", LinearSVC())])
params = {
    "svc__C": [1e15, 1e13, 1e11, 1e9, 1e7, 1e5, 1e3, 1e1, 1e-1, 1e-3, 1e-5]
}
gs = GridSearchCV(clf, params, cv=10, verbose=3, n_jobs=-1)
gs.fit(X_train, y_train)
model = gs.best_estimator_

# Print results
print (model.score(X_test, y_test))
#print ("Optimized parameters: ", model)
print ("Best CV score: ", gs.best_score_)

# Confusion matrix
y_pred = model.predict(X_test)
cm = confusion_matrix(y_test, y_pred)
print(cm)

# Convert to CoreML model
coreml_model = coremltools.converters.sklearn.convert(model)
coreml_model.author = 'USCG Smart Vessel Inspector Team'
coreml_model.short_description = 'Defiiciency Detector LinearSVC.'
coreml_model.input_description['input'] = 'Features extracted from the text.'
coreml_model.output_description['classLabel'] = 'The most likely polarity (positive or negative), for the given input.'
coreml_model.output_description['classProbability'] = 'The probabilities for each class label, for the given input.'
coreml_model.save('SentimentPolarityUSCGSmartApplicator.mlmodel')
