#30DayMapChallenge 2022 day 2: Lines
# author: Federica Gazzelloni


# load the libraries
library(tidyverse)
library(sf)
library(cowplot)

# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add(family ="Roboto Condensed",regular="RobotoCondensed-Regular.ttf")
# font_add_google(name ="Roboto Condensed",family="Roboto Condensed")
# read in the rivers data
# https://www.hydrosheds.org/products/hydrorivers
# my_rivers <- st_read(dsn = 'HydroRIVERS_v10_eu_shp/HydroRIVERS_v10_eu.shp') 
# save(my_rivers,file="data/my_rivers.RData")

load("data/my_rivers.RData")


# select rivers with length in km greater than 1.780
my_rivers_1 <- my_rivers %>% 
  filter(LENGTH_KM> 1.780)



map <- my_rivers_1 %>% 
  ggplot()+
  geom_sf(aes(color=ORD_FLOW),
          size=0.1,
          show.legend = TRUE) +
  coord_sf(xlim = c(0.439,24.961),ylim = c(34.355,46.870))

map +
  labs(title="Long-term rivers average discharge",
       subtitle="Italy and surrounding areas",
       caption="Values m3/s. Rivers with length in km greater than 1.780.\nLength of discharge indicator: high (1) to low (10)\n#30DayMapChallenge 2022 Day 2: Lines\nDataSource: hydrosheds.org | Map: Federica Gazzelloni (@fgazzelloni)",
       color="Indicator")+
  theme(legend.position = c(0.2,-0.105),
        legend.background = element_blank(),
        legend.direction = "horizontal",
        text = element_text(family="Roboto Condensed"),
        panel.grid = element_line(color="grey92",size=0.3),
        plot.background = element_rect(color="grey95",fill="grey95"),
        panel.background = element_rect(color="grey95",fill="grey95"))



ggsave("day2_lines.png",dpi=300)
