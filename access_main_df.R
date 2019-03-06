library("dplyr")
library("tidyr")

# This data contains data for all recorded gun violence incidents in the US between January 2013 and March 2018
# blancks are filled with NA
raw_data <- read.csv("data/trimed_merged.csv", stringsAsFactors = FALSE, na.strings=c("","NA"))

all_data <- raw_data

# remove raw data / I kept raw data for a line so I can use it when developing this script
rm(raw_data)

# convert date to date objects
all_data$date <- all_data%>% 
  pull(date) %>% 
  as.Date("%m/%d/%Y")

# add a year col because some analysis will be on year base
all_data <- all_data %>%  
  mutate(
    year = as.character(all_data$date) %>% 
      substring(1,4) %>% 
      as.numeric()
    )

# get all data from a certain year(s)
# param year should be numeric
get_year <- function(target_year) {
  all_data %>% filter(
    year == target_year
  )
}


