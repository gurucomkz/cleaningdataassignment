library(dplyr)
library(data.table)

features <- (read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F))$V2
activityLabels <- (read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F))$V2

fullDataTitles <- make.names(names=c("Subject","Activity", features), unique=TRUE, allow_ = TRUE)

testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testData <- read.table("UCI HAR Dataset/test/X_test.txt")

trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")

# Merge the training and the test sets to create one data set.

mergedTest <- cbind(testSubjects, testActivities, testData)
    #cleanup
    rm("testData")
    rm("testSubjects")
    rm("testActivities")

mergedTrain <- cbind(trainSubjects, trainActivities, trainData)
    #cleanup
    rm("trainData")
    rm("trainSubjects")
    rm("trainActivities")

mergedData <- tbl_df(rbind(mergedTest, mergedTrain))
    #cleanup
    rm("mergedTest")
    rm("mergedTrain")

names(mergedData) <- fullDataTitles

# Extracts only the measurements on the mean and standard deviation for each measurement.
onlyMeanNStd <- select(mergedData, Subject, Activity, grep("\\.(mean|std)\\.\\.$",names(mergedData)))
rm("mergedData")

# Uses descriptive activity names to name the activities in the data set
onlyMeanNStd$Activity <- as.factor(onlyMeanNStd$Activity)
levels(onlyMeanNStd$Activity) <- activityLabels

# Appropriately label the data set with descriptive variable names.
names(onlyMeanNStd) <- gsub("\\.\\.","",names(onlyMeanNStd))
names(onlyMeanNStd) <- gsub("Acc","Accelerometer",names(onlyMeanNStd))
names(onlyMeanNStd) <- gsub("Gyro","Gyroscope",names(onlyMeanNStd))
names(onlyMeanNStd) <- gsub("Mag","Magnitude",names(onlyMeanNStd))
names(onlyMeanNStd) <- gsub("^t","time",names(onlyMeanNStd))
names(onlyMeanNStd) <- gsub("^f","frequency",names(onlyMeanNStd))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
onlyMean <- select(onlyMeanNStd, Subject, Activity, grep("mean$",names(onlyMeanNStd)))
names(onlyMean) <- gsub("\\.mean","",names(onlyMean))

meltedGsum <- melt(onlyMean, 
                   id.vars=c("Subject","Activity"), 
                   measure.vars = 3:length(names(onlyMean))) %>% 
    group_by(Subject, Activity, variable) %>%
    summarize(mean = mean(value))


write.table(meltedGsum, file="result.txt", row.name=FALSE)
