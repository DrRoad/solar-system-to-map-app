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
library(lubridate)
library(moonsun)
library(geosphere)
library(data.table)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    planetNames <- c("sun", 
                     "mercury",
                     "venus",
                     "mars",
                     "jupiter",
                     "saturn",
                     "uranus",
                     "neptune",
                     "pluto")
    
    #To get the top-down-view from the ecliptic north to south poles
    observationDate <- reactive({as.Date(input$date)})
    planetScale <- reactive({as.numeric(input$kmPerAU)})
    
    planetsAngles <- reactive({(-1) * (as.numeric(as.ecc(planets(jday = jd(year = year(observationDate()), month = month(observationDate()), day = day(observationDate())), show.moon = FALSE))$lat) - 360)})
    planetsDistances <- reactive({planets(jday = jd(year = year(observationDate()), month = month(observationDate()), day = day(observationDate())), show.moon = FALSE)$dist * planetScale() * 1000})
    planetsSize <- 2 * c(695508, 2439.7, 6051.8, 3396.2, 71492, 60268, 25559, 24764, 1195) # Source: NASA, radii converted to diameter
        #Earth	6378.1
    
    startingLocationLng <- reactive({as.numeric(input$startingLocationLng)})
    startingLocationLat <- reactive({as.numeric(input$startingLocationLat)})
    
    newCoords <- reactive({destPoint(c(startingLocationLng(), startingLocationLat()), planetsAngles(), planetsDistances())})
    
    output$solarSystemMap <- renderLeaflet({
        leaflet() %>%
        addTiles() %>%
        addMarkers(lng = startingLocationLng(), lat = startingLocationLat(), label = "earth") %>%
        addMarkers(lng = newCoords()[,1], lat = newCoords()[,2], label = planetNames)
    })
    
    output$coordinatesDT <- renderDataTable({
        data.table(Planet = planetNames, Longitude = newCoords()[,1], Latitude = newCoords()[,2], "Distance in AU" = planetsDistances() / ( 1000 * planetScale()), "Diameter in km"  = planetsSize)
    })
})
