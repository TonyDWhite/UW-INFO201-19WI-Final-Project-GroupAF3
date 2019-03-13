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