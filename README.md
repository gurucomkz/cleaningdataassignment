# Getting and tydying means of gyroscope/accelerometer data

## Prerequisites

This script requires following packages to be available:

* dplyr
* data.table

Be advised that their respective dependencies must also be fulfilled.

## Input

Data source is assumed to be present in current working directory as a directory named "UCI HAR Dataset".

Source can be found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Output

Script produces file named result.txt which contains tidy data set with the average of each variable for each activity and each subject of experiment.

## Operations

Following operations are done upon the dataset

### Merge the training and the test sets into one data set

Directories "UCI HAR Dataset/test" and "UCI HAR Dataset/train" must contain files like

* "subject_(test|train).txt" - with subjects' ids map
* "X_(test|train).txt" - with measurements data
* "y_(test|train).txt" - with activities map

For test and train sets data was first cbinded in this order: Subjects, Activities, Data.
Then train dataset was appended to the test dataset to form a full data set which includes all available data.

Contents of "UCI HAR Dataset/features.txt" was used to name columns with measurements (all columns starting from 3rd).

After merging we remove source data used in merges so it does not consume memory.

### Extract only the measurements on the mean and standard deviation for each measurement.

After we got all the data together, we're discarding all measurement variables which names do not end with "mean" or "std" (which stand for average and standard deviation).

### Apply descriptive activity names to the activities in the data set.

Activity column transformed to factor with activity names as levels.

### Appropriately labels the data set with descriptive variable names.
All variable names representing measurements are cleaned from non-letter characters 
and expanded according to specs found in input data source to be more readable. Transformations are:

* Acc -> Accelerometer
* Gyro -> Gyroscope
* Mag -> Magnitude
* ^t -> time
* ^f -> frequency

### Create a tidy data set with the average of each variable for each activity and each subject.

From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject by following steps (some combined in chain):

* discard variables with standatd deviation measurements
* melt keeping Subject, Activity
    Here we get all the variables' names turned into column "variable" and their values corresponding 
    Subject and Activity are in "value" column
* group_by Subject, Activity, variable
* summarize "value" column with mean() function

The result is written into "result.txt" as table.