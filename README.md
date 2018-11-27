# The Solar System Mapper

##How to use the app:
The purpose of this app is to let anyone experience the scale of our solar system. Based on a geographical location chosen by the user, as well as a given date and scale, it calculates the positions of all planets (plus Pluto and the Sun) on the map as viewed from a bird's eye perspective. The user can set the following variables:

* Date of observation: Since the planets move, you must pick the date for which you would like to map the current positions of planets, as well as the Sun.
* Location of Earth: The Earth acts as a central starting point for mapping the planets around it. By setting the longitude and latitude variables, you can define where to start your celestrial exploration. As a default, a location in the Mojave Desert is selected.
* Scale: Distances in our Solar System are usually measured in AU (Astronomical Units). 1 AU is the average distance between the Sun and Earth, roughly 150 million km. By setting the slider on the left, you can decide how many kilometers 1 AU should represent. If you set this to 1, for example, the Sun will be placed about 1km away from Earth and Pluto will be placed about 30km away from it.

##Live Version
You can try out a live version of the app at https://pdwarf.shinyapps.io/solar-system-mapper/

##Ideas for further development
The following thoughts have crossed my mind, should I (or anyone, for that matter) ever continue to work on this app:
* A "play" button to see the planets move the +100 or so days from the chosen date
* Fixing the planets' size independent of the zoom level of the map viewer (like the behavior of a circleMarker in Leaflet) to get a "true" to-scale view of sorts
* Zooming in on Earth on app initialization (not that important)