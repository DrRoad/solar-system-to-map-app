#Load all required libraries
library(shiny) #duh
library(leaflet) #for creating the map output
library(lubridate) #for stripping apart the date of observation and feeding it into the planets() function
library(moonsun) #for data on the positions of the planets in our solar system
library(geosphere) #for calculating where the planets should be mapped to the earth, provided a scale
library(data.table) #for providing the data.table output of the "raw" data that one can go out and use in a geocaching-esque way
library(readbitmap) #for getting the planet icons' dimensions, mainly so that saturn does not get squashed into a square
library(Hmisc) #For text operations

shinyServer(function(input, output) {
    #Defining constants in the beginning
    AU <- 149597871 # this is one Astronomical Unit in km, which is based the average distance between Earth and the Sun.
    planetNames <- c("sun", #I acknowledge that the Sun is not actually a planet, but a star. :) 
                     "mercury",
                     "venus",
                     "mars",
                     "jupiter",
                     "saturn",
                     "uranus",
                     "neptune",
                     "pluto")
    
    planetsOriginalSize <- 2 * c(695508, 2439.7, 6051.8, 3396.2, 71492, 60268, 25559, 24764, 1195)  #Source: NASA, radii converted to diameter in km, Earth has a radius of 6378.1
    earthOriginalSize <- (6378.1 * 2)
    planetImages <- paste("www/", planetNames, ".png", sep="") #Pointing to the location of image files and constructing files names to be used as icons for map markers later on.
    
    imageDims <- function(images) { #This constructs a function that can be used to get the width and height dimensions of a list of images, provided a filepath.
        height <- NULL
        width <- NULL
        for(image in images) {
        height <- c(height, dim(read.bitmap(image))[1])
        width <- c(width, dim(read.bitmap(image))[2])
        }
        data.frame(height, width)
    }
    
    planetImageDims <- imageDims(planetImages) #Applying the above function to get the dimensions of the planet icons / images.
    
    planetIconsHeight <- .02 * log(planetsOriginalSize) * planetImageDims$height #No auto-scaling here and I am also refraining from keeping sizes proportional, because this is not feasable using leaflet markers - the Sun is 100 times bigger than earth, for example; If you want to go out and map the planets to the world around you, check the data panel for properly scaled sizes in cm
    planetIconsWidth <-  .02 * log(planetsOriginalSize) * planetImageDims$width
    
    planetIcons <- icons(iconUrl = planetImages, iconHeight = planetIconsHeight, iconWidth = planetIconsWidth)
    earthIcon <- icons(iconUrl = "www/earth.png", iconHeight = .02 * log(earthOriginalSize) * 120, iconWidth = .02 * log(earthOriginalSize) * 120)
    
    makePlanetPopups <- function(name, image, size, scaledSize, distance, scaledDistance) {
                        paste("<strong>",
                            capitalize(name),
                          "</strong> <br> <img src=\"",
                            image,
                          "\" height = 92px><br>Actual diameter in km: ",
                          size,
                          "<br>Scaled size in cm: ",
                          scaledSize,
                          "<br>Actual distance in AU: ",
                          distance,
                          "<br>Scaled distance in m: ",
                          scaledDistance, sep = "")
    }
    
    #Now, onto reactive values that can get set in the sidepanel by the user
    observationDate <- reactive({as.Date(input$date)}) #This is needed to show how the planets are positioned on a given date
    planetScale <- reactive({as.numeric(input$kmPerAU)}) #This is taking in the scale that the user wants to use to map the solar system to Earth's surface, in km per AU
    
    planetsAngles <- reactive({(-1) * (as.numeric(as.ecc(planets(jday = jd(year = year(observationDate()), month = month(observationDate()), day = day(observationDate())), show.moon = FALSE))$lat) - 360)}) #This is getting the "angles", i.e. longitude variable from the planets() function call in the moonsun package. There seems to be an error in the output of the package, as I am having to grab the $lat variable to actually get the longitude in the eclicptic coordinate system; the "* (-1), - 360" part is to get the top-down-view, so from celestrial north to south, instead of south to north.
    planetsDistances <- reactive({planets(jday = jd(year = year(observationDate()), month = month(observationDate()), day = day(observationDate())), show.moon = FALSE)$dist * planetScale() * 1000}) #Grabbing the distances in AU from the planets() function call and converting them to meters, as the destPoint() function takes meters as input.
    planetsDistanceAU <- reactive({planets(jday = jd(year = year(observationDate()), month = month(observationDate()), day = day(observationDate())), show.moon = FALSE)$dist})
    
    planetsScaledSize <- reactive({round(((planetsOriginalSize * 1000 * 100) / AU) * planetScale(), digits = 2)}) #converting km to m and then to cm
    earthScaledSize <- reactive({round(((6378.1 * 2 * 1000 * 100) / AU) * planetScale(), digits = 2)}) #see above, but for Earth seperately
    
    planetPopups <- reactive({mapply(makePlanetPopups, planetNames, paste(planetNames, ".png", sep = ""), planetsOriginalSize, planetsScaledSize(), planetsDistanceAU(), planetsDistances(), USE.NAMES = FALSE)}) #Create the popups for the planets and the Sun
    earthPopup <- reactive({paste("<strong>Earth</strong><br><img src = \"earth.png\"><br>Actual diameter in km: ", earthOriginalSize,"<br>Scaledd size in cm: ", earthScaledSize())})
    
    startingLocationLng <- reactive({as.numeric(input$startingLocationLng)}) #This is where Earth will be located, as the solar system will be mapped with Earth as its starting position.
    startingLocationLat <- reactive({as.numeric(input$startingLocationLat)})
    
    newCoords <- reactive({destPoint(c(startingLocationLng(), startingLocationLat()), planetsAngles(), planetsDistances())}) #This calculates the coordinates of where to place the planets on the map with respect to the Earth.
    
    dataTab <- reactive({data.table(Planet = capitalize(planetNames), #This constructs a table of all data that is necessary to then go out into the world and place the planet models, as well as to know what size the models to build; you should probably refrain from building a to-scale model of the sun, as it will necessarily be huge, no matter what scale you choose.
                                    Longitude = newCoords()[,1], 
                                    Latitude = newCoords()[,2], 
                                    "Distance in AU" = planetsDistances() / (1000 * planetScale()), 
                                    "Diameter in km" = planetsOriginalSize, 
                                    "Scaled distance in m" = planetsDistances(), 
                                    "Scaled size in cm" = planetsScaledSize()) %>%
            rbind(list("Earth", startingLocationLng(), startingLocationLat(), NA, 2 * 6378.1, NA, earthScaledSize()))
            })
                
    output$solarSystemMap <- renderLeaflet({ #Rendering the actual map
        leaflet() %>%
        addTiles() %>%
        addMarkers(lng = startingLocationLng(), lat = startingLocationLat(), label = "Earth", icon = earthIcon, popup = earthPopup()) %>%
        addMarkers(lng = newCoords()[,1], lat = newCoords()[,2], label = capitalize(planetNames), popup = planetPopups(), icon = planetIcons)
    })
    
    output$coordinatesDT <- renderDataTable({ #Rendering the table with all the required data
        dataTab()
    })
})
