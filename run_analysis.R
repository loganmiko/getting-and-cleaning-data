##read the tables in for train
subjecttrain = read.table("./train/subject_train.txt", header = FALSE)
xtrain = read.table("./train/x_train.txt", header = FALSE)
ytrain = read.table("./train/y_train.txt", header = FALSE)

##read the tables in for test
subjecttest = read.table("./test/subject_test.txt", header = FALSE)
xtest = read.table("./test/x_test.txt", header = FALSE)
ytest = read.table("./test/y_test.txt", header = FALSE)

##combind the data sets
xdataset <- rbind(xtrain, xtest)
ydataset <- rbind(ytrain, ytest)
subjectdataset <- rbind(subjecttrain, subjecttest)

##only keep mean and std
xdatasetmeanstd <- xdataset[, grep("-(mean|std)\\(\\)", read.table("features.txt")[,2])]
names(xdatasetmeanstd) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[,2]),2]

##name the activities with descriptive names
ydataset[,1] <- read.table("activity_labels.txt")[ydataset[,1],2]
names(ydataset) <- "Activity"
names(subjectdataset) <- "Subject"

##combind all data into one data set
alldataset <- cbind(xdatasetmeanstd, ydataset, subjectdataset)

##defining descriptive names for variables
names(alldataset) <- make.names(names(alldataset))
names(alldataset) <- make.names(names(alldataset))
names(alldataset) <- gsub('Acc',"Acceleration",names(alldataset))
names(alldataset) <- gsub('GyroJerk',"AngularAcceleration",names(alldataset))
names(alldataset) <- gsub('Gyro',"AngularSpeed",names(alldataset))
names(alldataset) <- gsub('Mag',"Magnitude",names(alldataset))
names(alldataset) <- gsub('^t',"TimeDomain.",names(alldataset))
names(alldataset) <- gsub('^f',"FrequencyDomain.",names(alldataset))
names(alldataset) <- gsub('\\.mean',".Mean",names(alldataset))
names(alldataset) <- gsub('\\.std',".StandardDeviation",names(alldataset))
names(alldataset) <- gsub('Freq\\.',"Frequency.",names(alldataset))
names(alldataset) <- gsub('Freq$',"Frequency",names(alldataset))

##create a new tidy data set, with averages
tidydata <- aggregate(. ~Subject + Activity, alldataset, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata, file = "tidydata.txt", row.name=FALSE)