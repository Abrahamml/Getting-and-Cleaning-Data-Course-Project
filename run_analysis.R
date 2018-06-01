library(dplyr)
##Dowload and Unzip data
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "HR Data.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

dataPath <- "HR Data"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

##Read Data and merge
xtrain <- read.table("HR Data/train/X_train.txt")
ytrain <- read.table("HR Data/train/y_train.txt")
subtrain <- read.table("HR Data/train/subject_train.txt")

xtest <- read.table("HR Data/test/X_test.txt")
ytest <- read.table("HR Data/test/y_test.txt")
subtest <- read.table("HR Data/test/subject_test.txt")

xdata<-rbind(xtrain,xtest)
ydata<-rbind(ytrain,ytest)
subdata<-rbind(subtrain,subtest)

## Measurements on the mean and standard deviation for each measurement.
features <- read.table("HR Data/features.txt")
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])
xdata <- xdata[, mean_and_std]
names(xdata) <- features[mean_and_std, 2]

## Names to name the activities in the data set
activities <- read.table("HR Data/activity_labels.txt")
ydata[, 1] <- activities[ydata[, 1], 2]
names(ydata) <- "activity"

## Appropriately label the data set with descriptive variable names
names(subdata) <- "subject"
all_data <- cbind(xdata, ydata, subdata)

##creates a second, independent tidy data set with the average of each variable for each activity and each subject.
averages_data <- daply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE
