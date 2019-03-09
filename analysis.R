#a6
# Read in race_data_2017.csv
library(jsonlite)
library(ggplot2)
library(dplyr)

race_data_2017 <- read.csv("data/race_data_2017.csv", stringsAsFactors = F)
race_data_2017 <- race_data_2017[1:10, ]

source("access_main_df.R")

# Tony's part of question
# this will be using only all_data for now
# idea: what's the most used calibers in all shootings /mass shootings
firearm_info <- all_data %>% 
  filter(!is.na(gun_type) & gun_type != "0::Unknown" & gun_type != "0:Unknown" ) %>%
  select(n_killed, n_injured, gun_type, n_guns_involved)

select_calibers <- function(string) {
  list <- gsub("::", "||", string) %>% 
    strsplit("||", fixed = TRUE) 
  list <- list[[1]][c(FALSE, TRUE)]
  list <- as.list(list)
}

firearm_info$gun_type_1 <- lapply(firearm_info$gun_type, select_calibers)

list <- firearm_info$gun_type_1 %>% 
  unlist() 
list <-  data.frame(caliber = list, stringsAsFactors = FALSE) %>% 
  filter(! caliber %in% c("Handgun", "Shotgun","Rifle" ,"Other", "Unknown")) %>% 
  filter(! caliber %>%  is.na)


list[list == "223 Rem [AR-15]"] <- "223 Rem"
list[list == "7.62 [AK-47]"] <- "7.62 * 39"

total_valid_occurence <- nrow(list)

caliber_occurence <- list %>% 
  group_by(caliber) %>% 
  mutate(count = n()) %>% 
  unique() %>% 
  arrange(-count) 
  
caliber_table <- table(list$caliber)
caliber_levels <- names(caliber_table)[order(caliber_table)]
list$caliber_2 <- factor(list$caliber, levels = caliber_levels)

list$caliber_3 <- with(list, reorder(caliber, caliber, function(x) -length(x)))

# example
# cyl_table <- table(mtcars$cyl)
# cyl_levels <- names(cyl_table)[order(cyl_table)]
# mtcars$cyl2 <- factor(mtcars$cyl, levels = cyl_levels) 

# ggplot(data = list, aes(factor(caliber_3))) +
#   geom_bar() +
#   theme(axis.text.x = element_text(angle = 70, hjust = 1))


  
# ggplot(data = caliber_occurence) +
#   geom_col(mapping = aes(x = caliber, y = count))


## Combined dataset
combined_race_and_state_dataset <- read.csv("data/combined_state_incidence_and_race_2017.csv")

small_2017_gun_incidence <- read.csv("data/2017_gun_incidence.csv")
small_2017_gun_incidents <- select(small_2017_gun_incidence, state, year, gun_type, n_killed, n_injured)

small_2017_gun_incidents <- small_2017_gun_incidents[1:10,]

## Wrangle dataset
total_data <- read.csv("data/all_gun_violence_filtered.csv")

total_data$date <- as.Date(total_data$date, "%m/%d/%Y")

total_data$year <- format(total_data$date,"%Y")

high_low_states <- total_data %>% 
  filter(state == "Florida" | state == "Hawaii") %>% 
  group_by(state)
  

summary_state <- count(high_low_states, year)

all_data <- read.csv("data/trimed_merged.csv")
colnames(summary_state)[3] <- "gun_violence"

write.csv(summary_state, "data/highest_lowest_state.csv", row.names = F)
