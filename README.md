Getting and Cleaning Data Course Project
========================

Project formulation
------------

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the [site where the data was obtained](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

[Here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) are the data for the project.

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Implementation
------------

The course project has been implemented in run_analysis.R. This script does the following:
- Downloads the [raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) from the internet if it is not available at folder *UCI HAR Dataset*. 
- Performs the 5 steps given in the project formulation and creates a new folder called *UCI HAR Dataset (Tidy)* to store the tidy data:
    - *dataset.csv*: the tidy data produced after step 4.
    - *dataset-summary.csv*: the tidy data summary produced after step 5.

Running this project
------------
### 1. Download
You can download this project directly from Github using the following command:
`git clone https://github.com/hlfernandez/GettingAndCleaningDataCourseProject.git `

### 2. Launch
You can open R and type:
`source("run_analysis.R")`

Alternatively, you can also run the script using the R batch mode from console with:
`R CMD BATCH run_analysis.R`