Code book
========================

Raw data
------------
[Raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description of this *Human Activity Recognition Using Smartphones Dataset* is available at the [site where the data was obtained](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Cleaning procedure
------------

### 0. Load training and test sets

Raw data from train and test subjects is loaded with function `loadRawData`:

```
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
```

This function receives the following arguments:
- *dataDirectory*: the base directory of the data.
- *dir*: the concrete directory (traing/test) to load.
- *colNames*: the column names, previously calculated with function `getColumnNames`.
- *activities*: the activities labels, previously loaded with function `loadActivityLabels`.

Using the above functions, train and test raw data is loaded:

```
data.test 	<- loadRawData(dataDirectory, "test", 	columnNames, activities)
data.train 	<- loadRawData(dataDirectory, "train", 	columnNames, activities)
```

### 1. Merge training and test sets

Once raw data is loaded, train and test data frames are merged using `rbind` and orderer by subject:

```
data 	<- rbind(data.test, data.train)
data	<- data[order(data[[COL_SUBJECT]]),]
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement

For each subject, only the measurements on the mean and standard deviation are taken by subsetting the merged data frame:

```
data 	<- data[,c(COL_SUBJECT,COL_ACTIVITY, colnames(data)[grepl(paste(COL_MEAN, COL_STD, sep="|"), colnames(data))])]
```

### 3. Use descriptive activity names to name the activities in the data set

Activities labels are loaded with function `loadActivityLabels`, which loads the *activity_labels.txt* file and sets descriptive activity names:

```
capitalize <- function(s) {
    paste(
      toupper(substring(s, 1,1)),	# First letter to upper
      tolower(substring(s, 2)),		# Rest of letters to lower
      sep="", collapse=" "
    )
}

loadActivitiesLabels <- function(dataDirectory) {
  activities.file <- paste(dataDirectory,"/","activity_labels.txt", sep="")
  activities <- read.table(file=activities.file, stringsAsFactors=FALSE)
  sapply(activities$V2, FUN = capitalize)  
}
```

### 4. Appropriately labels the data set with descriptive variable names 

Variable names (i.e. column names) are created with function `getColumnNames`, which loads the feature labels stored in *features.txt* and makes them more readable:
```
loadFeaturesLabels <- function(dataDirectory) {
  features.file <- paste(dataDirectory,"/","features.txt", sep="")
  features <- read.table(file=features.file, stringsAsFactors=FALSE)
  features$V2
}

getColumnNames <- function(dataDirectory) {
  featureLabels <- make.names(loadFeaturesLabels(dataDirectory));
  featureLabels <- gsub("\\.", "", featureLabels)
  featureLabels <- gsub("std", COL_STD, featureLabels)
  featureLabels <- gsub("mean", COL_MEAN, featureLabels)
  c(COL_SUBJECT, COL_ACTIVITY, featureLabels)
}

```

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Finally, the merged and tidied data is summarized to create another data set with the average of each variable for each activity and subject.

```
summary <- aggregate(
    data[3:(ncol(data))], 
    by=data[c(COL_SUBJECT,COL_ACTIVITY)], 
    FUN = "mean"
  )
```

Tidy data description
------------

Following the above procedure, the tidy and the summary datasets are writen to *dataset.csv* and *dataset-summary.csv*.

These datasets have 88 variables (i.e. columns), where first and second are the subject and activity label and the other 86 are a subset of the original 561 variables present in the raw data. From the original set of variables, only variables referring to *mean* or *std* has been selected for the tidy dataset.