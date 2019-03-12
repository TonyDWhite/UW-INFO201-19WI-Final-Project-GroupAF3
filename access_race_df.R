library("dplyr")
library("tidyr")

race_data_raw <- read.csv("data/race_data_2017.csv", stringsAsFactors = FALSE)
state_total_incidence <- read.csv("data/state_total_incidence_2017.csv", stringsAsFactors = FALSE)
#View(race_data)
race_data <- left_join(race_data_raw,state_total_incidence,by = "Location")
#write.csv(state_total_incidence,file = "data/state_total_incidence_2017.csv")
#write.csv(race_data,file = "data/combined_state_incidence_and_race_2017.csv")

us_map <- read.csv("data/map_data.csv", stringsAsFactors = FALSE)

#View(race_data_raw)

race_data_raw$Location <- tolower(race_data_raw$Location)

colnames(race_data_raw)[colnames(race_data_raw) == "Location"] <- "region"

race_map <- left_join(us_map,race_data_raw,by = "region")

#write.csv(race_map,file = "data/race_map_2017.csv")
