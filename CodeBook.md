## Step by step instructions on how data was cleaned and reshaped


Read all 5 raw text files
1) X_train.txt (training data)
2) y_train.txt (corresponding Activity code column for training data)
3) X_test.txt (test data)
4) y_test.txt (corresponding Activity code column for test data)
5) features.txt (561 column names)

Cbind Activity code column to corresponding data

Rbind the Test and train data 

Add coresponding 561 column names + Activity code column

This resulted in 10299 observations and 562 variables



Code for the above task:

    Datatrain <- read.table("./train/X_train.txt", fill=FALSE, strip.white=TRUE) 
    ActivityTrain <- read.table("./train/y_train.txt", fill=FALSE, strip.white=TRUE) 
    colnames(ActivityTrain) <- "Activity" 
    Datatest <- read.table("./test/X_test.txt", fill=FALSE, strip.white=TRUE) 
    Activitytest <- read.table("./test/y_test.txt", fill=FALSE, strip.white=TRUE)
    TestData <- cbind(Datatest,Activitytest)
    TrainData <- cbind(Datatrain,ActivityTrain) 
    Mydata <- rbind(TestData,TrainData) # append data from test data to the train data
    COLnames <-read.table("features.txt", fill=FALSE, strip.white=TRUE) 
    tempnames <- names(COLnames)
    ApendActivity<- data.frame(562, "Activities") 
    names(ApendActivity) <- tempnames
    COLnames <- rbind(COLnames,ApendActivity) 
    colnames(Mydata) <- COLnames[,2]

Flag columnames with the word Mean and STD

Create new data frame of index based fom this select columnames

Create new data frame of index based fom this select columnames

Combine the dataframe and create a new data with just column names of mean(),std()and Activities 

Delete columnnames with the word Mean frequency


Code for the above task:

	mean_std_col <- grep(".std().|.mean()|Activities",COLnames[,2]) 
	Mdata <- Mydata[,mean_std_col] # create new data frame based from column with only std and mean mesurement
	NewColNames <- names(Mdata)
	freqCol <- grep(".Freq.",NewColNames)
	Mdata1 <- Mdata[,-freqCol] 

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

Delete the old integer activities column and add the descriptive activity column

Code for the above task:

	Activities <- as.character(Mdata1$Activities) 
	Activities <- sub("1","WALKING",Activities) # change char 1 to walking
	Activities <- sub("2","WALKING_UPSTAIRS",Activities) # change char 2 to walking up
	Activities <- sub("3","WALKING_DOWNSTAIRS",Activities) # change char 3 to walking down
	Activities <- sub("4","SITTING",Activities) # change char 4 to sitting
	Activities <- sub("5","STANDING",Activities)# change char 5 to standing
	Activities <- sub("6","LAYING",Activities) # change char 5 to laying
	Mdata1 <- Mdata1[,-67] #delete previos integer activity
	dfActivities <- as.data.frame(Activities) #convert vector to data frame
	Mdata2 <- cbind(Mdata1,dfActivities) #combine activity column to the data 

Convert data to skinny and tall data frame (dimension 679734 observation of 3 variables)

Convert the data again to widen the format with mean values (dimension 66 observation of 7 variables)

Code for the above task:

	Fdata <- melt(Mdata2) # convert to skinny and tall data frame 
	FinalData <- dcast(Fdata, variable ~ Activities,fun.aggregate = mean) # widen data format with mean values
	write.table(FinalData,file = "tidydata.txt")
