#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(moonsun)
library(geosphere)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    observeEvent(input$submitValues, {
    planetNames <- c("sun", 
                     "mercury",
                     "venus",
                     "mars",
                     "jupiter",
                     "saturn",
                     "uranus",
                     "neptune",
                     "pluto")
    
    planetsAngles <- (-1) * (as.numeric(as.ecc(planets(show.moon = FALSE))$lat) - 360) #To get the top-down-view from the ecliptic north to south poles
    
    planetScale <- input$kmPerAU
    
    planetsDistances <- planets(show.moon = FALSE)$dist * planetScale * 1000
    
    startingLocationLng <- as.numeric(input$startingLocationLng)
    startingLocationLat <- as.numeric(input$startingLocationLat)
    
    newCoords <- destPoint(c(startingLocationLng, startingLocationLat), planetsAngles, planetsDistances)
    
    
  
    output$solarSystemMap <- renderLeaflet({
        leaflet() %>%
        addTiles() %>%
        addMarkers(lng = startingLocationLng, lat = startingLocationLat) %>%
        addMarkers(lng = newCoords[,1], lat = newCoords[,2], popup = planetNames)
  })
    })
})
