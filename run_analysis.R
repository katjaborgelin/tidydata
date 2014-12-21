run_analysis <- function(){
  testset <- read.table("./test/x_test.txt")
  testsubject <- read.table("./test/subject_test.txt")
  testlabels <- read.table("./test/y_test.txt")
  
  trainset <- read.table("./train/x_train.txt")
  trainsubject <- read.table("./train/subject_train.txt")
  trainlabels <- read.table("./train/y_train.txt")
  
  set <- rbind(testset, trainset)
  
  features <- read.table("./features.txt")
  columns <- features[2]
  columns <- data.frame(lapply(columns, as.character), stringsAsFactors=FALSE)
  columns <- unlist(columns)
  colnames(set) <- columns
  
  newset <- subset(set, select = grepl("mean", names(set)))
  newset <- subset(newset, select = !grepl("Freq", names(newset)))
  newset2 <- subset(set, select = grepl("std", names(set))) 
  newset <- cbind(newset, newset2)
  
  subjects <- rbind(testsubject, trainsubject)
  colnames(subjects) <- c("Subject")
  labels <- rbind(testlabels, trainlabels)
  colnames(labels) <- c("Activity")
  tidydata <- cbind(labels, subjects, newset)
  
  activities <- read.table("./activity_labels.txt")
  activities <- activities[2]
  activities <- data.frame(lapply(activities, as.character), stringsAsFactors=FALSE)
  activities <- unlist(activities)
  
  tidydata <- transform(tidydata, Activity = activities[Activity])
  
  datamelt <- melt(tidydata, id = c("Activity", "Subject"))
  data <- dcast(datamelt, Activity + Subject ~ variable, mean)
  data  
}