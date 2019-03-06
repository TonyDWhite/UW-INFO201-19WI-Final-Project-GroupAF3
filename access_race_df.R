library("dplyr")
library("tidyr")

# This data contains data for all recorded gun violence incidents in the US between January 2013 and March 2018
# blancks are filled with NA
raw_data <- read.csv("data/trimed_merged.csv", stringsAsFactors = FALSE, na.strings=c("","NA"))

all_data <- raw_data

# remove raw data / I kept raw data for a line so I can use it when developing this script
rm(raw_data)

# convert date to date object


# add a year col because some analysis will be on year base
all_data <- all_data %>%  
  mutate(
    year = as.character(all_data$date) %>% 
      substring(5,8) %>% 
      as.numeric()
  )

# get all data from a certain year(s)
# param year should be numeric
get_year <- function(target_year) {
  all_data %>% filter(
    year == target_year
  )
}

all_data_2017 <- get_year(2017)

write.csv(all_data_2017,file = "data/2017_gun_incidence.csv")

all_data_2017 <- group_by(all_data_2017,state)

all_data_2017 <- mutate(all_data_2017,total_gun_incidence = n())
all_data_2017 <- unique(all_data_2017)
all_data_2017 <- arrange(all_data_2017,-total_gun_incidence)

View(all_data_2017)

state_total_incidence <- select(all_data_2017,state,total_gun_incidence)

state_total_incidence <- unique(state_total_incidence)

colnames(state_total_incidence)[1] <- "Location"
race_data <- read.csv("data/race_data_2017.csv", stringsAsFactors = FALSE)
race_data <- left_join(race_data,state_total_incidence,by = "Location")
write.csv(state_total_incidence,file = "data/state_total_incidence_2017.csv")
write.csv(race_data,file = "data/combined_state_incidence_and_race_2017.csv")
