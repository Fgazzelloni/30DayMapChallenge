#30DayMapChallenge 2022 Day 19: Globe
# Author: Federica Gazzelloni


## This script is to make the Globe plot.

library(tidyverse)
library(rnaturalearth)

# world data full 
world_full <- ne_countries(scale = "medium", returnclass = "sf")
# world lat&long
world<-map_data(map = "world") 

my_world_data<- world %>%
  full_join(world_full, by = c("region"="name")) %>%
  select(long,lat,group,order,region,region_wb)

# grob for globe water
g <- grid::circleGrob(gp = grid::gpar(fill = "#9ad6f0",color="gray30"))

world<-ggplot() +
  geom_polygon(data=my_world_data,
               aes(x=long,y=lat,group=group),
               fill="gray30",color="black",size=0.09) +
  coord_map("ortho", orientation = c(65.85, -130.21,0)) + 
  theme_void() 

world

library(cowplot)
globe <- ggdraw() +
  draw_grob(g, scale = 1,x = 0,y = 0) +
  draw_plot(world) +
  draw_label("Globe",x=0.1,y=0.93,
             size=22,
             color="#9ad6f0")+
  draw_label("#30DayMapChallenge 2022 Day 19: Globe\nDataSource: {rnaturalearth} | Map: Federica Gazzelloni (@fgazzelloni)",
             x=0.99,y=0.02,size=6,
             hjust=1,
             color="#9ad6f0")

globe

ggsave("day19_globe.png",
       width=7.5,
       height= 7.5,
       dpi=320,
       bg="grey10")

