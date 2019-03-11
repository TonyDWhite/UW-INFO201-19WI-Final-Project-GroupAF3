#Final Project ui file

library("shiny")
library("ggplot2")
library("dplyr")
#source("access_race_df.R")

my_ui <- fluidPage(
  
  # Application title
  titlePanel(strong("Gun Violence in the United States")),
  
  # Sidebar Layout with radio button input to specify set of countries for the table tab and plots tab and a select input to specify column of measurement.
  sidebarLayout(
    
    sidebarPanel(
  
      selectInput(inputId = "race", label = "Race", choices = c("White", "Black", "Hispanic", "Asian", selected = "Asian"))
      
      
      
      
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Table", textOutput("my_text"),tableOutput("my_table")),
                  tabPanel("Race", titlePanel(em("Race in each state and its relationship with Gun Related Crime")),
                           plotOutput("race_plot"),textOutput("race_text1"),br(),textOutput("race_text2"),br(),textOutput("race_text3"))
      
    )
  )
  )
)
