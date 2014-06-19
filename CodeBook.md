# Getting and Cleaning Data

### Course Project Code Boook

The code book describes the data, variables, transformations and work performed to clean up the data and produce a tidy dataset.

The file "run_analysis.R" performs all steps of downloading, cleaning and transformin of the data.

## Data description

Human Activity Recognition Using Smartphones Data Set described 
[here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#### Original data files location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Dataset was downloaded and unzipped to working directory producing a directory "UCI HAR Dataset" with separate trainint and test data directories. 

## Variables

The data is distributed across multiple files with mapping between 30 "subjects", 6 "activities" and 561 "measurements" obtained during each activity for each subject.

## Transformations

The training data consists of 21 subjects with a total of 7352 measurement rows, while the test data had 9 subjects and 2947 measurement rows. A merged dataset was created by combining the different data files into a single "merged" table including subject ids, activity names and a subset of measurements consisting only of mean and standard deviation measurements. The colums were filtered by applyng a regular expression filter on measurement column names. This retained 66 individual measurements form the original 561.

The activity ids were replaced with descriptive activity names in the "Activity" column. All column names reflect the measurement type or row attribute such as subject id or activity type. This represents a merged dataset for 30 subjects, 6 activiy types and 10299 measurement rows. The rows were sorted on subject id and activity type.

## Tidy dataset generation

A tidy dataset with measurement averages for each subject and activity was created by aggregating means for each measurement column for each subject and activity type. This dataset consisted of 180 rows of 66 measurements for all 30 subjects and 6 activity types:

* LAYING
* SITTING
* STANDING
* WALKING
* WALKING_DOWNSTAIRS
* WALKING_UPSTAIRS

A CSV file ("HAR_data_tidy.csv") was created to archive the dataset.



