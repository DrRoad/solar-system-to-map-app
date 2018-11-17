#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       dateInput("date", "Date of observation"),
       textInput("startingLocationLat", "Latitude, e.g. 35.0992539", value = "35.0992539"),
       textInput("startingLocationLng", "Longitute, e.g. -115.7863069", value = "-115.7863069"),
       numericInput("kmPerAU", "How much should 1 AU be in km?", value = 0.5, min = 0.01, max = 10, step = 0.01),
       actionButton("submitValues", "Apply to map")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        leafletOutput("solarSystemMap")
    )
  )
))
