#Final Project my_server file
library("shiny")
library("ggplot2")
library("dplyr")
source("my_ui_aaron.R")
race_data <- read.csv("data/combined_state_incidence_and_race_2017.csv",stringsAsFactors = FALSE)
#View(race_data)
my_server <- function(input, output){
  
  output$race_plot <- reactive(
    output$race_plot <- renderPlot(
      ggplot(data = race_data) +
        geom_point(mapping = aes_string(x = "total_gun_incidence", y = input$race, color = "total_gun_incidence")
        )
      
    )
    
  )
  
  output$race_text1 <- renderText(
    p <- "This graph shows the correlation between race and gun related crime in each state. Race appears to be a relatively small factor in the gun crime rate. "
    
  )
  
  output$race_text2 <- renderText(
    p2 <- "When looking at the Gun Crime data, there are a lot more explicit and implicit factors that we fail to consider outside of race. For instance, states like Illinois and Florida have staggering large amount of gun crime in the nation. And only analyzing the race data does not help to reach a clear, concise conclusion. We need to take in consideration of the local community, government funding, police enforcement, and many other issues happening within particular communities with high gun crime numbers to fully understand the problem.  "
    
  )
  
  output$race_text3 <- renderText(
    p <- "The ultimate reason that we chose to look at race and its relationship with gun crime is to clarify that race does not play a significant role, if at all, in this urgent issue. We do not intend to make any connections. Furthermore, it is important to realize that correlation does not imply causation and we should carefully screen and think about the data being presented to us. 
"
  )

}