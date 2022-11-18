#30DayMapChallenge 2022 Day 18: Color Friday Blue
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

location <- "Milan"
getbb(location)
# min      max
# x  9.040887  9.27811
# y 45.386738 45.53585

available_features()
feature <- "religion"
available_tags(feature)

# military points
ms <- opq(c(9.040887,45.386738,9.27811,45.53585)) %>% 
  add_osm_feature (key = feature) %>%
  osmdata_sf (quiet = FALSE)

# save(ms,file="data/ms.RData")
load("ms.RData")
ms

# tutorial
# https://ggplot2tutor.com/tutorials/streetmaps
# https://joshuamccrain.com/tutorials/maps/streets_tutorial.html
# https://taraskaduk.com/posts/2021-01-18-print-street-maps/
streets <- opq(c(9.040887,45.386738,9.27811,45.53585)) %>% 
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) %>%
  osmdata_sf()
# save(streets,file="data/streets.RData")
load("data/streets.RData")
streets

small_streets <-  opq(c(9.040887,45.386738,9.27811,45.53585)) %>% 
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "unclassified",
                            "service", "footway")) %>%
  osmdata_sf()
# save(small_streets,file="data/small_streets.RData")
load("small_streets.RData")
small_streets

river <- opq(c(9.040887,45.386738,9.27811,45.53585)) %>% 
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

# save(river,file="data/river.RData")
load("river.RData")
river


# make the map
# The latitude of Rome, Italy is 41.902782, and the longitude is 12.496366
ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "#7b9aca",
          linewidth = .04,
          alpha = .8) +
geom_sf(data = small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "navy",
          linewidth = .03,
          alpha = .8) +
  geom_sf(data = river$osm_lines,
          inherit.aes = FALSE,
          color = "#bfd0dd",# "#33dbe7",
          linewidth = 1.5,
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
          color = "#043c6e",
          size = 0.05,
          alpha = .8) +
    # (9.040887,45.386738,9.27811,45.53585)
  coord_sf(xlim=c(9.040887,9.27811),
           ylim=c(45.386738,45.53585),
           expand = FALSE) +
  theme_void()+
  theme(text=element_text(family="Gideon Roman"),
        plot.background = element_rect(fill="white",color="#043c6e",linewidth=0.5),
        panel.background = element_rect(fill="white",color="#043c6e",linewidth=1),
        plot.margin = margin(10,10,40,10,unit = "pt"))#dbd3c5

# save the base map
ggsave("base_map.png", width = 6, height = 6)


# draw the map-viz
library(cowplot)

ggdraw()+
  draw_image("base_map.png")+
  draw_line(x=c(0.03,0.97),y=c(0.169,0.169),
            size=20,color="#bfd0dd",alpha=0.5)+
  draw_line(x=c(0.3,0.7),y=c(0.22,0.22),
            size=1,color="#043c6e")+
  draw_label("Milan",
             x=0.5,y=0.19,
             size=14.5,
             color="#043c6e",
             fontface = "bold",
             fontfamily = "Gideon Roman")+
  draw_label("45°27'52.7904''N / 9°11'18.7440''E",
             x=0.5,y=0.149,
             color="#043c6e",
             size=5,
             fontfamily = "Gideon Roman") +
  draw_label("OSM key: Religion",
             x=0.5,y=0.125,
             color="#043c6e",
             size=4,
             fontfamily = "Gideon Roman") +
  draw_label("#30DayMapChallenge 2022 Day 18: Color Friday Blue\nDataSource: {osmdata}: Milan, Italy | Map: Federica Gazzelloni (@fgazzelloni)",
             x=0.5,y=0.07,
             size=4,
             color="#043c6e",
             lineheight = 1.8,
             fontfamily = "Gideon Roman")

# save final version
ggsave("day8_openstreetmap.png", 
       dpi=180,
       width = 5.6, 
       height = 5.6,
       bg="white")
