#30DayMapChallenge 2022 Day 12: Scale
# Author: Federica Gazzelloni

#####
library(leaflet)
hurricanecolors <- RColorBrewer::brewer.pal(12,"Paired")
 
  leaflet(atlStorms2005) %>%
  addTiles %>%
  addPolylines(color = hurricanecolors,opacity=.8) %>%
  addLegend(colors = rep(hurricanecolors,2),labels = atlStorms2005$Name,
            title = "Tropical Storms of 2005",bins =24)

######## ######## ######## ######## ######## ######## ######## 

library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
# leaflet.extras::
library(leaflet.providers)
leaflet.providers::get_providers()
leaflet.providers::providers_loaded()
leaflet.providers::use_providers(get_providers("1.4.0"))

df <-atlStorms2005%>%as.data.frame()
centroids <- atlStorms2005%>%
  st_as_sf()%>%
  as.data.frame()




df2 <- atlStorms2005%>%
  st_as_sf()%>%
  st_centroid()%>%
  st_coordinates()%>%
  unique()%>%
  cbind(df)%>%
  mutate(X=as.numeric(X),Y=as.numeric(Y),
         log_press=log10(MinPress),
         MaxWind=as.numeric(MaxWind),
         MinPress=as.numeric(MinPress))

scaleBarOptions(
  maxWidth = 100,
  metric = TRUE,
  imperial = TRUE,
  updateWhenIdle = TRUE
)

df2%>%
  st_as_sf(coords=c(1,2))%>%
  st_centroid()


pal <- leaflet::colorNumeric(palette = "Y10rRd",
                             domain = df2$MaxWind)
map_leaflet <- leaflet(df2,
        options = leafletOptions(zoomControl = FALSE,maxZoom = 10)) %>%
  setView(lng =-47.4, lat =  39.75 , zoom = 10) %>%
  addTiles() %>%
  addProviderTiles("OpenTopoMap") %>%
  addPolylines(lng = ~X,lat = ~Y,
               color = hurricanecolors,opacity=.8) %>%
  addLegend(colors = rep(hurricanecolors,2),labels = atlStorms2005$Name,
            title = "Tropical Storms of 2005",bins =24) %>%
  addCircles(lng = ~X,lat=~Y,
             radius = ~ MaxWind^log_press/10, 
             stroke = T,
             weight = ~log_press^1,
             color="navy") %>%
  addScaleBar( options = scaleBarOptions())%>%
  addLegend(pal = pal, 
            values = ~MaxWind,
            opacity = 0.5,
            position = "bottomright")

library(htmlwidgets)
library(htmltools)
saveWidget(map_leaflet, file="day12_scale.html")


