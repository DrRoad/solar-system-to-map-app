library(moonsun)
library(geosphere)
library(leaflet)

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

planetsDistances <- planets(show.moon = FALSE)$dist

# 1 AU = 149,597,871 km; the maximum AU today (2018/11/13) is pluto at 33.25AU;
# to have this be 33.25km, the scale would be 1:149,597,871
planetScale <- 149597871 / 100 #interpreted as 1-to-whateverYouSetItTo

startingLocationLng <- 13.2040385
startingLocationLat <- 52.5316259 #random point in Spandau


newCoords <- destPoint(c(startingLocationLng, startingLocationLat), planetsAngles, planetsDistances)

m <- leaflet() %>%
    addTiles() %>%
    addMarkers(lng = startingLocationLng, lat = startingLocationLat) %>%
    addMarkers(lng = newCoords[,1], lat = newCoords[,2], popup = planetNames)
m

