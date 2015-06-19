# 
# Input/Output directory settings. 
# This script asumes that the input dataset is located at a directory called 'UCI HAR Dataset'. If you 
# want to specify other location, change 'dataDirectory' variable.
# If the directory specified at 'dataDirectory' does not exist, the dataset will be downloaded from the 
# internet in the working directory of the script.
# 
dataDirectory 		<- "UCI HAR Dataset"
outputDataDirectory 	<- "UCI HAR Dataset (Tidy)"
outputDataFile.dataset 	<- paste(outputDataDirectory,"/","dataset.csv",sep="")
outputDataFile.summary 	<- paste(outputDataDirectory,"/","dataset-summary.csv",sep="")

# 
# Definition of tidy dataset column mames, to avoid 'magic' spreading constant colum names.
# 
COL_SUBJECT 	<- "Subject"
COL_ACTIVITY 	<- "Activity"
COL_MEAN 	<- "Mean"
COL_STD 	<- "Std"

if(!file.exists(dataDirectory)) {
  dataUrl 	<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dataFile 	<- "dataset.zip"
  download.file(dataUrl, destfile=dataFile, method="curl")
  unzip(dataFile)
}

#
# This function capitalizes a string. For example, given string "WALKING" result is "Walking".
#
capitalize <- function(s) {
    paste(
      toupper(substring(s, 1,1)),	# First letter to upper
      tolower(substring(s, 2)),		# Rest of letters to lower
      sep="", collapse=" "
    )
}

#
# This function loads the 'features.txt' file of the dataset and returns a vector containing the feature labels.
#
loadFeaturesLabels <- function(dataDirectory) {
  features.file <- paste(dataDirectory,"/","features.txt", sep="")
  features <- read.table(file=features.file, stringsAsFactors=FALSE)
  features$V2
}

#
# This function returns a vector containing the column names of the tidy dataset.
#
getColumnNames <- function(dataDirectory) {
  featureLabels <- make.names(loadFeaturesLabels(dataDirectory));
  featureLabels <- gsub("\\.", "", featureLabels)
  featureLabels <- gsub("std", COL_STD, featureLabels)
  featureLabels <- gsub("mean", COL_MEAN, featureLabels)
  c(COL_SUBJECT, COL_ACTIVITY, featureLabels)
}

#
# This function loads the 'activity_labels.txt' file of the dataset and return a vector containing the capitalized activity labels.
#
loadActivitiesLabels <- function(dataDirectory) {
  activities.file <- paste(dataDirectory,"/","activity_labels.txt", sep="")
  activities <- read.table(file=activities.file, stringsAsFactors=FALSE)
  sapply(activities$V2, FUN = capitalize)  
}

loadRawData <- function(dataDirectory, dir, colNames, activities) {
  baseDir <- paste(dataDirectory,"/",dir, sep="")
  
  X.file <- paste(baseDir,"/X_", dir,".txt", sep="")
  X <- read.table(file=X.file)
  
  subject.file <- paste(baseDir,"/subject_", dir,".txt", sep="")
  subject <- read.table(file=subject.file)
  
  y.file <- paste(baseDir,"/y_", dir,".txt", sep="")
  y <- read.table(file=y.file)$V1
  
  data <- cbind(subject, activities[y], X) 
  colnames(data) <-  colNames  
  
  return(data)
}

write.custom <- function(data, file) {
  write.csv(data, file = file, quote=F, row.names=FALSE)
}


columnNames 	<- getColumnNames(dataDirectory)
activities 	<- loadActivitiesLabels(dataDirectory)

data.test 	<- loadRawData(dataDirectory, "test", 	columnNames, activities)
data.train 	<- loadRawData(dataDirectory, "train", 	columnNames, activities)

data 	<- rbind(data.test, data.train)
data 	<- data[,c(COL_SUBJECT,COL_ACTIVITY, colnames(data)[grepl(paste(COL_MEAN, COL_STD, sep="|"), colnames(data))])]
data	<- data[order(data[[COL_SUBJECT]]),]

summary <- aggregate(
    data[3:(ncol(data))], 
    by=data[c(COL_SUBJECT,COL_ACTIVITY)], 
    FUN = "mean"
  )


dir.create(outputDataDirectory, showWarnings=FALSE)

write.custom(data, 	file = outputDataFile.dataset)
write.custom(summary, 	file = outputDataFile.summary)
