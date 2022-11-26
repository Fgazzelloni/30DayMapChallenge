

library(leaflet)
library(leaflet.extras)
library(leaflet.providers)

fileid<- "d069b4c5-ec5b-c750-45aa-0a13f57dc35a"
  #Geographic Bounding Box
bbox<- c(174.064747966174,.345239694,-35.2867580621,-35.1399271488)
tile <- "http://tiles-{s}.data-cdn.linz.govt.nz/services;key=0661036048984cf88489c5930d0c2e98/tiles/v4/layer=NZ512501/EPSG:3857/{z}/{x}/{y}.png"

islands <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
  setView(174.1642,-35.22549,zoom=13) %>%
  addTiles() %>%
  # addProviderTiles(providers$Esri.NatGeoWorldMap,
  #                  options = providerTileOptions(opacity = 0.35))%>%
  addWMSTiles(
    "https://tiles-cdn.koordinates.com/services;key=0661036048984cf88489c5930d0c2e98/tiles/v4/layer=51306/EPSG:3857/{z}/{x}/{y}.png",
    layers = "51306",
    options = WMSTileOptions(format = "image/png", 
                             transparent = FALSE),
    attribution = "New Zealand Hydrographic Authority") %>%
 #addMarkers(
 #  label = "Default Label",
 #  labelOptions = labelOptions(noHide = T)) %>%
  addMeasure()%>%
  addMiniMap()
  
islands  


## load packages
library(htmlwidgets)
library(webshot)


## save html to png
saveWidget(islands, "temp.html", selfcontained = FALSE)
webshot("temp.html", file = "day26_islands.png",
        cliprect = "viewport")



library(cowplot)
ggdraw()+
  draw_image("day26_islands.png")+
  draw_label("Bay of Islands (NZ)",
             x=0.6,y=0.95) +
  draw_label("#30DayMapChallenge 2022 Day 26: Isalnds\nDataSource: New Zealand Hydrographic Authority | Graphics: @fgazzelloni",
             x=0.6,y=0.89,
             size=6) 

ggsave("day26_islands2.png")





