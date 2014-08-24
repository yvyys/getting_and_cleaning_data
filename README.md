### Introduction

This programming uses the data from a experiment about persons, who
wearing a smartphone (Samsung Galaxy S II)and doing different activities.
The function run_analysis():
	+ Merges the training and the test sets to create one data set
	+ Extracts only the measurements on the mean and standard deviation for each measurement
	+ Creates a second, independent tidy data set with the average of each variable
    + Saves the tidy data set in a file called tidy_data_from_the_course_project.txt
	
For more informations about the experiment, read the README.txt saved in this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### What do the programming

	+ The paths to access to the needed files are put in variables
	+ with the 'for' commando, the files subject..., X_... and y_... are read
	  from each directory train and test and saved in two different temporaries tables:
	  temptable_train; temptable_test
	+ these both tables are bound together
	+ the 'namescol-...' variables help to:
		- collect the names from the measures in the file feature.txt
		- create and transform the columns name.
	+ A merge function will use to change to activities numbers with the activities names
	  from the file activity_labels.txt
	+ Only the measures columns with the 'mean' and 'std' functions are saved
	+ the column 'setclass' with the information about the origin from data (train or test) is removed
	+ The function 'melt' and 'dcast' from the package 'reshape2' are used to calculate the average of each variable
	
For better understanding please read the commentaries in the file run_analysis.R
	  
### Step to run the programming

- Download the data under this link:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
- Download the R file run_analysis.R under ...
- run the file and call the function run_analysis()