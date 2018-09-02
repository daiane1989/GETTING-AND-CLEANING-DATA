#COURSERA GETTING AND CLEANING DATA WEEK 4

#1) Merges the training and the test sets to create one data set.

setwd("C:/Users/Daiane/Desktop/COURSERA/Cleanind Data/semana4")

pathdata = file.path("./projeto", "UCI HAR Dataset")

files = list.files(pathdata, recursive=TRUE)

#train
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)

subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

#test
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)

subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)

#Features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)

#TRAIN
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)


colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#TEST
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#labEL
colnames(activityLabels) <- c('activityId','activityType')


#Merging
mrgtrain = cbind(ytrain, subject_train, xtrain)
mrgtest = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables - this is the outcome of 1

all = rbind(mrgtrain, mrgtest)

################################################################################################
#2) Extracts only the measurements on the mean and standard deviation for each measurement. 

colNames = colnames(all)

mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

result <- all[ , mean_and_std == TRUE]

################################################################################################
#3)Uses descriptive activity names to name the activities in the data set

names = merge(result, activityLabels, by='activityId', all.x=TRUE)

################################################################################################
#4) Appropriately labels the data set with descriptive variable names

data <- aggregate(. ~subjectId + activityId, names, mean)
data <- data[order(data$subjectId, data$activityId),]

#########################################################
#5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

write.table(data, "secTidySet.txt", row.name=FALSE)



