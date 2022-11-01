# load packages
library(dplyr)
library(ggplot2)
library(rjson)
library(jsonlite)
library(leaflet)
library(RCurl)

interactive <- 
  leaflet() %>%
  #addTiles() %>%  # use the default base map which is OpenStreetMap tiles
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=12.493569397016822, lat=41.894753434569274,
             popup="The birthplace of R")



htmlwidgets::saveWidget(widget=interactive,
           file="interactive.html",
           selfcontained=TRUE)
