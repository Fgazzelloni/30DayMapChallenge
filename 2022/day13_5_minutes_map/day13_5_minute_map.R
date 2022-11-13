#30DayMapChallenge 2022 Day 13: 5 minute map
# Author: Federica Gazzelloni

# Load libraries
# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Exo 2",
                family="Exo 2")

library(tidyverse)

world <- map_data("world")
  filter(!region=="Antarctica")
world%>%names
ggplot(world)+
  geom_polygon(aes(long,lat,
                   group=group,
                   fill=region,
                   color=region),
               alpha=0.7,
               linewidth=0.2,
               show.legend = F)+
  scale_fill_viridis_d(option = "C")+
  scale_color_viridis_d(option = "A")+
  coord_quickmap()+
  labs(title="World Map",
       caption="#30DatMapChallenge 2022 Day 13: 5 minute map\nDataSource: Map data from {ggplot2} | Map: Federica Gazzelloni (@fgazzelloni)")+
  ggthemes::theme_map()+
  theme(text=element_text(family="Exo 2"),
        plot.title = element_text(hjust=0.5,size=24),
        plot.caption = element_text(hjust=0.5,size=5,lineheight = 1.1))

ggsave("day13_5_minute_map.png",
       dpi=280,
       width = 6.6,
       height = 4,
       bg="#98d8de") # 6.64 x 5.81


