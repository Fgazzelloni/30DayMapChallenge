#30DayMapChallenge 2022 Day 6: Network
# Author: Federica Gazzelloni

# Load libraries
# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Noto Serif",
                family="Noto Serif")


# Subways in NY: load packages and data
# https://cran.r-project.org/web/packages/tidytransit/vignettes/frequency.html
# install.packages('tidytransit')
library(tidytransit)
library(tidyverse)
library(sf)

# other resources: 
# https://stackoverflow.com/questions/34316083/need-to-display-u-s-metro-areas-on-a-map

local_gtfs_path <- system.file("extdata", "google_transit_nyc_subway.zip", package = "tidytransit")

########  ######## ########  ######## ########  ######## ########  ######## 
# The following piece of code is from {tidytransit} vignette ########
# Import Transit Data (GTFS)
# read it/set the service/make it as sf
# this must be done in three steps
gtfs <- read_gtfs(local_gtfs_path)
gtfs <- set_servicepattern(gtfs)
gtfs <- gtfs_as_sf(gtfs)

# build a vector with spatial lengths
gtfs$shapes$length <- st_length(gtfs$shapes)

shape_lengths <- gtfs$shapes %>% 
  as.data.frame() %>% 
  select(shape_id, length, -geometry)



service_pattern_summary <- gtfs$trips %>%
  left_join(gtfs$.$servicepatterns, by="service_id") %>% 
  left_join(shape_lengths, by="shape_id") %>%
  left_join(gtfs$stop_times, by="trip_id") %>% 
  group_by(servicepattern_id) %>% 
  summarise(trips = n(), 
            routes = n_distinct(route_id),
            total_distance_per_day_km = sum(as.numeric(length), 
                                            na.rm=TRUE)/1e3,
            route_avg_distance_km = (sum(as.numeric(length), 
                                         na.rm=TRUE)/1e3)/(trips*routes),
            stops=(n_distinct(stop_id)/2))


service_pattern_summary <- gtfs$.$dates_servicepatterns %>% 
  group_by(servicepattern_id) %>% 
  summarise(days_in_service = n()) %>% 
  left_join(service_pattern_summary, by="servicepattern_id")


service_ids <- gtfs$.$servicepattern %>% 
  filter(servicepattern_id == 's_e25d6ca') %>% 
  pull(service_id)

am_stop_freq <- get_stop_frequency(gtfs, 
                                   start_time = 6*3600, 
                                   end_time = 10*3600, 
                                   service_ids = service_ids, 
                                   by_route = TRUE)

one_line_stops <- am_stop_freq %>% 
  filter(route_id == 1 & direction_id == 0) %>%
  left_join(gtfs$stops, by ="stop_id") %>% 
  mutate(mean_headway_minutes = mean_headway/60)


one_line_stops_sf <- gtfs$stops %>%
  right_join(one_line_stops, by="stop_id") 


routes_sf <- get_route_geometry(gtfs, service_ids = service_ids)

am_route_freq <- get_route_frequency(gtfs, 
                                     service_ids = service_ids, 
                                     start_time = 6*3600, 
                                     end_time = 10*3600)
routes_sf <- routes_sf %>% 
  inner_join(am_route_freq, by = 'route_id')

########  ######## ########  ######## ########  ######## ########  ######## 
# convert to an appropriate coordinate reference system
routes_sf_crs <- sf::st_transform(routes_sf, 4326) 


# first output
routes_sf_crs %>% 
  filter(median_headways < 10*60) %>%
  ggplot() + 
  geom_sf(aes(color=as.factor(median_headways)),
          size=2) + 
  labs(color = "Headways") +
  geom_sf_text(aes(label=route_id)) +
  theme_bw()


##### Add the NYC polygons ##### ##### ##### ##### ##### 
# https://data.beta.nyc/dataset/nyc-zip-code-tabulation-areas/resource/894e9162-871c-4552-a09c-c6915d8783fb?view_id=2c40fce3-0bb2-46d3-bb67-04a935151a96
# https://edaoud.com/blog/2022/03/18/draw-maps-with-R-and-ggplot/

library(geojsonio)
library(broom)

# NYC Geometry
spdf_file <- geojson_read(  # Read the geojson file
  "data/zip_code_040114.geojson",
  what = "sp"
  )

stats_df <- as.data.frame(spdf_file)  # Export the census statistics in another data frame variable
spdf_file <- broom::tidy(  # Convert it to a spatial data frame, with zip code as index
  spdf_file,
  region="ZIPCODE"  # Use ZIPCODE variable as index, the index will be named "id"
)

# second output
ggplot() +
  geom_polygon(data=spdf_file %>%
                 inner_join(stats_df, c("id"="ZIPCODE")),
               aes(x=long, y=lat, group=group,
                   fill=POPULATION),
               color="white",
               linewidth=.2) +
  coord_map() +
  scale_fill_distiller(palette = "YlGnBu", 
                       direction = 1) +
  labs(title="Population in New York City",
       subtitle="Neighborhoods are filled by population",
       fill="Population")

######

# see unique routes id available in the dataset
routes_sf_crs %>% 
  filter(median_headways < 10*60) %>% 
  as.data.frame()%>%
  count(route_id,median_headways)%>%
  pull(route_id)
  
########  ######## ########  ######## ########  ######## ########  ######## 
# Final map combination of the two outputs ##### ##### ##### ##### 
routes_sf_crs %>% 
  filter(median_headways < 10*60) %>% 
  ggplot() + 
  geom_polygon(data=spdf_file %>%
                 inner_join(stats_df, c("id"="ZIPCODE")),
               aes(x=long,
                   y=lat,
                   group=group,
                   fill=POPULATION),
               color="grey60",
               alpha=0.5,
               linewidth=.2) +
  scale_fill_gradient(low="white",high="grey40")+
  geom_sf(aes(color=as.factor(median_headways)),
          linewidth=1,
          show.legend = F,
          alpha=0.8) + 
  labs(title="New York City subways",
       subtitle="Map headways by route & Population density",
       caption="Subway routes id are from 1 to 7 with extension coded X,A,D,E,F,G,J,L,M,N,Q and R\nNYC Subways info:https://en.wikipedia.org/wiki/List_of_New_York_City_Subway_stations\nDataSource: NY Subways from {tidytransit} & NYC Geometry from data.BetaNYC\nMap: Federica Gazzelloni (@fgazzelloni)",
       color = "Headways",
       x="Longitude",y="Latitude") +
  geom_sf_label(aes(label=route_id),
               fontface="bold",
               label.padding = unit(0.05, "lines"),
               size=1.5,color="grey30") +
  coord_sf() +
  theme_bw()+
  theme(text=element_text(family="Noto Serif",size=9),
        legend.position = c(1.1,0.7),
        #legend.background = element_blank(),
        legend.key.size = unit(10,units = "pt"),
        legend.text = element_text(size=5),
        legend.title = element_text(size=5.5),
        axis.title = element_text(size=8),
        axis.text = element_text(size=6),
        plot.title = element_text(size=18),
        plot.caption = element_text(size=6,hjust=0.5,lineheight = 1.2),
        panel.background = element_rect(fill="grey90"))


# Save it ##### ##### ##### ##### ##### 
# ggsave("day6_network.png", # 7.19 x 5.15
#        dpi=280,
#        width = 7.19,
#        height = 5.15)
########  ######## ########  ######## ########  ######## ########  ######## 