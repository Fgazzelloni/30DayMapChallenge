#30DayMapChallenge 2022 Day 8: OpenStreetMap
# Author: Federica Gazzelloni


# Set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Gideon Roman",
                family="Gideon Roman")


# load libraries for data manipulation
library(tidyverse)
# search for data
library(osmdata)
# Some important functions are: 
#   
# - getbb()             Get bounding box
# - opq()               Build an Overpass query
# - add_osm_feature()   Add a feature
# - osmdata_sf()        Return an object in sf format

location <- "Rome"
getbb(location)

# available_features()
feature <- "military"
available_tags(feature)

# military points
ms <- opq(c(12.23447,41.65564,12.85576,42.14103)) %>% 
  add_osm_feature (key = "military") %>%
  osmdata_sf (quiet = FALSE)

# save(ms,file="ms.RData")
load("ms.RData")
ms

# tutorial
# https://ggplot2tutor.com/tutorials/streetmaps
# https://joshuamccrain.com/tutorials/maps/streets_tutorial.html
# https://taraskaduk.com/posts/2021-01-18-print-street-maps/
streets <- opq(c(12.23447,41.65564,12.85576,42.14103)) %>% 
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) %>%
  osmdata_sf()
# save(streets,file="streets.RData")
load("streets.RData")
streets

small_streets <- opq(c(12.23447,41.65564,12.85576,42.14103)) %>% 
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "unclassified",
                            "service", "footway")) %>%
  osmdata_sf()
# save(small_streets,file="small_streets.RData")
load("small_streets.RData")
small_streets

river <- opq(c(12.23447,41.65564,12.85576,42.14103)) %>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()
# save(river,file="river.RData")
load("river.RData")
river


# make the map
# The latitude of Rome, Italy is 41.902782, and the longitude is 12.496366
ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          linewidth = .1,
          alpha = .8) +
  geom_sf(data = small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "navy",
          linewidth = .1,
          alpha = .8) +
  geom_sf(data = river$osm_lines,
          inherit.aes = FALSE,
          color = "#98c7d0",# "#33dbe7",
          linewidth = 1,
          alpha = .8) +
  geom_sf(data = ms$osm_points,
          inherit.aes = FALSE,
          color = "grey40",
          shape=21,
          stroke=0.1,
          size = 1,
          alpha = .8) +
  geom_sf(data = ms$osm_points,
          inherit.aes = FALSE,
          color = "red",
          size = 0.05,
          alpha = .8) +
  coord_sf(xlim=c(12.35,12.65),
           ylim=c(41.78,42),
           expand = FALSE) +
  theme_void()+
  theme(text=element_text(family="Gideon Roman"),
        plot.background = element_rect(fill="white",linewidth=0.5),
        panel.background = element_rect(fill="#dbd3c5",linewidth=1),
        plot.margin = margin(10,10,40,10,unit = "pt"))

# save the base map
ggsave("base_map.png", width = 6, height = 6)


# draw the map-viz
library(cowplot)

ggdraw()+
  draw_image("data/base_map.png")+
  draw_line(x=c(0.055,0.945),y=c(0.169,0.169),
            size=25,color="#dedede",alpha=0.7)+
  draw_line(x=c(0.3,0.7),y=c(0.22,0.22),
            size=1)+
  draw_label("Rome",
             x=0.5,y=0.19,
             size=14.5,
             fontface = "bold",
             fontfamily = "Gideon Roman")+
  draw_label("41.9027°N/12.4964°E",
             x=0.5,y=0.149,
             size=5,
             fontfamily = "Gideon Roman") +
  draw_label("OSM key: Military",
             x=0.5,y=0.125,
             size=4,
             fontfamily = "Gideon Roman") +
  draw_label("#30DayMapChallenge 2022 Day 8: osmdata\nDataSource: {osmdata}: Rome, Italy | Map: Federica Gazzelloni (@fgazzelloni)",
             x=0.5,y=0.07,
             size=4,
             lineheight = 1.8,
             fontfamily = "Gideon Roman")

# save final version
ggsave("day8_openstreetmap.png", 
       dpi=150,
       width = 5.8, 
       height = 6,
       bg="white")
