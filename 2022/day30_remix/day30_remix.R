#30DayMapChallenge 2022 Day 30: Remix
# Author: Federica Gazzelloni


# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Poor Story",family="Poor Story")

library(leaflet)
# library(leaflet.extras)
# library(leaflet.providers)

# fileid<- "d069b4c5-ec5b-c750-45aa-0a13f57dc35a"
#Geographic Bounding Box
# bbox<- c(174.064747966174,.345239694,-35.2867580621,-35.1399271488)


library(tidyverse)
library(rgdal)
library(sf)
# Department of Conservation (DOC) - Campsites. Dataset shows all campsites.
# https://catalogue.data.govt.nz/dataset/doc-campsites3
shp <- readOGR("data/DOC_Campsites")

plot(shp)
shp%>%View
shp@proj4string
shp@data%>%
  ggplot()+
  geom_point(aes(x,y))
  
df <- shp@data %>%
  st_as_sf(coords=c("x","y"),
           crs="+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0
+units=m +no_defs") %>%
  sf::st_transform(crs = "+proj=longlat +datum=WGS84")  %>%
  tibble() 


df1 <- shp@data %>%
  st_as_sf(coords=c("x","y"),
           crs="+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0
+units=m +no_defs") %>%
  sf::st_transform(crs = "+proj=longlat +datum=WGS84")  %>%
  st_coordinates() %>%
  bind_cols(df) 


df2<- df1%>%
  mutate(dogs=ifelse(dogsAllowe=="No dogs","no","yes"),
         .after=Y)

df1%>%View
table(df2$dogs)
table(df2$campsiteCa)

getColor <- function(df2) {
  sapply(df2$dogs, function(dogs) {
    ifelse(dogs == "yes","green","red")})
    }

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(df2)
)




tile <- "http://tiles-{s}.data-cdn.linz.govt.nz/services;key=0661036048984cf88489c5930d0c2e98/tiles/v4/layer=NZ512501/EPSG:3857/{z}/{x}/{y}.png"

islands_mixup <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
  # -35.20870804, 174.22736660.
  setView(174.22736660,-35.20870804,zoom=14) %>%
  addTiles() %>%
  # addProviderTiles(providers$Esri.NatGeoWorldMap,
  #                  options = providerTileOptions(opacity = 0.35))%>%
  addWMSTiles(
    "https://tiles-cdn.koordinates.com/services;key=0661036048984cf88489c5930d0c2e98/tiles/v4/layer=51306/EPSG:3857/{z}/{x}/{y}.png",
    layers = "51306",
    options = WMSTileOptions(format = "image/png", 
                             transparent = FALSE),
    attribution = "New Zealand Hydrographic Authority") %>%
  addAwesomeMarkers(lng = df2$X,
                    lat = df2$Y, 
                    icon=icons) %>%
  addMeasure()%>%
  addMiniMap()

islands_mixup  


## load packages
library(htmlwidgets)
library(webshot)


## save html to png
saveWidget(islands_mixup, "temp.html", selfcontained = FALSE)
webshot("temp.html", file = "data/islands_mixup.png",
        cliprect = "viewport")



library(cowplot)
ggdraw()+
  draw_image("data/islands_mixup.png")+
  draw_line(x=c(0,0.99),y=c(0.89),
            alpha=0.4,
            color="grey95",size=20)+
  draw_label("Capm sites in Urupukapuka Island no dogs allowed",
             x=0.5,y=0.95,
             fontface = "bold",
             fontfamily = "Poor Story") +
  draw_label("#30DayMapChallenge 2022 Day 30: Mixup\nDataSource: New Zealand Hydrographic Authority & data.govt.nz | Graphics: @fgazzelloni",
             x=0.5,y=0.90,
             lineheight = 1.2,
             fontfamily = "Poor Story",
             size=5) 

ggsave("day30_remix.png",
       dpi=200,
       width = 6.83,
       height =5.26 )





