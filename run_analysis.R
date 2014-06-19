##
##  https://github.com/digitallance/getdata-course-project
##

setwd("/Users/raf/Documents/Courses/Data Science Specialization/3. Getting and Cleaning Data/PAs/getdata-course-project")

## download and unzip the data
#url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#zipfile="./UCI_HAR_Dataset.zip"
#download.file(url, destfile=zipfile, method="curl")
#unzip(zipfile)


## 1. Merges the training and the test sets to create one data set.

# load data
test.dir <- "./UCI HAR Dataset/test"
train.dir <- "./UCI HAR Dataset/train"
# merge subject id files (subject_[train|test].txt)
subject_train.file <- paste(train.dir, "subject_train.txt", sep="/")
subject_test.file <- paste(test.dir, "subject_test.txt", sep="/")
subject_merge.file <- "./subject_merge.txt"
data.subject_train <- read.table(subject_train.file, header=FALSE, sep="")
data.subject_test <- read.table(subject_test.file, header=FALSE, sep="")
data.subject_merge <- rbind(data.subject_train, data.subject_test)
# merge training label files (y_[train|test].txt)
y_train.file <- paste(train.dir, "y_train.txt", sep="/")
y_test.file <- paste(test.dir, "y_test.txt", sep="/")
y_merge.file <- "./y_merge.txt"
data.y_train <- read.table(y_train.file, header=FALSE, sep="")
data.y_test <- read.table(y_test.file, header=FALSE, sep="")
data.y_merge <- rbind(data.y_train, data.y_test)
# merge training data files (X_[train|test].txt)
X_train.file <- paste(train.dir, "X_train.txt", sep="/")
X_test.file <- paste(test.dir, "X_test.txt", sep="/")
X_merge.file <- "./X_merge.txt"
data.X_train <- read.table(X_train.file, header=FALSE, sep="")
data.X_test <- read.table(X_test.file, header=FALSE, sep="")
data.X_merge <- rbind(data.X_train, data.X_test)

## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement. 

# read feature descriptions
feature.file <- "./UCI HAR Dataset/features.txt"
data.features <- read.table(feature.file, header=FALSE, sep=" ")
# set up regular expression patterns to identify features that are
# means or standard deviations
p1 <- "-mean\\(\\)"
p2 <- "-std\\(\\)"
# create logical vectors for features of means and standard deviations
features.of.mean <- grepl(p1, data.features[,2], perl=TRUE)
features.of.std <- grepl(p2, data.features[,2], perl=TRUE)
# combine both into one logical vector representing the columns
# of the data for measurements on the mean and standard deviation
features.of.mean.or.std <- features.of.mean | features.of.std
# create new data table based on mean and standard deviation features
data.X_merge.mean_and_std <- data.X_merge[,features.of.mean.or.std]

## 3. Uses descriptive activity names to name the activities in the data set

# rename subjects vector
names(data.subject_merge) <- "Subject"

# read in activity names
activity.file <- "./UCI HAR Dataset/activity_labels.txt"
data.activity <- read.table(activity.file, header=FALSE, sep="", 
                            stringsAsFactors=FALSE)
# convert numerical activity ids into descriptive text
data.y_merge.activity <- data.activity[data.y_merge[,],2]

# convert names of data columns to measurement descriptions
feature.names <- data.features[,2][features.of.mean.or.std]
names(data.X_merge.mean_and_std) <- feature.names

## 4. Appropriately labels the data set with descriptive variable names. 

# merge complete data into one table (subject ids, activity and measurements)
data.full_merge <- cbind(data.subject_merge, 
                         data.y_merge.activity, 
                         data.X_merge.mean_and_std)
# fix name of activity column
temp.names <- names(data.full_merge)
temp.names[2] <- "Activity"
names(data.full_merge) <- temp.names

row.order <- order(data.full_merge$Subject, data.full_merge$Activity)
data.full_merge.sorted <- data.full_merge[row.order,]

## 5. Creates a second, independent tidy data set with the average of each 
##    variable for each activity and each subject. 

# set up factors for averaging data
f.Subject <- factor(data.full_merge.sorted$Subject)
f.Activity <- factor(data.full_merge.sorted$Activity)
# total number of colums in data frame
n.cols <- dim(data.full_merge.sorted)[2]
# create tidy dataset with measurement averages for each subject and activity
data.tidy <- aggregate(data.full_merge.sorted[,3:n.cols], 
                       list(f.Subject,f.Activity), mean)
# fix column names
names(data.tidy)[1] <- "Subject"
names(data.tidy)[2] <- "Activity"
# examine new dataset
str(data.tidy)
# export dataset to a file
write.csv(data.tidy, file="./HAR_data_tidy.csv", row.names=FALSE)

# test reading back the data
test <- read.csv(file="./HAR_data_tidy.csv")
