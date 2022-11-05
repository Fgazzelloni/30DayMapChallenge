# ukraine war data
# https://data.humdata.org/

# unzip("data/ukr-border-crossings-090622-2.zip",exdir = "data/conflict")

library(sf)
library(tidyverse)
library(rgdal)
library(raster)
library(ggspatial)

# geodata
ykr <- raster::getData('GADM', country = "UKR", level = 1)

load("gadm36_UKR_1_sp.rds")
df <-gadm36_UKR_1_sp %>%st_as_sf()

rosm::osm.types()

quartz()
ggplot() +
   annotation_map_tile(type = "osm") +
   layer_spatial(df)
 ggsave("base_map.png")




#### extras #######
sf_data <- ykr %>% # class sp
   sf::st_as_sf() %>%
   st_transform(crs=4326)
ukr <- readOGR("data/conflict")
quartz()
ukr %>%
  as.data.frame() %>%
  janitor::clean_names() %>%
  ggplot(aes(long,lat,group=country))+
  annotation_map_tile(type = "osm") +
  geom_sf(data=sf_data,inherit.aes = F,fill=NA) +
  geom_text(aes(label=name_eng),check_overlap = T)+
  geom_point(aes(color=country),shape=21)+
  coord_sf(crs=4326)