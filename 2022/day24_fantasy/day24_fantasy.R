#30DayMapChallenge 2022 Day 24: Fantasy
# Author: Federica Gazzelloni

library(tidyverse)
library(sf)
library(scico)

# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Patrick Hand",
                family="Patrick Hand")



#########

projection_bonne <- c("+proj=bonne +lat_1=10")


world_graticule <- sf::st_graticule(lon=seq(-180,180, 15),
                                    lat = seq(-90,90, 7.5),
                                    ndiscr = 5000,
                                    margin = 0.00000000001) %>%
  st_transform(projection_bonne)



world_pol <- rnaturalearth::ne_countries(returnclass = "sf")

ggplot() +
  geom_sf(data = world_graticule, 
          linewidth = 0.1, 
          color = "white", 
          alpha = 0.6) +
  geom_sf(data=world_pol,aes(fill=economy))+
  coord_sf()+
  scico::scale_fill_scico_d(direction = -1)+
  labs(fill="Economy",
       caption = "#30DayMapChallenge2022 Day 24: Fantasy\nDataSource: {rnaturalearth} & proj=bonne | Map: Federica Gazzelloni (@fgazzelloni)") + 
  ggthemes::theme_map()+
  theme(text=element_text(color="navy",family="Patrick Hand"),
        plot.background = element_rect(fill="#a8bd3a",color="grey80"),
        plot.caption = element_text(size=5,lineheight = 1.1),
        legend.key.size = unit(7,units="pt"),
        legend.position = c(0,-0.1),
        legend.text = element_text(color="navy",size=6),
        legend.title = element_text(color="navy"),
        legend.background = element_blank())


ggsave("day24_fantasy.png",
       width = 5.42,
       height = 3.2)





