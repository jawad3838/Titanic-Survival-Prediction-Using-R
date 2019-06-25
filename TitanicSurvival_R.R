#UNCOMMENT AND RUN THE LINES BELOW IF YOU DON'T HAVE THESE PACKAGES
#install.packages('caret')
#install.packages('rpart')
#install.packages('rpart.plot')
#install.packages('rattle')
#install.packages('RColorBrewer')
#install.packages('e1071')
#install.packages('class')

#Import the necessary libraries
library(caret)
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)
library(e1071)
library(class)


#IMPORT THE NECESSARY DATA
train_data = read.csv("train.csv")
test_data = read.csv("test.csv")
validation_data = read.csv("gender_submission.csv")


print("*****USING DECISION TREES*****")
tc <- trainControl("cv",10)
rpart.grid <- expand.grid(.cp=0.2)

train = train_data
test = test_data

fit <- rpart(Survived ~ Pclass + Sex + SibSp + Parch + Age,
             method="class", data=train)

fancyRpartPlot(fit)

Prediction <- predict(fit, test, type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "Results/dtreeResults.csv", row.names = FALSE)

print("*****CONFUSION MATRIX USING DECISION TREES IS GIVEN BELOW*****")
results1 <- table(Prediction, validation_data$Survived)

print("*****ACCURACY USING DECISION TREES IS GIVEN BELOW*****")
confusionMatrix(results1)


print("*****USING NAIVE BAYES*****")

BayesTitanicModel<-naiveBayes(as.factor(Survived)~., train)

BayesPrediction<-predict(BayesTitanicModel, test)

summary(BayesPrediction)

output<-data.frame(test$PassengerId, BayesPrediction)

colnames(output)<-cbind("PassengerId","Survived")

write.csv(output, file = 'Results/NaiveBayesResults.csv', row.names = F)

print("*****CONFUSION MATRIX USING NAIVE BAYES IS GIVEN BELOW*****")
results2 <- table(BayesPrediction, validation_data$Survived)

print("*****ACCURACY USING NAIVE BAYES IS GIVEN BELOW*****")
confusionMatrix(results2)

print("*****USING K NEAREST NEIGHBOUR*****")

train <- train[,-c(4,9,11,12)]
test <- test[,-c(3,8,10,11)]

# Change Sex to 0 = male, 1 = female
train$Sex <- sapply(as.character(train$Sex), switch, 'male' = 0, 'female' = 1)
test$Sex <- sapply(as.character(test$Sex), switch, 'male' = 0, 'female' = 1)

train$Embarked[train$Embarked == ''] <- 'S'
train$Embarked <- sapply(as.character(train$Embarked), switch, 'C' = 0, 'Q' = 1, 'S' = 2)

test$Embarked <- sapply(as.character(test$Embarked), switch, 'C' = 0, 'Q' = 1, 'S' = 2)

#Removing NA Values
train_age <- na.omit(train$Age)
train_age_avg <- mean(train_age)
train$Age[is.na(train$Age)] <- train_age_avg

test_age <- na.omit(test$Age)
test_age_avg <- mean(test_age)
test$Age[is.na(test$Age)] <- test_age_avg

test_fare <- na.omit(test$Fare)
test_fare_avg <- mean(test_fare)
test$Fare[is.na(test$Fare)] <- test_fare_avg

# Change Age to 0 = Adult(>=18), 1 = Child(<18)
train$Age <- ifelse(train$Age<18, 1, 0)
test$Age <- ifelse(test$Age<18, 1, 0)

#Function to normalize the values
normalize <- function(x) {
  num <- x - min(x)
  denom <- max(x) - min(x)
  return (num/denom)
}

#Call Function to normalize values
train$Pclass = normalize(train$Pclass)
test$Pclass = normalize(test$Pclass)

test_length <- length(test$Fare)
fare <- normalize(c(train$Fare, test$Fare))
train$Fare <- fare[1:(length(fare)-test_length)]
test$Fare <- fare[(length(fare)-test_length + 1): length(fare)]

survived <- train$Survived
passengers <- test$PassengerId
train <- train[,-c(1,2,6,7,9)]
test <- test[,-c(1,5,6,8)]


knn_titanic <- knn(train, test, survived, k = 5,  l = 0, prob = FALSE, use.all = TRUE)
submission <- data.frame(PassengerId = passengers,Survived = knn_titanic)
write.csv(submission,'Results/KnnResults.csv')

print("*****CONFUSION MATRIX USING K NEAREST NEIGHBOUR IS GIVEN BELOW*****")
results3 <- table(submission$Survived, validation_data$Survived)

print("*****ACCURACY USING K NEAREST NEIGHBOUR IS GIVEN BELOW*****")
confusionMatrix(results3)
