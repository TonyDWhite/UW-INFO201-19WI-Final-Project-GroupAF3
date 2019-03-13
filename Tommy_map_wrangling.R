# Set-Up: Loading packages for data wrangling

library(maps)
#install.packages("ggmap")
library(ggmap)
library(tidyr)
library(dplyr)

# Creating a data frame called united_states containing the map data for the United States 
# from the maps R package.
united_states <- map_data("state")

# Reading in our downloaded dataset on gun related criminal incidents to be able to join the united_states
# map dataframe with our gun incidents dataframe.
gun_incidents <- read.csv("data/state_total_incidence_2017.csv", stringsAsFactors = FALSE)

# Replacing the column name of the column containing state names in the gun incidents data frame to match the column
# name containing state names in the united_states data frame so that I can join by that column.
colnames(gun_incidents)[1] <- "region"

# Changing the strings within the region column in gun_incidents to lower case to match the united_states data frame
# for joining purposes.
gun_incidents$region <- tolower(gun_incidents$region)

# Joining my data frames to render my map in our shiny app.
map_data <- full_join(united_states, gun_incidents, by = "region")

# Creating bins so that I can have a categorical color scheme within my map.
united_states_final_bins <- mutate(map_data, bins = cut(map_data$gun_violence, breaks = c(70, 1000, 2000, 3000, 4000, 5000, Inf), 
                                                        labels = c("70-1000", "1001-2000", "2001-3000", "3001-4000", "4001-5000", "5000+")))

# Selecting the rows including only the states with values which can be mapped. Basically filtering out NA values.
united_states_map_data <- united_states_final_bins[1:15537, ]
write.csv(united_states_map_data, "data/map_data.csv", row.names = FALSE)
