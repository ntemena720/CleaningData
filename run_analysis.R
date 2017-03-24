setwd("C:/Users/noeltemena/Desktop/Data Science/Data Cleaning/Week4/UCI HAR Dataset")
library(reshape2)
Datatrain <- read.table("./train/X_train.txt", fill=FALSE, strip.white=TRUE) #read train data values
ActivityTrain <- read.table("./train/y_train.txt", fill=FALSE, strip.white=TRUE) #read Activity data for train data
Subjecttrain <- read.table("./train/subject_train.txt", fill=FALSE, strip.white=TRUE) #read subject for train data
TrainData <- cbind(ActivityTrain,Datatrain) # add activity column to train data
TrainData <- cbind(Subjecttrain,TrainData) # add subject column to train data


Datatest <- read.table("./test/X_test.txt", fill=FALSE, strip.white=TRUE) # read test data values
Activitytest <- read.table("./test/y_test.txt", fill=FALSE, strip.white=TRUE)# read Activity test data
Subjecttest <- read.table("./test/subject_test.txt", fill=FALSE, strip.white=TRUE) #read subject for train data
TestData <- cbind(Activitytest,Datatest) # add activity column to test data
TestData <- cbind(Subjecttest,TestData) # add activity column to test data
Mydata <- rbind(TestData,TrainData) # append data from test data to the train data
#done merging table

COLnames <-read.table("features.txt",stringsAsFactors = FALSE, fill=FALSE, strip.white=TRUE) # Get Column names
COLnames <- rbind(c(0,"Activities"),COLnames)
COLnames <- rbind(c(0,"Subject"),COLnames)
colnames(Mydata) <- COLnames[,2] # add the column names
#done putting column names on mydata

mean_std_col <- grep("Subject|.std()|mean()|Activities",COLnames[,2]) # get col names with mean and std measurement
# done gather all columns with mean and std
Mdata <- Mydata[,mean_std_col] # create new data frame based from column with only std and mean mesurement
#done Mdata is now columns with just STD and mean values 

NewColNames1 <- names(Mdata)
Cnames <- sub("\\()","",NewColNames1) #take out ()
Cnames <- sub("-","",Cnames)
Cnames <- sub("tBody","Time_Body_",Cnames)
Cnames <- sub("tGravity","Time_Gravity_",Cnames)
Cnames <- sub("fBody","FREQUENCY_Body_",Cnames)
Cnames <- sub("mean","_MEAN_",Cnames)
Cnames <- sub("std","_STD_",Cnames)
names(Mdata) <- Cnames #Rename columns with descriptive names
#done with descriptive column names

Activities <- as.character(Mdata$Activities) # change int values to char to prep for activities regex
#("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING" , "STANDING", "LAYING")
Activities <- sub("1","WALKING",Activities) # change char 1 to walking
Activities <- sub("2","WALKING_UPSTAIRS",Activities) # change char 2 to walking up
Activities <- sub("3","WALKING_DOWNSTAIRS",Activities) # change char 3 to walking down
Activities <- sub("4","SITTING",Activities) # change char 4 to sitting
Activities <- sub("5","STANDING",Activities)# change char 5 to standing
Activities <- sub("6","LAYING",Activities) # change char 5 to laying
Mdata$Activities <- Activities # replace integet values to descriptive activities
#done changing activities from integer to descriptive char values

Meltdata <- melt(Mdata, id = c("Subject", "Activities")) # convert to skinny and tall data frame 
FinalData <- dcast(Meltdata,Subject+Activities ~ variable,fun.aggregate = mean) # widen data format with mean values
write.table(FinalData,file = "tidydata.txt",row.name=FALSE)
