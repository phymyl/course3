# Download data and unzipping
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "UCI-HAR-dataset.zip", method="curl")
unzip("./UCI-HAR-dataset.zip")

# 1. Loading and merging the training and the test sets
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt")
testY <- read.table("./UCI HAR Dataset/test/y_test.txt")
set <- rbind(trainSet, testSet)
sub <- rbind(trainSub, testSub)
y <- rbind(trainY, testY)

# 2. Extracts the mean and standard deviation for each measurement
feature <- read.table("./UCI HAR Dataset/features.txt")
mean_sd <- grep("-mean\\(\\)|-std\\(\\)", feature[, 2])
set <- set[, mean_sd]

# 3. Naming the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])
y[, 1] <- activities[y[, 1], 2]
colnames(y) <- "activity"
colnames(sub) <- "subject"

# 4. Labeling the data set with descriptive variable names
names(set) <- feature[mean_sd, 2]
names(set) <- tolower(names(set)) 
names(set) <- gsub("\\(|\\)", "", names(set))

# Merging all data sets together
df <- cbind(sub, set, y)

# 5. Creating independent tidy data set with the average of each variable for each activity and each subject
tb <- aggregate(x=df, by=list(activities=df$activity, sub=df$subject), FUN=mean)
tb <- tb[, !(colnames(tb) %in% c("sub", "activity"))]
write.table(tb, "./table.txt", row.names = F)
