library(shiny)

# Tony's
features <- c("percentage_occurence", "ammo_sales_percentage", "ammo_price")

# Alan's
source("violence_analysis.R")
state <- violence_by_states$state

high_state <- find_highest_state(2017)
low_state <- find_lowest_state(2017)
ratio_2014 <- round(find_incidence_ratio(high_state, low_state, 2014))
ratio_2015 <- round(find_incidence_ratio(high_state, low_state, 2015))
ratio_2016 <- round(find_incidence_ratio(high_state, low_state, 2016))
ratio_2017 <- round(find_incidence_ratio(high_state, low_state, 2017))


#Aaron's 
race_data <- read.csv("data/combined_state_incidence_and_race_2017.csv",stringsAsFactors = FALSE)
x_range <- range(race_data$gun_violence)

my_ui <- fluidPage(
  titlePanel("Gun Violence"),
  
  tabsetPanel(
    type = "tabs", 
    # Aaron's Introduction
    tabPanel(title = "Introduction",
             mainPanel(
               h3("Introduction"),
               p("The ability to possess guns is something that we take special pride of as the citizens of the U.S. 
                  Guns are used for many reasons from self defense to hunting. 
                  This ability also comes with its costs. 
                  It becomes easy for criminal to purchase and use guns. "),
               p("Gun Violence in the United States is becoming more and more apparent year after year. 
                  It has become common to hear about a brand new mass shooting or tragedy involving gun use. 
                  There are gun related crimes happening on a daily basis in many parts of the country."),
               p("For this reason, we decided to focus our research on identifying areas of the United States experiencing large amounts of gun affiliated criminal incidents. 
                  We will examine many factors about gun violence and try to reach a conclusion based on the data used. 
                  By doing so, we hope to draw attention to these areas experiencing this terrifying trend of gun use in our nation 
                  so that our audience can understand where these incidents are occurring and maybe even be inspired to vote or act in a way that helps to mitigate gun use. ")
             )),
    # Alan's part
    tabPanel(title = "Highest vs Lowest Rates of Gun Violence",
             titlePanel("Each State's Gun Violence Distribution"),
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "state1", label = "State1",
                             choices = state, selected = high_state),
                 selectInput(inputId = "state2", label = "State2",
                             choices = state, selected = low_state)
               ),
               
               # Show a plot of the generated distribution
               mainPanel(
                 tabsetPanel(
                   type = "tabs",
                   tabPanel(
                     title = "Bar charts",
                     h3("Critical Question: Is the number of gun violence in the 2017 highest state 
                        at least 10 times more than that of in the 2017 lowest state
                        for all past 4 years?"),
                     plotOutput("graph"),
                     p("\n", strong("Description:"), "This plot allows you to select two states from the drop-down lists
                       and compares their total gun incidence numbers side-by-side from 2014 to 2017."),
                     p("Through this plot, you might notice that the numbers can be 
                       significantly different between some of the states. As for our
                       question of comparing the highest and lowest states in 2017,
                       which will be ", paste0(high_state, " and ", low_state, ", "), "the former 
                       indeed has at least 10 times of gun incidences for all four years
                       than the latter from 2013 to 2017. In fact, the actual analysis shows
                       that the numbers for ", paste0(high_state, " is ", ratio_2014, "%, ",
                                                      ratio_2015, "%, ", ratio_2016, "%, ", ratio_2017, "% "), "more than
                       the numbers for ", low_state, " for 2014 to 2017 respectively. This proves
                       that some regions in the U.S. are significantly more dangerous
                       than other regions. In your opinion, what do you think might be
                       the reason behind the great difference in gun violence numbers
                       between these two states?")
                    )
                  )
               )
          )
    ),
    # tommy's part
    tabPanel(title = "Geographic Distribution of Gun Violence",
             tabsetPanel(
               type = "tabs",
               
               tabPanel("Map", 
                        h3("Critical Analysis Question: Where are gun-related criminal incidents concentrated in the United States?"),
                        plotOutput("my_map"),
                        p("\n", strong("Analysis:"), "The map above depicts the range of gun-related crimes in 2017 that each state within the United States falls under. A color scheme was used to represent
                          which range of criminal incidents corresponds to each state. Therefore, this makes it easy to see which states have the highest number of gun-related criminal incidents. This map
                          serves to answer the critical analysis question posed previously in the following way."),
                        p("Upon viewing the map, you can see that Florida, Illinois, and California experience the highest number of
                          gun-related crimes as they are filled with the colors corresponding to the highest numbers of gun violence. In contrast, states like Washington, Oregon, and Montana exprience the lowest numbers of gun-related criminal incidents
                          as they are filled with colors representing lower rates of gun violence."),
                        p("After viewing this map, I thought to myself that I would not want to live in the places
                          experiencing the highest rates of gun violence, however I remembered that there are many other factors about the issue of gun violence and crime that my map fails to consider. For example, population density could
                          affect the number of crimes in general simply due to the fact there are more people and potentially more criminals in the area, also my results might change if different years were also considered.
                          Therefore my map doesn't necessarily imply which states are safer than others. I felt it was important to include and think about this concept.")
                        
                        
               ),
               
               tabPanel("Map Data", 
                        h3("Map Dataset"),
                        tableOutput("map_table"),
                        p("\n", "The table above includes a summarized version of the data I used to render the geographic distribution of gun violence within ggplot. This visualization is included on the Map tab."))
               

               
               )
    ),
               
               
    # tony's part
    tabPanel(title = "Caliber Distribution",
             fluidPage(
               h3("Distributions of firearm calibers(ammo type) in shooting incidents, and how is this distribution influenced 
                  by civilian market sales and price of these ammos"),
               textOutput("text_intro"),
               
               tabsetPanel(
                 type = "tabs", 
                 tabPanel("Table", textOutput("text_table"), 
                          textOutput("text_table_help"),
                          tableOutput("table")
                 ),#table
                 
                 tabPanel("Bar Chart", textOutput("text_bar_chart"), plotOutput("bar_chart") ),#bar_chart
                 
                 tabPanel("Reactive Scatter Plot", 
                          #reactive scatter plot
                          sidebarLayout(#explanation, select features
                            sidebarPanel(
                              textOutput("text_scatter_plot"),
                              
                              selectInput(#feature_1
                                inputId = "feature_1",
                                label = "Select Feature 1 (x-axis)",
                                choices = features,
                                selected = "percentage_occurence"
                              ),
                              selectInput(#feature_2
                                inputId = "feature_2",
                                label = "Select Feature 2 (y-axis)",
                                choices = features,
                                selected = "ammo_sales_percentage"
                              )
                            ),
                            
                            mainPanel(
                              plotOutput("scatter_plot"),
                              htmlOutput("correlation")
                            )
                            
                          )# end of sidebarLayout
                 ),
                 
                 tabPanel("Notes", htmlOutput("notes"))
               )#end of tabset
             )
    ),# end of tony's part
    
    
    #Aaron's Part Starts here
    tabPanel(
      title = "Racial Distribution",
      fluidPage(
        # Application title
        titlePanel(h3("Gun Violence in the United States and its Relationship with Race")),
        
        # Sidebar Layout with radio button input to specify set of countries for the table tab and plots tab and a select input to specify column of measurement.
        sidebarLayout(
          
          sidebarPanel(
            
            selectInput(inputId = "race", label = "Race", choices = c("White", "Black", "Hispanic", "Asian", selected = "Asian")),
            
            br(),
            sliderInput("n",
                        "Range:",
                        min = x_range[1],
                        max = x_range[2],
                        value = x_range)
            
            
            
            
            
          ),
          
          mainPanel(
            
            tabsetPanel(type = "tabs",
                        tabPanel("Race", titlePanel(h3("Race in each state and its relationship with Gun Related Crime")),
                                 plotOutput("race_plot"),textOutput("race_text1"),br(),textOutput("race_text2"),br(),textOutput("race_text3")),
                        tabPanel("Table", titlePanel(h3("Race and Gun Violence Data Table")), tableOutput("race_table"))
                        
            )
          )
        )
      )
    ),
    
    #Tommy's Conclusion
    tabPanel(title = "Conclusion",
             mainPanel(
               h3("Summary"),
               p("\n", "In summation, Gun Violence is one of the most prominent issues in the nation today. 
                 Gun-related criminal incidents are on the rise in the United States and show no sign of slowing down. 
                 As you have now seen, there are a multitude of concepts and facets to this issue of Gun Violence."),
               p("The first of these concepts we introduced was the highest vs the lowest rates of gun violence in 
                 user-selected countries across multiple years. This was shown in the form of a bar chart comparing two 
                 specified countries and color coding each bar measurement to allow the user to be able to discern which bar 
                 represented which country. Next we displayed the geographic distribution of gun violence by rendering a map 
                 within our shiny app which categorized each state by the number of gun-related criminal incidents in 2017. This
                 allows the user to be able to visualize where gun violence was concentrated across the United States in 2017."),
               p("Our third concept dealt with the relationship between gun calibers and gun-related crimes. More specifically,
                 we visualized which calibers of guns are most frequently used in these tragic gun violence events through the use of a bar chart.
                 Moreover, we presented the relationship between ammo sales and the percentage of gun related criminal occurences in the form of an
                 interactive scatter plot. The fourth and final facet on the issue of Gun Violence we discussed was the relationship between race and
                 gun violence. We sought to explain to our viewers the correlation between race and gun violence, and/or whether a correlation existed between the two at all
                 (we specifically analyzed White Americans, African Americans, Hispanic Americans, and Asian Americans)"),
               p("Overall, we hope our audience has learned a lot about the issue of Gun Violence in the United States, and is inspired to encourage change so that our nation
                 can become a place of peace where we no longer have to hear so often about a new tragedy involving guns."),
               p("GitHub Project Repo: https://github.com/TonyDWhite/UW-INFO201-19WI-Final-Project-GroupAF3")
               )
             
    )
    
  )
)
