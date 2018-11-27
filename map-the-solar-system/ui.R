#Loading the required packages
library(shiny)
library(leaflet)

shinyUI(fluidPage(
  
  titlePanel("Solar System Mapper"),
  
  #Sidebar layout with setting on the left and a map output to the right
  sidebarLayout(
    sidebarPanel(
       dateInput("date", "Date of observation"),
       p(strong("Where should Earth be located?")),
       textInput("startingLocationLat", "Latitude", value = "35.0992539"),
       textInput("startingLocationLng", "Longitude", value = "-115.7863069"),
       sliderInput("kmPerAU", "How much should 1 AU be in km?", value = 0.5, min = 0.01, max = 10, step = 0.01),
       submitButton()
    ),
    
    # Show a map of the location of stars relative to earth on a give day, with Earth being at your position
    mainPanel(
        tabsetPanel(
            tabPanel("Instructions",
                HTML("<h4>How to use this app</h4>
                    <p>The purpose of this app is to let anyone experience the scale of our solar system. Based on a geographical location chosen by the user, as well as a given date and scale, it calculates the positions of all planets (plus Pluto and the Sun) on the map as viewed from a bird's eye perspective. The user can set the following variables:</p>
                     <ul>
                        <li><strong>Date of observation</strong><br>Since the planets move, you must pick the date for which you would like to map the current positions of planets, as well as the Sun.</li>
                        <li><strong>Location of Earth</strong><br>The Earth acts as a central starting point for mapping the planets around it. By setting the longitude and latitude variables, you can define where to start your celestrial exploration. As a default, a location in the Mojave Desert is selected.</li></li>
                        <li><strong>Scale</strong><br>Distances in our Solar System are usually measured in AU (Astronomical Units). 1 AU is the average distance between the Sun and Earth, roughly 150 million km. By setting the slider on the left, you can decide how many kilometers 1 AU should represent. If you set this to 1, for example, the Sun will be placed about 1km away from Earth and Pluto will be placed about 30km away from it.</li></li>
                     </ul>")
            ),
            tabPanel("Map",
                     leafletOutput("solarSystemMap")),
            tabPanel("Data",
                     dataTableOutput("coordinatesDT")),
            tabPanel("Acknowledgements",
                     HTML("<p>This app was inspired by the <a href=\"https://www.nationalgeographic.com/tv/mars/\">National Geographic TV show MARS</a>. In season 1, episode 2, young Ben Sawyer - one of the astronauts destined for Mars - goes out into the desert with his dad to place marbles on sticks, so that the marbles' size would match the size of the planets in our solar system and the distance between them would match the distance between the planets on the same scale. You can read more about this on <a href='https://t.co/DQyOFcNPVu'>Medium</a>. The code for this app is available on <a href='https://github.com/pdwarf/solar-system-to-map-app/tree/master/map-the-solar-system'>github</a>.</p>"),
                     img(src="https://github.com/pdwarf/solar-system-to-map-app/blob/master/map-the-solar-system/www/MARS_earth_marble.png?raw=true", width="600px"),
                     br(),
                     HTML("Images from the following sources were used:<br>
                          <ul>
                            <li>earth: http://pngimg.com/download/25352</li>
                            <li>sun: http://pngimg.com/download/13424</li>
                            <li>mars: https://commons.wikimedia.org/wiki/File:3D_Mars.png</li>
                            <li>venus: https://commons.wikimedia.org/wiki/File:3D_Venus.png</li>
                            <li>uranus: https://commons.wikimedia.org/wiki/File:3D_Uranus.png</li>
                            <li>jupiter: https://commons.wikimedia.org/wiki/File:3D_Jupiter.png</li>
                            <li>mercury: https://commons.wikimedia.org/wiki/File:3D_Mercury.png</li>
                            <li>saturn: https://commons.wikimedia.org/wiki/File:3D_Saturn.png</li>
                            <li>neptune: https://commons.wikimedia.org/wiki/File:3D_Neptune.png</li>
                            <li>pluto: https://commons.wikimedia.org/wiki/File:3D_Pluto.png</li>
                          </ul>")
                     )
        )
    )
  )
))