library(shiny)
library(dplyr)
library(ggplot2)

source("violence_analysis.R")

#violence_by_states <- read.csv("../data/incidences_by_state.csv", stringsAsFactors = F)

state <- violence_by_states$state

high_state <- find_highest_state(2017)
low_state <- find_lowest_state(2017)
ratio_2014 <- round(find_incidence_ratio(high_state, low_state, 2014))
ratio_2015 <- round(find_incidence_ratio(high_state, low_state, 2015))
ratio_2016 <- round(find_incidence_ratio(high_state, low_state, 2016))
ratio_2017 <- round(find_incidence_ratio(high_state, low_state, 2017))


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
      h3("Question: Is the number of gun violence in the 2017 highest state 
         at least 10 times more than that of in the 2017 lowest state
         for all past 4 years?"),
      plotOutput("graph"),
      p("\n", strong("Description:"), "This plot allows you to select two states from the drop-down lists
        and compares their total gun incidence numbers side-by-side from 2014 to 2017."),
      p("Through this plot, you might notice that the numbers can be 
        significantly different between some of the states. As for our
        question of comparing the highest and lowest states in 2017,
        which will be ", high_state , " and ", low_state, " the former 
        indeed has at least 10 times of gun incidences for all four years
        than the latter from 2013 to 2017. In fact, the actual analysis shows
        that the numbers for ", high_state, " is ", ratio_2014, "%, ",
        ratio_2015, "%, ", ratio_2016, "%, ", ratio_2017, "%, more than
        the ", low_state, " for 2014 to 2017 respectively. This proves
        that some regions in the U.S. are significantly more dangerous
        than other regions. In your opinion, What do you think might be
        the reason behind the great difference in gun violence numbers
        between these two states?")
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
