#TODO:
# - Add acknowledgements
# - Add popups to map markers
# - Publish


#Loading the required packages
library(shiny)
library(leaflet)

shinyUI(fluidPage(
  
  titlePanel("The solar system around you"),
  
  #Sidebar layout with setting on the left and a map output to the right
  sidebarLayout(
    sidebarPanel(
       dateInput("date", "Date of observation"),
       p(strong("Where should Earth be located?")),
       textInput("startingLocationLat", "Latitude", value = "35.0992539"),
       textInput("startingLocationLng", "Longitude", value = "-115.7863069"),
       sliderInput("kmPerAU", "How much should 1 AU be in km?", value = 0.5, min = 0.01, max = 10, step = 0.01)
    ),
    
    # Show a map of the location of stars relative to earth on a give day, with Earth being at your position
    mainPanel(
        tabsetPanel(
            tabPanel("Instructions",
                HTML("<h4>How to use this app</h4>
                    <p>The purpose of this app is to let anyone experience the scale of our solar system. Based on a location chosen by the user, as well as a given date and scale measure, it calculates the positions of all planets, plus Pluto and the Sun as viewed from a bird's eye perspective. The user can set the following variables:</p>
                     <ul>
                        <li><strong>Date of observation</strong><br>Since the planets move, you must pick the date for which you would like to map the current positions of planets, as well as the Sun.</li>
                        <li><strong>Location of Earth</strong><br>The Earth acts as a central starting point for mapping the planets around it. By setting the longitude and latitude variables, you can define where to start your celestrial exploration. As a default, a location in the Mojave Desert is selected.</li></li>
                        <li><strong>Date of observation</strong><br>Since the planets move, you must pick the date for which you would like to map the current positions of planets, as well as the Sun. By default, this date will be today's date.</li></li>
                        <li><strong>Scale</strong><br>Distances in our Solar System are usually measured in AU (Astronomical Units). 1 AU is the average distance between the Sun and Earth, roughly 150 million km. By setting the slider on the left, you can decide how many kilometers 1 AU should represent. If you set this to 1, for example, the Sun will be placed about 1km away from earth and Pluto will be placed about 30km away from it.</li></li>
                     </ul>")
            ),
            tabPanel("Map",
                     leafletOutput("solarSystemMap")),
            tabPanel("Data",
                     dataTableOutput("coordinatesDT")),
            tabPanel("Acknowledgements",
                     HTML("<p>This app was inspired by the National Geographic TV show MARS. In season 1, episode 2, young Ben Sawyer - one of the astronauts destined for Mars - goes out into the desert with his dad to place marbles on sticks, so that the marbles' size would match the size of the planets in our solar system and the distance between them would match the distance between the planets on the same scale. You can read more about this on <a href='https://medium.com/p/a5f7f010ffac/'>Medium</a>. The code for this app is available on <a href='https://github.com/pdwarf/solar-system-to-map-app/tree/master/map-the-solar-system'>github</a>.</p>") #Add images and thanks to packages' authors here.
                     )
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