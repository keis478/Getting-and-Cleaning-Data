## download data sets
## use read.table to read csv files
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

## identifier
subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

library(dplyr)
# 1. Combine the training and test data sets
data <- rbind(X_train, X_test)
subject <- rbind(subject_train, subject_test)
activity <- rbind(y_train, y_test)

## 2. extract only the measurements on the mean and standard deviation
## extract the numbers of labels
features <- read.table("features.txt")
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$V2)
data <- data[, mean_std_features]

## 3. use descriptive activity
activity_labels <- read.table("activity_labels.txt")

## replace numbers with activity names
activity[,1] <- activity_labels[activity[,1],2]

data <- cbind(subject, activity, data)
names(data)[1:2] <- c("Subject", "Activity")

## 4. apply descriptive variable names
names(data)[3:length(mean_std_features)] <- features[mean_std_features,2]

## 5. create tidy data set with averages for each activity and subject
tidy_data <- data %<%
  group_by(Subject, Activity) %<%
  summarise(across(everything(), mean))

# Write the tidy data to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
