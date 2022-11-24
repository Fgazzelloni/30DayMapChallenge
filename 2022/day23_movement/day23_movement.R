#30DayMapChallenge 2022 Day 23: Movement
# Author: Federica Gazzelloni


# source: https://data.world/iom/b8e28bd0-8bcb-47a5-bc90-775562d944a4/workspace/file?filename=2017-flows-to-europe-overview-dataset-3.xlsx

library(tidyverse)
library(sf)

# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Averia Libre",
                family="Averia Libre")

library(readxl)
X2017 <- read_excel("R_general_resources/30DayMapChallenge/2022/day23_movement/data/2017-flows-to-europe-overview-dataset-3.xlsx", 
                    sheet = "Origin Nationalites ITA-GRC-ESP")                 
                    
world <- rnaturalearthdata::countries110                    
italy <- world_geo_data%>%
  filter(sovereignt=="Italy")

data <- X2017%>%
  janitor::clean_names() %>%
  left_join(world_geo_data,by=c("iso3_of_origin"="sov_a3"))


arrivals <- data%>%
  group_by(iso3_of_origin) %>%
  summarize(arrivals=sum(cumulative_arrivals))

data1 <- merge(arrivals,data) %>%
  st_as_sf()


data_centroids <- data%>%
  st_as_sf()%>%
  st_centroid()

italy_centroid <- world_geo_data%>%
  filter(sovereignt=="Italy")%>%
  st_centroid()


# ggplot(world_geo_data)+
#   geom_sf()+
#   geom_sf(data=data,aes(geometry=geometry,color=iso3_of_origin),
#           show.legend = F) +
#   geom_sf(data= data1_centroids)


start_coords <- data_centroids%>%
  st_coordinates()%>%
  as.data.frame()%>%
  filter(!X=="NaN")

end_coords <- italy_centroid%>%
  st_coordinates()%>%
  as.data.frame()


df <- cbind(start_coords,end_coords)

names(df)<- c("lon_st","lat_st","lon_en","lat_en")
df%>%head  


en <- df %>%
  st_as_sf(coords=c("lon_en","lat_en"),crs=4326)%>%
  st_geometry()

st <- df %>%
  st_as_sf(coords=c("lon_st","lat_st"),crs=4326)%>%
  st_geometry()


# st_connect(st,en)%>%
#   ggplot()+
#   geom_sf()

lines <- st_connect(st,en)
st_bbox(world_geo_data)

library(scico)
ggplot(world_geo_data)+
  geom_sf(fill="grey90",alpha=0.2)+
  geom_sf(data=italy,fill="#c15a4f")+
  geom_sf(data=data1,aes(geometry=geometry,
                         fill=arrivals,
                         color=iso3_of_origin),
          linewidth=0.1,
          show.legend = T) +
  guides(color="none",alpha="none") +
  geom_sf(data= data1_centroids,
          aes(color=iso3_of_origin),
          size=0.05,
          show.legend = FALSE)+
  geom_sf(data=lines,
          linewidth=0.01,
          color="white")+
  coord_sf(xlim = c(-170,170),ylim = c(-80,80)) +
  #scale_alpha_binned()+
  scico::scale_color_scico_d(begin=0,end = 1)+
  scico::scale_fill_scico(begin=0,end = 1,
                          #alpha=0.5,
                          palette = "lisbon",
                          direction = 1)+
  labs(title="Movements to Europe through the Mediterranean and Western Balkans migration routes",
       subtitle="2017 flows: Italy overview",
       fill="Arrivals",
       caption="#30DayMapChallenge 2022 Day 23: Movement\nDataSource: @humdata | Map: Federica Gazzelloni (@fgazzelloni)")+
  ggthemes::theme_map() +
  theme(text=element_text(family="Averia Libre"),
        plot.title = element_text(vjust = 2),
        plot.caption = element_text(lineheight = 1.1,vjust = 2),
        legend.background = element_blank(),
        legend.position = c(0.05,0.1))


ggsave("day23_movement.png",
       bg="#89a5b9",
       width = 8.22,
       height = 5.26,
       dpi=280)





