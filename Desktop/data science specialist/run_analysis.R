#load library
library(tidyverse)
library(plyr)
#download data
if (!file.exists('dataset_zip')) {
  dataset_zip <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile = 'data/dataset.zip')
}

if (!file.exists('UCI HAR Datasest')) {
  unzip('dataset_zip')
}

#read in data
test_x <- read.table('data/UCI HAR Dataset/test/X_test.txt',header = FALSE)
test_y <- read.table('data/UCI HAR Dataset/test/y_test.txt',header = FALSE)
test_subject <- read.table('data/UCI HAR Dataset/test/subject_test.txt',header=FALSE)

train_x <- read.table('data/UCI HAR Dataset/train/X_train.txt',header = FALSE)
train_y <- read.table('data/UCI HAR Dataset/train/y_train.txt',header = FALSE)
train_subject <- read.table('data/UCI HAR Dataset/train/subject_train.txt',header=FALSE)

#rename columns of each dataset to make it more informative
colnames(test_y) <- 'activity'
colnames(test_subject) <- 'subject'
colnames(train_y) <- 'activity'
colnames(train_subject) <- 'subject'


#extract only the mean and std of each measurement
feature <- read.table('data/UCI HAR Dataset/features.txt',header = FALSE)
feature_selected <- grep('mean*|std*', as.character(feature[,2]))
test_x <- test_x[feature_selected]
train_x <- train_x[feature_selected]

#merge test lable and data
test <- cbind(test_subject,test_y,test_x)
train <- cbind(train_subject,train_y,train_x)

#merge training set and test set
total_set <- rbind(train,test)

#name the activity name
activity <- read.csv('data/UCI HAR Dataset/activity_labels.txt', sep=" ",header = FALSE)
total_set[,2] <- gsub('1',activity[1,2],total_set[,2])
total_set[,2] <- gsub('2',activity[2,2],total_set[,2])
total_set[,2] <- gsub('3',activity[3,2],total_set[,2])
total_set[,2] <- gsub('4',activity[4,2],total_set[,2])
total_set[,2] <- gsub('5',activity[5,2],total_set[,2])
total_set[,2] <- gsub('6',activity[6,2],total_set[,2])

#name the variables
feature_names <- feature[feature_selected,2]
feature_names <- gsub('[()]','',feature_names)
feature_names <- gsub('-','_',feature_names)
colnames(total_set)[3:81] <- feature_names

#average of each variable for each activity and each subject

#calculate the mean of each variable for each subject and activity combination

total_set$subject <- as.factor(total_set$subject)
total_set$activity <- as.factor(total_set$activity)
average_table <- ddply(total_set,.(subject,activity),function(x) colMeans(x[,3:81]))
write.table(average_table,'data/average_table.txt',row.names = FALSE)
average_table_review <- read.table('data/average_table.txt')
