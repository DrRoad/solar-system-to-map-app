library(moonsun)
library(NISTunits)
library(geosphere)
library(leaflet)

# use files obtained from here https://omniweb.gsfc.nasa.gov/coho/helios/planet.html in SE coordinates ...

planetNames <- c("sun", 
                 "moon",
                 "mercury",
                 "venus",
                 "mars",
                 "jupiter",
                 "saturn",
                 "uranus",
                 "neptune",
                 "pluto")
planetsAzimuth <- as.numeric(as.hoc(planets())[,1])
planetsDistance <- planets()$dist

# 1 AU = 149,597,871 km; the maximum AU today (2018/11/13) is pluto at 33.25AU;
# to have this be 33.25km, the scale would be 1:149,597,871
planetScale <- 149597 #interpreted as 1-to-whateverYouSetItTo
startingLocation <- data.frame(long=13.2040385, lat=52.5316259)#random point in Spandau
options(latitude = startingLocation$lat, longitude = startingLocation$long)

planetsData <- data.frame(p.name = planetNames, 
                          p.az = planetsAzimuth, 
                          p.dist = planetsDistance * (149597871 / planetScale))



AzimuthToXY <- function(azimuth, distance) { #Turns out I don't need this function, b/c geosphere::destPoint is just what I needed... keeping for sentimental reasons.
        if(azimuth > 0 && azimuth < 90) {
            Y = sin(NISTdegTOradian(azimuth)) * distance
            X = cos(NISTdegTOradian(azimuth)) * distance
        }
        else if(azimuth == 90) {
            Y = distance
            X = 0
        }
        else if(azimuth > 90 && azimuth < 180) {
            Y = sin(NISTdegTOradian(azimuth - 90)) * distance
            X = -1 * cos(NISTdegTOradian(azimuth - 90)) * distance
        }
        else if(azimuth == 180) {
            Y = 0
            X = distance
        }
        else if(azimuth > 180 && azimuth < 270) {
            Y = -1 * sin(NISTdegTOradian(azimuth - 180)) * distance
            X = -1 * cos(NISTdegTOradian(azimuth - 180)) * distance
        }
        else if(azimuth == 270) {
            Y = -1 * distance
            X = 0
        }
        else if(azimuth > 270 && azimuth < 360) {
            Y = -1* sin(NISTdegTOradian(-1 * azimuth + 360)) * distance
            X = cos(NISTdegTOradian(-1 * azimuth + 360)) * distance
        }
        else if(azimuth == 360 | azimuth == 0) {
            Y = 0
            X = distance
        }
        return(data.frame(X, Y))
} 

#plotData <- map2_df(planetsData$p.az, planetsData$p.dist, AzimuthToXY) ... see above ... :-(

newCoords <- destPoint(startingLocation, planetsData$p.az, planetsData$p.dist)

m <- leaflet() %>%
    addTiles() %>%
    addMarkers(lng = startingLocation$long, lat = startingLocation$lat) %>%
    addMarkers(lng = newCoords[,1], lat = newCoords[,2], popup = planetsData$p.name)
m