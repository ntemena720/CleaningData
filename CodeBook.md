## Step by step instructions on how data was cleaned and reshaped


Read all 7 raw text files
1) X_train.txt (training data)
2) y_train.txt (corresponding Activity code column for training data)
3) X_test.txt (test data)
4) y_test.txt (corresponding Activity code column for test data)
5) features.txt (561 column names)
6) subject_train.txt (subject values for training)
7) subject_test.txt (subject values for testing)

Cbind Activity and subject code column to corresponding data

Rbind the Test and train data 

Add coresponding 561 column names + Activity code column

This resulted in 10299 observations and 562 variables



Code for the above task:

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
	COLnames <-read.table("features.txt",stringsAsFactors = FALSE, fill=FALSE, strip.white=TRUE) # Get Column names
	COLnames <- rbind(c(0,"Activities"),COLnames)
	COLnames <- rbind(c(0,"Subject"),COLnames)
	colnames(Mydata) <- COLnames[,2] # add the column names

Flag columnames with the word Mean and STD

Combine the dataframe and create a new data with just column names of mean(),std(), Activities and subject

Code for the above task:

	mean_std_col <- grep("Subject|.std()|mean()|Activities",COLnames[,2]) # get col names with mean and std measurement
	Mdata <- Mydata[,mean_std_col]

Rename columns to have a more descriptive column name

Code for the above task:

	NewColNames1 <- names(Mdata1)
	Cnames <- sub("\\()","",NewColNames1) #take out ()
	Cnames <- sub("-","",Cnames)
	Cnames <- sub("tBody","Time_Body_",Cnames)
	Cnames <- sub("tGravity","Time_Gravity_",Cnames)
	Cnames <- sub("fBody","FREQUENCY_Body_",Cnames)
	Cnames <- sub("mean","_MEAN_",Cnames)
	Cnames <- sub("std","_STD_",Cnames)
	names(Mdata1) <- Cnames #Rename columns with descriptive names

Get the integer values of Activities

Create a new vector and change it to the proper descriptive character activities

"WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING" , "STANDING", "LAYING"

Code for the above task:

	Activities <- as.character(Mdata$Activities) # change int values to char to prep for activities regex
	#("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING" , "STANDING", "LAYING")
	Activities <- sub("1","WALKING",Activities) # change char 1 to walking
	Activities <- sub("2","WALKING_UPSTAIRS",Activities) # change char 2 to walking up
	Activities <- sub("3","WALKING_DOWNSTAIRS",Activities) # change char 3 to walking down
	Activities <- sub("4","SITTING",Activities) # change char 4 to sitting
	Activities <- sub("5","STANDING",Activities)# change char 5 to standing
	Activities <- sub("6","LAYING",Activities) # change char 5 to laying
	Mdata$Activities <- Activities # replace integet values to descriptive activities

Convert data to skinny and tall data frame (dimension 813621 observation of 4 variables)

Convert the data again to widen the format with mean values (dimension 180 observation of 81 variables)

Code for the above task:

	Meltdata <- melt(Mdata, id = c("Subject", "Activities")) # convert to skinny and tall data frame 
	FinalData <- dcast(Meltdata,Subject+Activities ~ variable,fun.aggregate = mean) # widen data format with mean values
	write.table(FinalData,file = "tidydata.txt",row.name=FALSE)
