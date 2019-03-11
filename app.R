#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library("shiny")
library("ggplot2")
source("my_ui_aaron.R")
source("my_server_aaron.R")

shinyApp(ui = my_ui, server = my_server)

