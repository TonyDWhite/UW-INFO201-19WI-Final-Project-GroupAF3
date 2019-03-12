library("dplyr")
library("tidyr")

race_data <- read.csv("data/race_data_2017.csv", stringsAsFactors = FALSE)
state_total_incidence <- read.csv("data/state_total_incidence_2017.csv", stringsAsFactors = FALSE)
View(race_data)
race_data <- left_join(race_data,state_total_incidence,by = "Location")
#write.csv(state_total_incidence,file = "data/state_total_incidence_2017.csv")
#write.csv(race_data,file = "data/combined_state_incidence_and_race_2017.csv")

