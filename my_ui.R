library(shiny)
features <- c("percentage_occurence", "ammo_sales_percentage", "ammo_price")
my_ui <- fluidPage(
  titlePanel("Gun Violence"),
  
  tabsetPanel(
    type = "tabs", 
    
    # tommy's part
    tabPanel(title = "Tommy",
             mainPanel(
               
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
               
               )
    ),
               
               
    # tony's part
    tabPanel(title = "Tony",
             fluidPage(
               titlePanel("Caliber(Ammo type) distribution"),
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
                                label = "Select Feature 1 (y-axis)",
                                choices = features,
                                selected = "ammo_sales_percentage"
                              )
                            ),
                            
                            mainPanel(
                              plotOutput("scatter_plot"),
                              textOutput("correlation")
                            )
                            
                          )# end of sidebarLayout
                 ),
                 
                 tabPanel("notes", htmlOutput("notes"))
               )#end of tabset
             )
    )# end of tony's part
    
  )
)
