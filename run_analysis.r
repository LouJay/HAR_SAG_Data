library(dplyr)

## Reading data, assuming "UCI HAR Dataset" directory is located in the
## working directory with the "train" and "test" directories inside it

activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
variables<-read.table("./UCI HAR Dataset/features.txt")
trainsubjects<-read.table("./UCI HAR Dataset/train/subject_train.txt")
trainactivities<-read.table("./UCI HAR Dataset/train/y_train.txt")
trainmeasurements<-read.table("./UCI HAR Dataset/train/X_train.txt")
testsubjects<-read.table("./UCI HAR Dataset/test/subject_test.txt")
testactivities<-read.table("./UCI HAR Dataset/test/y_test.txt")
testmeasurements<-read.table("./UCI HAR Dataset/test/X_test.txt")

## Renaming columns for more clear and understandable names
## First we need to ensure the column names of the final data will be valid,
## (given that some of the variables appear more than once), since the select()
## and the merge() functions need unique and valid column names
colnames(activities)<-c("activity_id","activity")
colnames(trainsubjects)<-"subject_id"
colnames(testsubjects)<-"subject_id"
colnames(trainactivities)<-"activity_id"
colnames(testactivities)<-"activity_id"
colnames(trainmeasurements)<-make.names(names=variables$V2,unique=TRUE,allow_=TRUE)
colnames(testmeasurements)<-make.names(names=variables$V2,unique=TRUE,allow_=TRUE)

## Constructing complete train table
traindata<-cbind(trainsubjects,trainactivities,trainmeasurements)
## Constructing complete test table
testdata<-cbind(testsubjects,testactivities,testmeasurements)
## Merging both tables
mergeddata<-rbind(traindata,testdata)

## Keeping only mean() and std() columns
subsetdata<-select(mergeddata,subject_id,activity_id,contains("mean"),contains("std"))

## Adding activity labels to the activity ids
subsetdata<-merge(subsetdata,activities,all.x=TRUE,sort=FALSE)

## Summarizing variables' data by average per subject-activity pair
tidydata<-summarize_each(group_by(subsetdata,subject_id,activity),funs(mean))

## Creating final tidydata text file
write.table(tidydata, file="HAR_tidydata.txt",row.name=FALSE)
