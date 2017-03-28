setwd("C:/Users/Corvo/Dropbox/Coursera/Data Science/Module 3/Week 4/UCI HAR Dataset")

library(reshape2)



# Load activity labels 
act.Labels <- read.table("activity_labels.txt")
act.Labels[,2] <- as.character(act.Labels[,2])

# Load activity features
act.features <- read.table("features.txt")
act.features[,2] <- as.character(act.features[,2])

# Extract mean and std. deviation
meanstd <- grep(".*mean.*|.*std.*", act.features[,2])
meanstd.names <- act.features[meanstd,2]
meanstd.names = gsub('-mean', 'Mean', meanstd.names)
meanstd.names = gsub('-std', 'Std', meanstd.names)
meanstd.names <- gsub('[-()]', '', meanstd.names)

# Create variables for files
#Test Data
part.raw_TestData <- read.table("subject_test.txt", header = FALSE)
act.raw_TestData <- read.table("y_test.txt", header = FALSE)
testset.raw_TestData <- read.table("x_test.txt", header = FALSE)
x1.testData <- cbind(part.raw_TestData, act.raw_TestData, testset.raw_TestData)

#Train Data
part.raw_TrainData <- read.table("subject_train.txt", header = FALSE)
act.raw_TrainData <- read.table("y_train.txt", header = FALSE)
trainset.raw_TrainData <- read.table("x_train.txt", header = FALSE)
x1.trainData <- cbind(part.raw_TrainData, act.raw_TrainData, trainset.raw_TrainData)

# Merge datasets and add labels
all.Data <- rbind(x1.testData, x1.trainData)
colnames(all.Data) <- c("subject", "activity", meanstd.names)

# Turn activities and subjects into factors
all.Data$activity <- factor(all.Data$activity, levels = act.Labels[,1], labels = act.Labels[,1])
all.Data$subject <- as.factor(all.Data$subject)

all.Data.melt <- melt(all.Data, id = c("subject", "activity"))
all.Data.mean <- dcast(all.Data.melt, subject + activity ~ variable, mean)

write.table(all.Data.mean, "dataSummary.txt", row.names = FALSE, quote = FALSE)

