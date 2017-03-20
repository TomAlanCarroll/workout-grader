# Workout Grader
Given the recent advances in wearable technologies, there exists a new opportunity to monitor and give feedback to athletes needing optimized training sessions. These new wave of devices provide the possibility to give personalized feedback during and after the athlete's workout. Most people are interested in how *much* of a particular activity they do, but athlete's care more about *how well they do it* for optimal training. In this project, the data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants is used to grade the quality of the workout form. The participants were asked to perform barbell lifts correctly and incorrectly in 5 different ways. These are broken down into 5 classes, with **A** being ideal:
- **A** = Exactly according to the specification
- *B* = Throwing the elbows to the front
- *C* = Lifting the dumbbell only halfway
- *D* = Lowering the dumbbell only halfway
- *E* = Throwing the hips to the front

More information around the training set can be found here:
[http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har#related_papers).

## Model Algorithm
The model for this project was built using R's `randomForest` package. I made the decision to use Random Forests because they are flexible and quick to train. The model is built by:
```r
# Partition training set
trainingPartition <- createDataPartition(y = trainingProcessed$classe, p = trainTestRatio, list = FALSE)
training <- trainingProcessed[trainingPartition,]
testing <- trainingProcessed[-trainingPartition,]

# Train the model with randomForest, y = classe
model <- randomForest(classe ~ ., data = training)
```

## Cross Validation
A cross validation strategy is used to estimate how accurately the predictive model will perform with live data. 75% of the training data is partitioned to train the model, with the remaining 25% used to estimate the efficacy. This is validated by:
```r
crossValidationPrediction <- predict(model, testing)
confMatrix <- confusionMatrix(testing$classe, crossValidationPrediction)
```

I estimated a very low out of sample rate of <1% because the collection of the training data was in a highly regulated environment, with the participants being instructed on how to perform the exercises. In the future, additional training environments would need better modeling strategies. In a few measurements, the cross validation accuracy was very high (99.5 - 100%), so the model was ready for testing. After running cross validation, the out of sample rate was approximately 0.5%.

## Predictions
The trained model is used to predict the quality of the workout form, either **A** or  *B to E*. This is predicted by:
```r
prediction <- predict(model, testingProcessed)
```

From this the athlete can determine workout deficiencies and work to perfect defects in the future.

## Running workout-grader
### R packages
```r
install.packages("caret")
install.packages("randomForest")
install.packages("corrplot")
```
### How to execute
```bash
Rscript grader.r [training-CSV-URL] [testing-CSV-URL]

# with example files:
Rscript grader.r "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv" "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
```