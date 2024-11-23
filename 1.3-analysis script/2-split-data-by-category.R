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

filename <- "results/all_data.csv"
dataFile <- read.csv(filename)

#sort all data
sort_table <- dataFile[, c(swimmer_colnames, time_colnames, speed_colnames, distance_colnames, record_colnames, swimming_teachniques_colnames, predictions_colnames, external_data_colnames)]
write.csv(sort_table, file= "results/sort_data.csv")

# split data by category
# swimmer's info
swimmer_table <- dataFile[, c("participant_id",swimmer_colnames)]
write.csv(swimmer_table, file="results/2_category/1_swimmer_metadata.csv")

# time
time_table <- dataFile[, c("participant_id",time_colnames)]
write.csv(time_table, file="results/2_category/2_time.csv")

# speed
speed_table <- dataFile[, c("participant_id",speed_colnames)]
write.csv(speed_table, file="results/2_category/3_speed.csv")

# distance
distance_table <- dataFile[, c("participant_id",distance_colnames)]
write.csv(distance_table, file="results/2_category/4_distance.csv")

# record
record_table <- dataFile[, c("participant_id",record_colnames)]
write.csv(record_table, file="results/2_category/5_record.csv")

# technique
record_table <- dataFile[, c("participant_id",swimming_teachniques_colnames)]
write.csv(record_table, file="results/2_category/6_technique.csv")

# predictions
predictions_table <- dataFile[, c("participant_id",predictions_colnames)]
write.csv(predictions_table, file="results/2_category/7_predictions.csv")

# external data
external_data_table <- dataFile[, c("participant_id",external_data_colnames)]
write.csv(external_data_table, file="results/2_category/8_external_data.csv")

# other data
other_data_table <- dataFile[, c("participant_id",other_data_colnames)]
write.csv(other_data_table, file="results/2_supplemental/9_other_data.csv")

# general comment
general_comment_table <- dataFile[, c("participant_id", "general_comment")]
write.csv(general_comment_table, file="results/2_supplemental/10_general_comment.csv")

