library(NISTunits)

AzimuthToXY <- function(azimuth, distance) {
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

coords <- map2_df(azimuth, distance, AzimuthToXY)
plot(coords)
text(x = coords$X, y = coords$Y, labels = planetNames, pos = 1)