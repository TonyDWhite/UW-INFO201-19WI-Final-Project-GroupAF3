library(dplyr)

## Wrangle dataset
total_data <- read.csv("data/all_gun_violence_filtered.csv")

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
  filter(state == "Florida" | state == "Hawaii") %>% 
  group_by(state)

summary_state <- count(high_low_states, year)

all_data <- read.csv("data/trimed_merged.csv")
colnames(summary_state)[3] <- "gun_violence"

write.csv(summary_state, "data/highest_lowest_state.csv", row.names = F)