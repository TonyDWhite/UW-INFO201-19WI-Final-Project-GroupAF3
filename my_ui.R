my_ui <- fluidPage(
  tabsetPanel(
    type = "tabs", 
    
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