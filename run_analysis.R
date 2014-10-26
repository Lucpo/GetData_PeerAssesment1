## run_analysis script

# 1. Merge training and test data sets
# set user folder
# setwd('M:/Courses/datasciencecoursera/GetDataProject');

# Read data
subjectTrain = read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE); 
xTrain       = read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE); 
yTrain       = read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE); 
features     = read.table('./UCI HAR Dataset/features.txt',header=FALSE); 

activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE); 
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Assign column names for train data
colnames(activityLabels)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";


# Create training set by merging all training data 
trainingData = cbind(xTrain,yTrain,subjectTrain);


# Read test data
subjectTest = read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
xTest       = read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE); 
yTest       = read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE); 


# Assign column names for test data 
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";


# Create  test set by merging data
testData = cbind(xTest,yTest,subjectTest);


# Combine training and test data to create a final data set
allData = rbind(trainingData,testData);


# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# Get only the data on mean and std. dev.
colMS <- grep(".*Mean.*|.*Std.*", features[,2])

# Reduce the features table to what we want
features <- features[colMS,]

# Now add the last two columns (subject and activity)
colMS <- c(colMS, 562, 563)

# Remove the unwanted columns from allData
allData <- allData[,colMS]

# 3. Uses descriptive activity names to name the activities in the data set
currentActivity = 1
for (currentActivityLabel in activityLabels$activityType) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}


