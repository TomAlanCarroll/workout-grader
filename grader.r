library(caret)
library(randomForest)

args <- commandArgs(TRUE)

trainingDataDir <- "sensor-data"
trainingFile <- paste(trainingDataDir, "training.csv", sep = "/")
testingFile <- paste(trainingDataDir, "testing.csv", sep = "/")
trainingFileUrl <- args[1]
testingFileUrl <- args[2]

# Number of columns expected in the CSV file
numColumns <- 160

# Cross validation ratio for training data
trainTestRatio <- 0.75

# Column to start training/testing. By default this skips columns 1..7
startColumn <- 8

if(length(args) < 2) {
	stop("Please supply training CSV URL as first command argument & testing CSV as second command argument.")
}

if (!file.exists(trainingDataDir)) {
	# Create sensor-data directory
	dir.create(trainingDataDir)
}

if (!file.exists(trainingFile) || !file.exists(testingFile)) {
	# Download training & testing data
	print(paste("Downloading training file:", trainingFileUrl))
	print(paste("Downloading testing file:", testingFileUrl))

	download.file(trainingFileUrl, destfile = trainingFile)
	download.file(testingFileUrl, destfile = testingFile)
}

if (dim(read.csv(trainingFile))[2] != numColumns || dim(read.csv(testingFile))[2] != numColumns) {
	stop(paste(numColumns, " columns must be present in training and testing CSV"))
}

# Load the files
trainingRaw <- read.csv(trainingFile, na.strings = c("NA", ""))
testingRaw <- read.csv(testingFile, na.strings = c("NA", ""))

# Remove empty columns
trainingEmpty <- apply(trainingRaw, 2, function(x) { sum(is.na(x)) })
trainingProcessed <- trainingRaw[,which(trainingEmpty == 0)]
trainingProcessed <- trainingProcessed[startColumn:length(trainingProcessed)]

testingEmpty <- apply(testingRaw, 2, function(x) { sum(is.na(x)) })
testingProcessed <- testingRaw[,which(testingEmpty == 0)]
testingProcessed <- testingProcessed[startColumn:length(testingProcessed)]

# Partition training set
trainingPartition <- createDataPartition(y = trainingProcessed$classe, p = trainTestRatio, list = FALSE)
training <- trainingProcessed[trainingPartition,]
testing <- trainingProcessed[-trainingPartition,]

# Train the model with randomForest, y = classe
model <- randomForest(classe ~ ., data = training)

# Time for cross validation...
crossValidationPrediction <- predict(model, testing)
confMatrix <- confusionMatrix(testing$classe, crossValidationPrediction)
print(paste("======== START CROSS VALIDATION ACCURACY ========"))
print(confMatrix)
print(paste("========  END CROSS VALIDATION ACCURACY  ========"))

# Time to test
prediction <- predict(model, testingProcessed)

# Output results
print(paste("========        START PREDICTIONS        ========"))
prediction
print(paste("========         END PREDICTIONS         ========"))