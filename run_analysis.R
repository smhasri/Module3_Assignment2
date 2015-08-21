##Read Dataset Online
onlineFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##download the file
download.file(onlineFile, "./UCI-HAR-dataset.zip", method="auto")
##unzip and create directory automatically
unzip("./UCI-HAR-dataset.zip")

# 1. Merges the training and the test sets to create one data set.
##read features column
features <- read.table("./UCI HAR Dataset/features.txt")
##read test.x
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
##read train.x
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
X <- rbind(test.x, train.x)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##filter features which has column mean and std
features <- features[grep("(mean|std)\\(", features[,2]),]
##add both to mean_and_std
mean_and_std <- X[,features[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
##read test.y
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
##read train.y
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
##bind to y
y <- rbind(test.y, train.y)

##read labels
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
##map activity to code
for (i in 1:nrow(labels)) {
        code <- as.numeric(labels[i, 1])
        name <- as.character(labels[i, 2])
        y[y$activity == code, ] <- name
}

# 4. Appropriately labels the data set with descriptive activity names. 
##read labels.x
labels.x <- cbind(y, X)
##bind to labels.mean_and_std
labels.mean_and_std <- cbind(y, mean_and_std)

# 5. Creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject. 
##test.subject
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
##train.subject
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
## bind to subject
subject <- rbind(test.subject, train.subject)
## get average
averages <- aggregate(X, by = list(activity = y[,1], subject = subject[,1]), mean)
if (file.exists("./result.txt")){
   file.remove("./result.txt")
}
## write to text
write.csv(averages, file="./result.txt", row.names=FALSE)


