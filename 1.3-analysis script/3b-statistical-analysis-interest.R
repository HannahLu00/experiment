library(plyr)
library(dplyr)
library(MPDiR)
library(quickpsy)
library(fitdistrplus)
library(ggplot2)

# set directory where script is
sourceDir <- dirname (rstudioapi::getActiveDocumentContext()$path) 
defaultpath <- sourceDir

print(defaultpath)
setwd(defaultpath)

# read global values
source("1-read-and-bind-all-files.R")


# make sure does not exist allData
if (exists ("allData")) { rm(allData) }

# read all files
setwd("results/2_category")
file_list <- list.files(pattern=".csv")
show(file_list)

# initialize the counters
dontKnow <- 0
notInterested <- 0
slightlyInterested <- 0
moderatelyInterested <- 0
veryInterested <- 0
extremelyInterested <- 0
total <- 0

#initialize category name
category_name <- NA

# basic loop that reads over category files
# and compute numbers
for (file in file_list){
  # print current file name
  print(file)
  
  # read current file content, with header
  dataFile <- read.csv(file, header = TRUE, encoding="UTF-8")
  
  # compute by interest level
  # create an empty data frame with only columns' names
  tmp <- data.frame("category" = character(0), "data_description" = character(0), "do_not_know" = integer(0),"not_interested_at_all" = integer(0), "slightly_interested" = integer(0), "moderately_interested" = integer(0), "very_interested" = integer(0), "extremely_interested" = integer(0), "total" = integer(0))
  
  for(i in 3:ncol(dataFile)){
    for(j in 1:nrow(dataFile)){
      if (dataFile[j,i] == interest_level[1]){
        dontKnow <- dontKnow + 1
      }else if (dataFile[j,i] == interest_level[2]){
        notInterested <- notInterested + 1
      }else if (dataFile[j,i] == interest_level[3]){
        slightlyInterested <- slightlyInterested + 1
      }else if (dataFile[j,i] == interest_level[4]){
        moderatelyInterested <- moderatelyInterested + 1
      }else if (dataFile[j,i] == interest_level[5]){
        veryInterested <- veryInterested + 1
      }else if (dataFile[j,i] == interest_level[6]){
        extremelyInterested <- extremelyInterested + 1
      }
    }
   
    # verify the total, should equal to the number of participants
    total <- sum(dontKnow, notInterested, slightlyInterested, moderatelyInterested, veryInterested, extremelyInterested)
    if(total != nrow(dataFile)){
      print("!TOTAL FALSE!")
      break
    }
    
    # identify each category name
    category_name <- switch(basename(file),
                           "1_swimmer_metadata.csv" = "swimmer_metadata", 
                           "2_time.csv" = "time",
                           "3_speed.csv" = "speed",
                           "4_distance.csv" = "distance",
                           "5_record.csv" = "record",
                           "6_technique.csv" = "technique",
                           "7_predictions.csv" = "predictions",
                           "8_external_data.csv" = "external_data")
    
    # write the data in a new row and add this row in to the data frame 
    tmp[nrow(tmp)+1,] = c(category_name, colnames(dataFile)[i], dontKnow, notInterested, slightlyInterested, moderatelyInterested, veryInterested, extremelyInterested, total)
    
    # clean all counters
    dontKnow <- 0
    notInterested <- 0
    slightlyInterested <- 0
    moderatelyInterested <- 0
    veryInterested <- 0
    extremelyInterested <- 0
    total <- 0
  }
  
  if ( !exists("allData") ){
    allData <- tmp
  } else {
    allData <- rbind(allData,tmp)
  }
  
}


# --------------------------------------- maintain don't know column ---------------------------------------------#


# calculate the median (same as below, except the column counts)
allData_median <- allData

for(k in 1:nrow(allData_median)){
  # create a vector which matches the interest_level with value from 1 to 5
  v <- integer()
  for (l in 1:5){
    v <- append(v, rep(l, as.numeric(allData_median[k,(l+3)])))
  }
  
  #write the median into data frame
  allData_median[k, "median"] <- median(v, na.rm = TRUE)
}


