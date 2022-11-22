#30DayMapChallenge 2022 Day 21: Kontour Pop Dataset
# Author: Federica Gazzelloni

library(tidyverse)
library(sf)



# Load libraries
# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Noto Serif",
                family="Noto Serif")

# KONTOUR DATASETS
# https://data.humdata.org/dataset/kontur-population-dataset

url <- "https://geodata-eu-central-1-kontur-public.s3.amazonaws.com/kontur_datasets/kontur_population_CR_20220630.gpkg.gz"
downloader::download(url, dest="data/kontour_pop_cr.zip", mode="wb") 

kontur <- sf::st_read("data/kontour_pop_cr")


na <- rnaturalearth::ne_countries(continent = "North America",
                                  country = c("Costa Rica","Nicaragua","Panama"))

na_sf <- na %>% st_as_sf()

# map
ggplot() +
  geom_sf(data = na_sf,
          mapping=aes(geometry=geometry),
          fill="#6b493e",color="#6b493e",
          alpha=0.3,
          linewidth=0.02)+
  geom_sf(data = kontur,
          fill="#6b493e",color="#6b493e",
          linewidth=0.01) +
  geom_sf(data = kontur, 
          aes(fill = population,
              colour = population),
          linewidth=0.02,
          show.legend = F) +
  scale_fill_gradient(low="white",high = "red")+
  scale_color_gradient(low="#006241",high = "white")+
  coord_sf(xlim = c(-87,-82), ylim = c(8,12), expand = 0) +
  theme_void() +
  theme(legend.position = "none",
        plot.margin = margin(10, 10, 10, 10),
        plot.background = element_rect(fill = "#6a7a74", 
                                       colour = "#6a7a74"),
        panel.background = element_rect(fill = "#6a7a74", 
                                        colour = "#6a7a74")) 



ggsave("sj_cr_base_map.png",
       width=6.17,
       height=4.86,
       dpi=320)


# draw the map

library(cowplot)
ggdraw()+
  draw_image("sj_cr_base_map.png")+
  draw_label("Costa Rica:\nPopulation Density",
             x=0.03,y=0.3,
             size=24,
             hjust=0,
             fontfamily = "Noto Serif")+
  draw_label("#30DayMapchallenge 2022 Day 21: Kontour Population dataset\nDataSource: @KonturInc | Map: Federica Gazzelloni (@fgazzelloni)",
             x=0.03,y=0.06,
             size=9,
             hjust=0, 
             fontfamily = "Noto Serif")


# save final output
ggsave("day21_kontour_pop_dataset.png",
       width=6.17,
       height=4.86,
       dpi=320)

