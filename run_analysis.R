# set working directory
setwd("C:/Users/fergusond/Dropbox/R/GCD")
getwd()

# download and unzip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipped <- file.path(getwd(), "getdata-projectfiles-UCI HAR Dataset.zip")
download.file(url, zipped)
unzip(zipped)
setwd("C:/Users/fergusond/Dropbox/R/GCD/UCI HAR Dataset")
getwd()

# read train data
features <- read.table("features.txt", header = FALSE)
activity_labels <- read.table("activity_labels.txt", header = FALSE)
X_train <- read.table("./train/X_train.txt", header = FALSE)
y_train <- read.table("./train/y_train.txt", header = FALSE)
subject_train <- read.table("./train/subject_train.txt", header = FALSE)

# add colnames 
colnames(X_train) <- features[, 2]
colnames(y_train) <- c("activityID")
colnames(activity_labels) <- c("activityID", "activity")
colnames(subject_train) <- c("subjectID")

# combine data
train <- cbind(y_train, subject_train, X_train)

# read test data
X_test <- read.table("./test/X_test.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE)
subject_test <- read.table("./test/subject_test.txt", header = FALSE)

# add column names
colnames(X_test) <- features[,2]
colnames(y_test) <- c("activityID")
colnames(subject_test) <- c("subjectID")

# combine the y_test, subject_test and X_test data
test <- cbind(y_test, subject_test, X_test)

# combine the train and test
alldata <- rbind(train, test)

# get mean and standard deviation 
pattern <- grepl("activityID", colnames(alldata)) | grepl("subjectID", colnames(alldata)) | grepl("mean", colnames(alldata)) | grepl("std", colnames(alldata))
alldata <- alldata[, pattern]

# name data 
alldata <- merge(alldata, activity_labels, by="activityID")

# create tidy data 
buffer <- alldata[, names(alldata) != "activityLabel"]
tidy <-  aggregate(buffer[, names(buffer) != c("activityID", "subjectID")], by = list(activityID = buffer$activityID, subjectID = buffer$subjectID), mean)

# add activity label
tidy <- merge(tidy, activity_labels, by = "activityID")

View(tidy)
