Code Book for the Project
=========================

The script run_analysis.R has the following functions -

- readCommonData (directory)
- readResultData (directory)
- writeDFToFile (df, fileName)
- run_analysis()

readCommonData (directory)
--------------------------
This function reads in common data contained in activity_labels.txt and features.txt.
directory - this is the name of the directory containing the two files. It is expected to be in the working directory.
It also gives meaningful column names to activity labels data frame.
It also removes characters that are not valid for column names from features and makes sure they are unique
using make.names function, since these values become column names later on.

readResultData (directory)
--------------------------
This function reads in all result data for test and train data sets.
directory - this is the name of the directory containing the data files. It is expected to be in the working directory.
Column names are updated to meaningful names.

writeDFToFile (df, fileName)
----------------------------
This function writes out a data frame as a CSV file to the working directory
df - data frame to be written out
fileName - name of the file

run_analysis()
--------------
This is the main function which does the following:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

