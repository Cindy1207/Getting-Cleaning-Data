# This R script does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

#### 1
# a. Download and unzip the dataset
if (!file.exists("data")) dir.create("data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/zipfile.zip")
unzip("./data/zipfile.zip",exdir = "data")

setwd("~/R/Getting&Cleaning Data/Week4/Assignment/data")

# b. Load the test and the training datasets
X_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
# Load the test datasets
X_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

# c. Create the datasets
merged.X <- rbind(X_train,X_test)
merged.y <- rbind(y_train,y_test)
merged.subject <- rbind(subject_train,subject_test)
all.merged <- cbind(merged.subject, merged.y, merged.X)


#### 2
# First read the features.txt file, the second column with the measurement names
# and set those names into merged.X
# Then extract only the mean and standard deviation for each measurement, 
# given the dataset merged.X.
features <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE) [2] 
names(merged.X) <- features[,1]
merged.X <- merged.X[grepl("std|mean", names(merged.X), ignore.case = TRUE)] 
all.merged_1 <- cbind(merged.subject, merged.y, merged.X)


#### 3 
# Use descriptive activity names to name the activities in the data set
# Read the ActivityLabels vector and take the second column as a character
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
activities <- as.character(activities[,2])
merged.y$V1 <- activities[merged.y$V1]
all.merged_2 <- cbind(merged.subject, merged.y, merged.X)


#### 4
# Appropriately label the data set with descriptive variable names.
names(all.merged_2) [1:2] <- c("Id","Activity")


#### 5
#  From the data set in step 4, create a second, independent tidy set 
#  with the average of each variable for each activity and each subject.
library(dplyr)
tidy <- group_by(all.merged_2,Id,Activity) %>%
summarise_each(funs(mean))
write.table(tidy,file = "tidy_dataset.txt",row.names = FALSE,quote = FALSE)







