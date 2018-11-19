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

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Map the Solar System Around You"),
  
  #Sidebar layout with setting on the left and a map output to the right
  sidebarLayout(
    sidebarPanel(
       dateInput("date", "Date of observation"),
       textInput("startingLocationLat", "Latitude, e.g. 35.0992539", value = "35.0992539"),
       textInput("startingLocationLng", "Longitute, e.g. -115.7863069", value = "-115.7863069"),
       sliderInput("kmPerAU", "How much should 1 AU be in km?", value = 0.5, min = 0.01, max = 10, step = 0.01)
    ),
    
    # Show a map of the location of stars relative to earth on a give day, with earth being at your position
    mainPanel(
        tabsetPanel(
            tabPanel("mapPanel",
                     img(src="earth.png"),
                     leafletOutput("solarSystemMap")),
            tabPanel("dataPanel",
                     dataTableOutput("coordinatesDT"))
        )
    )
  )
))

# images:
#     earth: http://pngimg.com/download/25352
#     sun: http://pngimg.com/download/13424
#     mars: https://commons.wikimedia.org/wiki/File:3D_Mars.png
#     venus: https://commons.wikimedia.org/wiki/File:3D_Venus.png
#     uranus: https://commons.wikimedia.org/wiki/File:3D_Uranus.png
#     jupiter: https://commons.wikimedia.org/wiki/File:3D_Jupiter.png
#     mercury: https://commons.wikimedia.org/wiki/File:3D_Mercury.png
#     saturn: https://commons.wikimedia.org/wiki/File:3D_Saturn.png
#     neptune: https://commons.wikimedia.org/wiki/File:3D_Neptune.png
#     pluto: https://commons.wikimedia.org/wiki/File:3D_Pluto.png