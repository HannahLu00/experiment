library(plyr)
library(dplyr)
library(MPDiR)
library(quickpsy)
library(fitdistrplus)
library(ggplot2)

# set directory where script is
sourceDir <- dirname (rstudioapi::getActiveDocumentContext()$path) 
defaultpath <- sourceDir

#remove(list = ls())
print(defaultpath)
setwd(defaultpath)

# rename the columns
participants_colnames <- c("participants_gender", "participants_gender_other", "participants_age_range", "participants_living_region", "participants_living_region_other")
frequency_colnames <- c("olympics_frequency", "international_frequency", "continental_frequency", "national_frequency", "regional_frequency")
other_race_colnames <- c("other_race_name_1", "other_race_frequency_1", "other_race_name_2", "other_race_frequency_2", "other_race_name_3", "other_race_frequency_3", "other_race_name_4", "other_race_frequency_4", "other_race_name_5", "other_race_frequency_5")
background_colnames <- c("have_seen_moving_info")

swimmer_colnames <- c("nationality_interest", "name_interest", "age_interest", "gender_interest", "height_interest", "weight_interest")
time_colnames <- c("elapsed_time_interest", "lap_time_difference_to_other_swimmers_interest", "average_lap_time_interest", "current_lap_time_interest", "lap_time_difference_to_a_record_interest")
speed_colnames <- c("speed_difference_to_other_swimmers_interest", "speed_differences_to_a_record_interest", "current_speed", "average_speed", "history_of_speed", "speed_related_events")
distance_colnames <- c("distance_swam", "remaining_distance", "distance_difference_to_leader", "trace_of_movement", "side_by_side_distance")
record_colnames <- c("world_record", "competition_record", "national_record", "personal_record")
swimming_teachniques_colnames <- c("distance_per_stroke", "reaction_time", "diving_distance", "stroke_count")
predictions_colnames <- c("next_passing", "record_break", "winner", "estimation_completion_time")
external_data_colnames <- c("social_media_followers", "social_media_by_swimmer", "sponsor")
other_data_colnames <- c("other_data_name_1", "other_data_interest_1", "other_data_name_2", "other_data_interest_2","other_data_name_3", "other_data_interest_3", "other_data_name_4", "other_data_interest_4", "other_data_name_5", "other_data_interest_5", "other_data_name_6", "other_data_interest_6", "other_data_name_7", "other_data_interest_7", "other_data_name_8", "other_data_interest_8", "other_data_name_9", "other_data_interest_9", "other_data_name_10", "other_data_interest_10", "other_data_name_11", "other_data_interest_11", "other_data_name_12", "other_data_interest_12", "other_data_name_13", "other_data_interest_13", "other_data_name_14", "other_data_interest_14", "other_data_name_15", "other_data_interest_15", "other_data_name_16", "other_data_interest_16", "other_data_name_17", "other_data_interest_17", "other_data_name_18", "other_data_interest_18", "other_data_name_19", "other_data_interest_19", "other_data_name_20", "other_data_interest_20")
# bind all names
new_colnames <- c(participants_colnames, frequency_colnames, other_race_colnames, background_colnames, swimmer_colnames, time_colnames, speed_colnames, distance_colnames, record_colnames, swimming_teachniques_colnames, predictions_colnames, external_data_colnames, other_data_colnames)

# interest level
interest_level <- c("I do not know. / I did not understand the question.", "Not interested at all", "Slightly interested", "Moderately interested", "Very interested", "Extremely interested")

# watching frequency
watching_frequency <- c("No races / I don't follow this event.", "Some races", "Almost all races" , "All races")
# frequency grades
frequency_grades <- c(0, 1, 2, 3)
# race ranking
race_ranking <- c(5, 4, 3, 2, 1)
# interesting ranking
interest_ranking <- c(0, 1, 2, 3, 4, 5)

# read all files
setwd("exp-data/")
file_list <- list.files(pattern=".csv")
show(file_list)

if (exists ("allData")) { rm(allData) }

# basic loop that reads over participant files
# and rename the useful columns
for (file in file_list){
  # print .csv file name
  print(file)
  
  # read .csv file content, with header
  dataFile <- read.csv(file, header = TRUE, encoding="UTF-8")
  
  # print the number of columns and number of rows of the .csv file
  print(ncol(dataFile))
  print(nrow(dataFile))
  print(colnames(dataFile))
  
  # collect all data in one .csv file in order to bind them in to one file
  tmp <- dataFile
  
  # rename ID column
  colnames(tmp)[1] <- "participant_id"
  
  
  # rename the useful columns
  for(i in 9:106){
    print(i)
    colnames(tmp)[i] <- new_colnames[i-8]
    print(colnames(tmp)[i])
  }
  
  # rename general comments column
  colnames(tmp)[107] <- "general_comment"
  
  if ( !exists("allData") ){
    allData <- tmp
  } else {
    allData <- rbind(allData,tmp)
  }
}

print(defaultpath)
setwd(defaultpath)
write.csv(allData, file="results/all_data.csv")

