library(dplyr)
library(tidyr)

## Wrangle dataset
total_data <- read.csv("data/all_gun_violence_filtered.csv", stringsAsFactors = F)

total_data$date <- as.Date(total_data$date, "%m/%d/%Y")

total_data$year <- format(total_data$date,"%Y")

# data 2017

data_2017 <- total_data %>% 
  filter(year == 2017) %>% 
  select(state)

data_2017 <- count(data_2017, state)

data_2017 <- arrange(data_2017, -n)

colnames(data_2017)[2] <- "gun_violence"

write.csv(data_2017, "data/state_total_incidence_2017.csv", row.names = F)

## Create data for the gun violence each year for 
## highest and lowest states in 2017
high_low_states <- total_data %>% 
  filter(state == "Illinois" | state == "Hawaii") %>% 
  group_by(state)

summary_state <- count(high_low_states, year)

colnames(summary_state)[3] <- "gun_violence"

summary_state <- summary_state %>% 
  filter(year != 2018)


write.csv(summary_state, "data/highest_lowest_state.csv", row.names = F)

## Create data for the gun violence each year for 
## all states
all_states <- total_data %>% 
  group_by(state)

summary_all_states <- count(all_states, year)

colnames(summary_all_states)[3] <- "gun_violence"

summary_all_states <- summary_all_states %>% 
  filter(year != 2018 & year != 2013)

write.csv(summary_all_states, "data/incidences_by_state.csv", row.names = F)

## Analyze the question: Question: Is number of gun violence in the 2017 highest state 
##at least 10 times more than that of in the 2017 lowest state
## for all past 4 years?

find_highest_state <- function(year_num) {
  data_year <- summary_all_states %>% 
    filter(year == year_num)
  
  highest <- data_year[data_year$gun_violence == max(data_year$gun_violence), ]
  
  highest$state
}

find_lowest_state <- function(year_num) {
  data_year <- summary_all_states %>% 
    filter(year == year_num)
  
  lowest <- data_year[data_year$gun_violence == min(data_year$gun_violence), ]
  
  lowest$state
}

find_incidence_ratio <- function(state1, state2, year_num) {
  data_year <- summary_all_states %>% 
    filter(year == year_num, (state == state1 | state == state2)) %>% 
    arrange(-gun_violence)
  
  data_year[1, "gun_violence"] / data_year[2, "gun_violence"]
}

find_incidence_ratio(find_highest_state(2017), find_lowest_state(2017), 2017)
