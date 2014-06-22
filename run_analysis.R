## This function reads in common data contained in activity_labels.txt and features.txt
## It also gives meaningful column names to activity labels data frame
## It also removes characters that are not valid for column names from features and makes sure they are unique
## using make.names function, since these values become column names later on

readCommonData <- function (directory) {
    # read activity labels
    filePath <- paste ("./", directory, "/activity_labels.txt", sep="")
    activityLabels <<- read.table(filePath)
    # Give meaningful column names
    colnames(activityLabels) <<- c ("ActivityID", "ActivityName")
    
    # read features
    filePath <- paste ("./", directory, "/features.txt", sep="")
    features <<- read.table (filePath)
    
    # remove "() and replace , with ." from features
    features$V2 <<- gsub("\\(\\)", "", features$V2)
    features$V2 <<- gsub("\\(", ".", features$V2)
    features$V2 <<- gsub("\\)", "", features$V2)
    features$V2 <<- gsub(",|-", ".", features$V2)
    features$V2 <<- make.names(features$V2, unique = TRUE)
}

## This function reads in all result data for test and train data sets
## directory - this is the name of the directory containing the data files. It is expected to be in the working directory
## Column names are updated to meaningful names

readResultData <- function (directory) {
    ## read data for test
    # read subjects
    filePath <- paste ("./", directory, "/test/subject_test.txt", sep="")
    testSubjects <<- read.table (filePath)
    # Give a meaningful column name
    colnames(testSubjects) <<- c("Subject")
    
    # read results
    filePath <- paste ("./", directory, "/test/X_test.txt", sep="")
    testResults <<- read.table (filePath)
    # Update column names
    colnames (testResults) <<- features$V2
    
    # read activity labels for results
    filePath <- paste ("./", directory, "/test/y_test.txt", sep="")
    testResultsActivityLabels <<- read.table (filePath)
    # Give a meaningful column name
    colnames(testResultsActivityLabels) <<- c("ActivityID")
    
    ## read data for train
    # read subjects
    filePath <- paste ("./", directory, "/train/subject_train.txt", sep="")
    trainSubjects <<- read.table (filePath)
    # Give a meaningful column name
    colnames(trainSubjects) <<- c("Subject")
    
    # read results
    filePath <- paste ("./", directory, "/train/X_train.txt", sep="")
    trainResults <<- read.table (filePath)
    # Update column names
    colnames (trainResults) <<- features$V2
    
    # read activity labels for results
    filePath <- paste ("./", directory, "/train/y_train.txt", sep="")
    trainResultsActivityLabels <<- read.table (filePath) 
    # Give a meaningful column name
    colnames(trainResultsActivityLabels) <<- c("ActivityID")
}

## This function writes out a data frame as a CSV file to the working directory
## df - data frame to be written out
## fileName - name of the file

writeDFToFile <- function (df, fileName) {
    filePath <- paste ("./", fileName, ".csv", sep="")
    write.table(df, file=filePath, sep=",", row.names=FALSE)    
}

## This is the main function which does the following -
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

run_analysis <- function() {
    ## call functions to read all data
    readCommonData("UCI HAR Dataset")
    readResultData("UCI HAR Dataset")
    
    ## put subjects, activity labels and results together in one data frame for both and test and train data sets 
    fullTestResultsDF <- cbind (testSubjects, testResultsActivityLabels, testResults)
    fullTrainResultsDF <- cbind (trainSubjects, trainResultsActivityLabels, trainResults)
    
    ## merge full test/train results data sets with activity labels to include the activity names in the data sets
    ## instead of Activity IDs and reorder the columns a bit for clarity
    fullTestResultsDF <- merge (fullTestResultsDF, activityLabels, by = "ActivityID")
    fullTestResultsDF <- fullTestResultsDF[,c(564,2:563)]
    fullTrainResultsDF <- merge (fullTrainResultsDF, activityLabels, by = "ActivityID")
    fullTrainResultsDF <- fullTrainResultsDF[,c(564,2:563)]
    
    ## combine test and train results into one data set
    mergedResultsDF <- rbind (fullTestResultsDF, fullTrainResultsDF)
    
    ## Extract only the measurements on the mean and standard deviation for each measurement
    ## Do this by determining the column indicies to include from the merged results data set
    colindices <- grep("mean|std", features$V2, ignore.case=TRUE)
    
    # Since the merged data set has these columns starting @ index 3 (first column is ActivityName, second column
    # is Subject), add 2 to each value in the vector above
    colindices <- colindices + rep (2, length(colindices))
    mergedResultsDFMeanAndSTDOnly <- mergedResultsDF[,c(1:2,colindices)]
    
    ## Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
    meltedData <- melt (mergedResultsDFMeanAndSTDOnly, id=c("Subject","ActivityName"))
    tidyData <- dcast (meltedData, formula = Subject + ActivityName ~ variable, mean)
    colnames (tidyData) <- c ("Subject", "ActivityName", paste("Avg - ", colnames(tidyData)[3:length(colnames(tidyData))]))
    
    ## Write out all 3 data sets to separate files
    #writeDFToFile (mergedResultsDF, "Test_And_Train_Merged")
    #writeDFToFile (mergedResultsDFMeanAndSTDOnly, "Test_And_Train_Merged_Mean_And_STD_Only")
    writeDFToFile (tidyData, "Avg_Each_Variable_ForEach_Activity_And_Subject")
}
