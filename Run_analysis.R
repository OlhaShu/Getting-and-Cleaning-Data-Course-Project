## Getting and data reading


if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files
dATest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dATrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
dSTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dSTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dFTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dFTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


## 1 Merge the training and the test sets to create one dataset

data_Subject <- rbind(dSTrain, dSTest)
data_Activity<- rbind(dATrain, dATest)
data_Features<- rbind(dFTrain, dFTest)
names(data_Subject)<-c("subject")
names(data_Activity)<- c("activity")
data_FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(data_Features)<- data_FeaturesNames$V2
data_Combine <- cbind(data_Subject, data_Activity)
Data <- cbind(data_Features, data_Combine)


## 2 Extract only the measurements on the mean and standard deviation for each measurement

subdata_FeaturesNames<-data_FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", data_FeaturesNames$V2)]
selected_Names<-c(as.character(subdata_FeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selected_Names)


## 3 Uses descriptive activity names to name the activities in the data set

activity_Labels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## 4 Appropriately labels the data set with descriptive variable names


names(data_Subject)<-"Subject"
summary(data_Subject)

## 5 Create a second, independent tidy data set with the average of each variable for each activity and each subject

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
str(Data2)
Data5 <- read.table("C:/Users/Olha/Documents/tidydata.txt",header=FALSE)
head(Data5)