# print(allData)
# print(defaultpath)
setwd(defaultpath)
write.csv(allData_median, file="results/3_count/count_median.csv")


# calculate the mode of interest level per data
allData_mode <- allData_median

for(k in 1:nrow(allData_mode)){
  x <- as.numeric(allData_mode[k, 4:8])
  max_value <- max(x)
  mode <- character()
  for(m in 1: length(x)){
    if(x[m] == max_value){
      mode <- append(mode, switch (m,
                                   "not_interested_at_all",
                                   "slightly_interested",
                                   "moderately_interested",
                                   "very_interested",
                                   "extremely_interested"))
    }
  }
  
  for (n in 1:length(mode)){
    mode_name <- paste("mode", n, sep = "_")
    allData_mode[k, mode_name] <- mode[n]
  }
}

# print(allData)
# print(defaultpath)
setwd(defaultpath)
write.csv(allData_mode, file="results/3_count/count_median_mode.csv")


# --------------------------------------- remove don't know column ---------------------------------------------#


# print(allData)
# print(defaultpath)
setwd(defaultpath)
write.csv(allData, file="results/3_count/count_all.csv")

allData_without_dontKnow <- allData 

# rename the "total" column by "total_remove_dontKnow"
colnames(allData_without_dontKnow)[which(names(allData_without_dontKnow) == "total")] <- "total_remove_dontKnow"

# calculate the total valid answer: remove the column "I don't know"
for (k in 1:nrow(allData_without_dontKnow)){
  allData_without_dontKnow[k, "total_remove_dontKnow"] <- as.numeric(allData_without_dontKnow[k, "total_remove_dontKnow"]) - as.numeric(allData_without_dontKnow[k, "do_not_know"])
  print(allData_without_dontKnow[k,"total_remove_dontKnow"])
}

# remove the column "I don't know"
drop_columns <- c("do_not_know")
allData_without_dontKnow <- allData_without_dontKnow[,!(names(allData_without_dontKnow)%in%drop_columns)]

# print(allData)
# print(defaultpath)
setwd(defaultpath)
write.csv(allData_without_dontKnow, file="results/3_count/count_remove_dontKnow.csv")


# calculate the median per data
allData_without_dontKnow_median <- allData_without_dontKnow

for(k in 1:nrow(allData_without_dontKnow)){
  # create a vector which matches the interest_level with value from 1 to 5
  v <- integer()
  for (l in 1:5){
    v <- append(v, rep(l, as.numeric(allData_without_dontKnow_median[k,(l+2)])))
  }
  
  #write the median into data frame
  allData_without_dontKnow_median[k, "median"] <- median(v, na.rm = TRUE)
}


# print(allData)
# print(defaultpath)
setwd(defaultpath)
write.csv(allData_without_dontKnow_median, file="results/3_count/count_median_remove_dontKnow.csv")

# calculate the mode of interest level per data
allData_without_dontKnow_mode <- allData_without_dontKnow_median

for(k in 1:nrow(allData_without_dontKnow_mode)){
  x <- as.numeric(allData_without_dontKnow_mode[k, 3:7])
  max_value <- max(x)
  mode <- character()
  for(m in 1: length(x)){
    if(x[m] == max_value){
      mode <- append(mode, switch (m,
                                   "not_interested_at_all",
                                   "slightly_interested",
                                   "moderately_interested",
                                   "very_interested",
                                   "extremely_interested"))
    }
  }
  
  for (n in 1:length(mode)){
    mode_name <- paste("mode", n, sep = "_")
    allData_without_dontKnow_mode[k, mode_name] <- mode[n]
  }
}

# print(allData)
# print(defaultpath)
setwd(defaultpath)
write.csv(allData_without_dontKnow_mode, file="results/3_count/count_median_mode_remove_dontKnow.csv")

