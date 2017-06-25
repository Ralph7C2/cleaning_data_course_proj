if(!dir.exists("data")) {
  dir.create("data")
}

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data/data.zip")
setwd("data")
unzip("data.zip")
setwd("UCI HAR Dataset")
t1 <- read.table("test/X_test.txt")
t2 <- read.table("train/X_train.txt")
features <- as.character(read.table("features.txt")$V2)
names(t1) <- features
names(t2) <- features
t1 <- t1[,grepl("mean|std", names(t1))]
t2 <- t2[,grepl("mean|std", names(t2))]

t1.activity <- read.table("test/y_test.txt")
t2.activity <- read.table("train/y_train.txt")
names(t1.activity) <- "activity"
names(t2.activity) <- "activity"
t1 <- cbind(t1.activity, t1)
t2 <- cbind(t2.activity, t2)

t1.subject <- read.table("test/subject_test.txt")
t2.subject <- read.table("train/subject_train.txt")
names(t1.subject) <- "subject"
names(t2.subject) <- "subject"
t1 <- cbind(t1.subject, t1)
t2 <- cbind(t2.subject, t2)

df <- rbind(t1, t2)

acts <- as.character(read.table("activity_labels.txt")$V2)
df[,"activity"] <- acts[df[,"activity"]]

splist <- lapply(split(df, df$subject), function(x) { split(x, x$activity)})
bd <- NULL
for(i in seq_along(splist)) {
  for(j in seq_along(splist[[i]])) {
    bd <- rbind(bd,sapply(splist[[i]][[j]][,3:81],mean))
  }
}
bd <- data.frame(bd)
subs <- NULL
for(i in 1:30) { subs <- c(subs, rep(i, 6))}
acts <- rep(1:6, 30)

namelist <- c("subject", "activity", sapply(names(bd), function(x) { paste0("avg", x)}))
bd <- cbind(subs, acts, bd)
names(bd) <- namelist

names(df) <- gsub("-","",names(df))
names(df) <- gsub("\\(","",names(df))
names(df) <- gsub("\\)","",names(df))
names(bd) <- gsub("\\.","",names(bd))
