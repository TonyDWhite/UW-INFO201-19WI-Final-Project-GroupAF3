#Final Project ui file

library("shiny")
library("ggplot2")
library("dplyr")


my_ui <- fluidPage(
  
  # Application title
  titlePanel(strong("Gun Violence in the United States")),
  
  # Sidebar Layout with radio button input to specify set of countries for the table tab and plots tab and a select input to specify column of measurement.
  sidebarLayout(
    
    sidebarPanel(
      
      radioButtons(inputId = "buttons", label = "Choose a set of Countries:", 
                   choices = list("Brazil, Peru, Bolivia", "Jamaica, Korea, Liberia", "Indonesia, Canada, Australia"), 
                   selected = "Brazil, Peru, Bolivia"),  
      
      # To add additional space in sidebar
      br(),  
      
      selectInput(inputId = "select_column", label = "Select Measurement:", choices = c("forested.area", "change_in_forest_percent_since_1993"), selected = "forested.area")
      
      
      
      
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs", 
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Table", titlePanel(em("Summarized Table of Dataset")), tableOutput("table"), textOutput("descriptionTable"))
      )
      
    )
  )
  
)
