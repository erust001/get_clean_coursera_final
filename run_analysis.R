library(reshape2)
library(dplyr)
rawDataDir <- "./rawData"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "./data"

if (!file.exists(rawDataDir)) {
  dir.create(rawDataDir)
  download.file(url = rawDataUrl, destfile = rawDataDFn)
}
if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(zipfile = rawDataDFn, exdir = dataDir)
}

#loading test and train datasets
x_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"))

x_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"))

# merge {train, test} data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

#loading feature and labels data
feature <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"),stringsAsFactors = FALSE)
labels <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"),stringsAsFactors = FALSE)
#subsetting columns which contains 'mean' or 'std'
feature<-feature%>%mutate(V2=tolower(V2))
col_index<-grep(("mean|std"),feature[,2])
x_data<-x_data[col_index]
#merge all data and label it
all_data<-cbind(s_data,y_data,x_data)
colnames(all_data)<-c("subject","activity",feature[col_index,2])
labels
all_data<-all_data%>%mutate(activity=labels[activity,2])
#writing txt file
write.table(all_data,"./tidy_data.txt", row.names = FALSE, quote = FALSE)
