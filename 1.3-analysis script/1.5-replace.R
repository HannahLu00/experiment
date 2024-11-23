library(plyr)
library(dplyr)
library(MPDiR)
library(quickpsy)
library(fitdistrplus)
library(ggplot2)
library(tibble)

# set directory where script is
sourceDir <- dirname (rstudioapi::getActiveDocumentContext()$path) 
defaultpath <- sourceDir

print(defaultpath)
setwd(defaultpath)

# read global values
source("1-read-and-bind-all-files.R")

filename <- "results/all_data.csv"
dataFile <- read.csv(filename)
class(dataFile) # data.frame

# replace text by weight => watching frequency
dataFile[dataFile == "No races / I don't follow this event."] <- 0
dataFile[dataFile == "Some races"] <- 1
dataFile[dataFile == "Almost all races"] <- 2
dataFile[dataFile == "All races"] <- 3

# replace text by weight => interested level
dataFile[dataFile == "I do not know. / I did not understand the question."] <- 0
dataFile[dataFile == "Not interested at all"] <- 1
dataFile[dataFile == "Slightly interested"] <- 2
dataFile[dataFile == "Moderately interested"] <- 3
dataFile[dataFile == "Very interested"] <- 4
dataFile[dataFile == "Extremely interested"] <- 5

watching_frequency_grade <- c()

for(i in 1:nrow(dataFile)){
  # calculate watching frequency grade == sum(race*frequency)
  temp <- as.numeric(dataFile[["olympics_frequency"]][i])*1 +
          as.numeric(dataFile[["international_frequency"]][i])*1 +
          as.numeric(dataFile[["continental_frequency"]][i])*1 +
          as.numeric(dataFile[["national_frequency"]][i])*1 +
          as.numeric(dataFile[["regional_frequency"]][i])*1
  watching_frequency_grade <- append(watching_frequency_grade, temp)
}

#print(watching_frequency_grade)

dataFile["watching_frequency_grade"] <- watching_frequency_grade

print(dataFile)

write.csv(dataFile, file="results/replaced.csv")