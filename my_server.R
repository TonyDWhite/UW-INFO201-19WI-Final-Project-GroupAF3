library(dplyr)
library(shiny)
library(jsonlite)
library(ggplot2)

# tony's part starts here
caliber_lsit <- read.csv("data/caliber_data.csv", stringsAsFactors = FALSE)

# factor to order in bar chart
caliber_table <- table(caliber_lsit$caliber)
caliber_levels <- names(caliber_table)[order(caliber_table)]
caliber_lsit$caliber_2 <- factor(caliber_lsit$caliber, levels = caliber_levels)
caliber_lsit$caliber_3 <- with(caliber_lsit, reorder(caliber, caliber, function(x) -length(x)))
rm(caliber_levels, caliber_table)

# bar chart
bar_chart <- ggplot(data = caliber_lsit, aes(factor(caliber_3))) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 70, hjust = 1))

# furthur analysis: 
# total number
total_number <- nrow(caliber_lsit)

#frequncy list
caliber_data <- caliber_lsit %>% 
  select(caliber) %>% 
  group_by(caliber) %>% 
  summarize(frequency = n()) %>% 
  arrange(-frequency) %>% 
  mutate(percentage_occurence = frequency / total_number * 100)
# sales data
# FROM: http://knowledgeglue.com/what-are-the-most-popular-calibers-in-the-us/
caliber_data$ammo_sales_percentage <- list(17.28, 9.82, 6.14, 4.47, 12.16,
                                           2.46, 14.67, 10.22, 3.87, 3.21,
                                           NA, NA, 1.49, 1.41, 0.96,
                                           NA, 4.46, 1.99, 6.14, NA,
                                           NA, NA) %>% 
  as.numeric()
# price data
# FROM: https://www.thefirearmblog.com/blog/2015/03/26/ammo-prices-03202015/
# us, lowest available, per 500 rounds, in $,
# a few NAs are filled with current price from ammo.com
caliber_data$ammo_price <- list(99.95, 50.93, 139.47, 164.98, 139.99,
                                165, 124, 120/1.06, 113.69, 225,
                                132.5/1.06, 160/1.06, 120/1.06, 295/1.06, 337.5/1.06,
                                230/1.06, 160/1.06, 241, 185/1.06, 219.8/1.06,
                                185, 179.8) %>% 
  as.numeric()




cor(caliber_data$ammo_price %>% as.vector(),
    y = caliber_data$ammo_sales_percentage %>% as.vector(),
    use = "pairwise.complete.obs")
# tony's part end here

# tommy's part starts here
us_map <- read.csv("data/map_data.csv", stringsAsFactors = FALSE)
#####################################################

my_server <- function(input, output) {
  
  # Tommy's part starts here
  output$my_map <- renderPlot(
    ggplot(data = us_map) +
      geom_polygon(aes(fill = bins, x = long, y = lat, group = group)) + theme_void() + coord_quickmap() +
      scale_fill_brewer(palette = "Set3") + labs(title = "Gun Violence By State", fill = "Number of Gun Related Criminal Incidents")
    
  )
  
  # tony's part starts here
  output$text_intro <- renderText(
    "This section shows data about the distribution of ammo types across
    shooting incidents, as well as a rough estimation of the correlation between such distribution and 
    sale/price of ammo in US."
  )
  
  #tab1 table
  output$text_table <- renderText(
    "The table below shows count and percentage of the distribution of ammo types across
    shooting incidents, as well as estimated sale/price data on these ammo types. one firearm of
    certain caliber used in an incedent is count as one entry (an incedent involving an .45 ACP
    pistol and an .233 Rem rifle would add one entry to EACH category)"
  )
  #TODO: add more on the text here; explain origin of data here!
  
  output$table <- renderTable(
    caliber_data
  )
  
  #tab2 bar chart
  output$text_bar_chart <- renderText(
    "The following bar chart shows amount of occurence of different calibers as used in shooting incidents"
  )
  
  output$bar_chart <- renderPlot(
    bar_chart
  )
  
  output$text_scatter_plot <- renderText(
    "The following reactive scatter plot plots two features (columns) of the table;  
    also provided is the corelation coefficient of the two features"
  )
  
  correlation <- reactive({
    cor <- cor(caliber_data[input$feature_1], caliber_data[input$feature_2], use = "pairwise.complete.obs")
    round(cor, 4)
  })
  
  output$scatter_plot <- renderPlot(
    scatter_plot()
  )
  
  output$correlation <- renderText(
    paste0("correlation between two chosen features is ", correlation())
  )
  
  scatter_plot <- reactive({
    feature_1 <- input$feature_1
    feature_2 <- input$feature_2
    ggplot(data = caliber_data) +
      geom_point(mapping = aes_string(x = feature_1, y= feature_2)) +
      labs(
        x = gsub("_", " ", feature_1),
        y = gsub("_", " ", feature_2)
      )
  })
  
  output$notes <- renderText(
    paste0(
      p("The data and analysis of this section shows how firearms using different ammo types are
        involved in shooting incidents. In the bar chart, it is unsurprising that the most used ammo type goes
        to 9mm (1st), as it is commonly considered the most popular ammo type in US civilian market as well as law 
        inforcement. It is also noticable that many of the more used ammo types are pistol rounds, with the exception 
        of .22 LR (2nd), which is consider a rifle round, which is also expected, as it is a very cheap and acquirable
        ammo type, commonly used in areas such as pest control and practice, and are used by both pistols and rilfes."),
      p("Also shown is the correlation between this distribution data and roughly how popular, 
        and accessible these ammo types are on US civilian markets. The correlation between sales amount and use in
        shooting incidents is about 0.7, which can be considered strong and is expected; where as the correlations between the price and
        occurance, and the price and sales amount are not as strong as what intuition may indicates. This might be explained by people's 
        initial purpose of posessing firearms that use certain ammos; for example, it's likely that if 40 SW and 38 Special are popular for 
        purpose of home defence, they might be used in more shooting incidents"),
      p("there might also have been errors caused by the loose collection of data. For lack of comprehensive data sets found online
        some prices are filled in with data from different sources, and thus might have caused errors"),
      p("price and sales data used in this section are concluded from: ", 
        p(a("www.ammo.com", href = "www.ammo.com")), 
        p(a("www.thefirearmblog.com", href = "https://www.thefirearmblog.com/blog/2015/03/13/ammo-prices-03122015/")), 
        p(a("www.luckygunner.com", href = "http://knowledgeglue.com/what-are-the-most-popular-calibers-in-the-us/"))
      )
      )
    )
  # Tony's part ends here
  #####################################################
  
  # Alan's part
  ##########################
  
  chosen_state <- reactive({violence_by_states %>% 
      filter(state == input$state1 | state == input$state2)
  })
  
  output$graph <- renderPlot({
    ggplot(data = chosen_state()) +
      geom_col(mapping = aes(x = year, y = gun_violence, fill = state),
               position = "dodge")
  })
  
}