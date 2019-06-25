# Titanic-Survival-Prediction-Using-R
Predicting the survival of passengers on RMS Titanic using information about the passengers.

## Pre-requisites
You need the following libraries in RStudio or any IDE of your choice:
* caret
* rpart
* rattle
* RColorBrewer
* e1071
* class

## About the Dataset
The titanic survival dataset that is available on Kaggle has the following attributes:

* Survival: 0 = No, 1 = Yes 
* pclass (Ticket class):  1 = 1st, 2 = 2nd, 3 = 3rd 
* Sex:  male and female
* Age: In years 
* sibsp: # of siblings / spouses aboard the Titanic 
* parch: # of parents / children aboard the Titanic 
* ticket: Ticket number 
* fare: Passenger fare 
* cabin: Cabin number 
* embarked (Port of Embarkation): C = Cherbourg, Q = Queenstown, S = Southampton

The dataset is already split into training and testing sets. The Survival attribute is not present in the test test instead it is present in another file which is labelled gender_submission.

## Different Models Used
3 different models were used to predict the survival of passengers on the RMS Titanic. The performance of each of these models is shown below via confusion matrix

* Decision Tree

The generated tree using "fancyRpartPlot" is shown below:

![](https://github.com/jawad3838/Titanic-Survival-Prediction-Using-R/blob/master/screenshots/DecisionTree.PNG)

![Confusion Matrix](https://github.com/jawad3838/Titanic-Survival-Prediction-Using-R/blob/master/screenshots/CM_DecisionTree.PNG)


* Naive Bayes

![Confusion Matrix](https://github.com/jawad3838/Titanic-Survival-Prediction-Using-R/blob/master/screenshots/CM_NaiveBayes.PNG)


* Knn Classifier

![Confusion Matrix](https://github.com/jawad3838/Titanic-Survival-Prediction-Using-R/blob/master/screenshots/CM_knn.PNG)
