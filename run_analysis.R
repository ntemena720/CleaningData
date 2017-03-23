Datatrain <- read.table("./train/X_train.txt", fill=FALSE, strip.white=TRUE) #read train data values
ActivityTrain <- read.table("./train/y_train.txt", fill=FALSE, strip.white=TRUE) #read Activity data for train data
#colnames(ActivityTrain) <- "Activity" # add Activity at the end of the column
Datatest <- read.table("./test/X_test.txt", fill=FALSE, strip.white=TRUE) # read test data values
Activitytest <- read.table("./test/y_test.txt", fill=FALSE, strip.white=TRUE)# read Activity test data
TestData <- cbind(Datatest,Activitytest) # add activity column to test data
TrainData <- cbind(Datatrain,ActivityTrain) # add activity column to train data
Mydata <- rbind(TestData,TrainData) # append data from test data to the train data
#done merging table
COLnames <-read.table("features.txt", fill=FALSE, strip.white=TRUE) # Get Column names
tempnames <- names(COLnames)
ApendActivity<- data.frame(562, "Activities") # add Activities at the end 
names(ApendActivity) <- tempnames
COLnames <- rbind(COLnames,ApendActivity) # combine list of columnnames + activities
colnames(Mydata) <- COLnames[,2] # add the column names
#done putting column names on mydata
mean_std_col <- grep(".std().|.mean()|Activities",COLnames[,2]) # get col names with mean and std measurement
# done gather all columns with mean and std
Mdata <- Mydata[,mean_std_col] # create new data frame based from column with only std and mean mesurement
#done Mdata is now columns with just STD and mean values 
NewColNames <- names(Mdata)
freqCol <- grep(".Freq.",NewColNames) #list column names with mean freq
Mdata1 <- Mdata[,-freqCol] #take out column names with meanfreq
#done

NewColNames1 <- names(Mdata1)
Cnames <- sub("\\()","",NewColNames1) #take out ()
Cnames <- sub("-","",Cnames)
Cnames <- sub("tBody","Time_Body_",Cnames)
Cnames <- sub("tGravity","Time_Gravity_",Cnames)
Cnames <- sub("fBody","FREQUENCY_Body_",Cnames)
Cnames <- sub("mean","_MEAN_",Cnames)
Cnames <- sub("std","_STD_",Cnames)
names(Mdata1) <- Cnames #Rename columns with descriptive names
#done with descriptive column names
Activities <- as.character(Mdata1$Activities) # change int values to char to prep for activities regex
#("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING" , "STANDING", "LAYING")
Activities <- sub("1","WALKING",Activities) # change char 1 to walking
Activities <- sub("2","WALKING_UPSTAIRS",Activities) # change char 2 to walking up
Activities <- sub("3","WALKING_DOWNSTAIRS",Activities) # change char 3 to walking down
Activities <- sub("4","SITTING",Activities) # change char 4 to sitting
Activities <- sub("5","STANDING",Activities)# change char 5 to standing
Activities <- sub("6","LAYING",Activities) # change char 5 to laying
Mdata1 <- Mdata1[,-67] #delete previos integer activity
dfActivities <- as.data.frame(Activities) #convert vector to data frame
Mdata2 <- cbind(Mdata1,dfActivities) #combine activity column to the data 
#done changing activities from integer to descriptive char values
Fdata <- melt(Mdata2) # convert to skinny and tall data frame 
FinalData <- dcast(Fdata, variable ~ Activities,fun.aggregate = mean) # widen data format with mean values
write.table(FinalData,file = "tidydata.txt",row.name=FALSE)
