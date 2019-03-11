library(shiny)
library(dplyr)
library(ggplot2)

violence_by_states <- read.csv("../data/incidences_by_state.csv", stringsAsFactors = F)

state <- violence_by_states$state

ui <- fluidPage(
  titlePanel("Gun violence"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "state1", label = "State1",
                  choices = state, selected = state[1]),
      selectInput(inputId = "state2", label = "State2",
                  choices = state, selected = state[1])
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("Question: Is number of gun violence in the 2017 highest state 
         at least 10 times more than that of in the 2017 lowest state
         for all past 4 years?"),
      plotOutput("graph"),
      p("\nThis plot allows you to select two states from the drop-down lists
        and compares their total gun incidence numbers from 2014 to 2017."),
      p("For the highest and lowest states in 2017, Illnois indeed has at least
        10 times of gun incidences for all four years than Hawaii from 2013
        to 2017.")
    )
  )
)

server <- function(input, output) {
  
  chosen_state <- reactive({violence_by_states %>% 
    filter(state == input$state1 | state == input$state2)
  })
  
  output$graph <- renderPlot({
    ggplot(data = chosen_state()) +
      geom_col(mapping = aes(x = year, y = gun_violence, fill = state),
               position = "dodge")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
