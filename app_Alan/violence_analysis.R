## Analyze the question: Question: Is number of gun violence in the 2017 highest state 
##at least 10 times more than that of in the 2017 lowest state
## for all past 4 years?

violence_by_states <- read.csv("../data/incidences_by_state.csv", stringsAsFactors = F)

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
