# John Snow data


library(tidyverse)

library(rgdal)
library(maptools)
library(ggmap)
library(sp)
library(sf)
library(HistData)
library(leaflet)
library(OpenStreetMap)
library(osmdata)
library(spData)


library(stars)
lnd_img <- file.path("GBD/Comunicable_diseases/John_snow/SnowGIS/OSMap_Grayscale.tif")
sat_vis <- read_stars(lnd_img
                     # RasterIO = list(nBufXSize = 600, nBufYSize = 600)
                      )



pumps <- st_read("GBD/Comunicable_diseases/John_snow/SnowGIS/Pumps.shp")
pumps <- st_transform(pumps, crs = st_crs(sat_vis))
pumps2<- data.frame(st_coordinates(pumps$geometry))



library(extrafont)
library(showtext)



## Automatically use showtext to render text for future devices
showtext_auto()

## Tell showtext the resolution of the device,
## only needed for bitmap graphics. Default is 96
showtext_opts(dpi = 320)

## Loading Google fonts (https://fonts.google.com/)

font_add_google("Oswald", "oswald")




ggplot() +
  geom_stars(data = sat_vis, show.legend = FALSE) +
  scale_fill_viridis_d(alpha = 1,
                       begin = 0.9,
                       end = 0,
                       direction = -1,
                       option = "B",
                       aesthetics = "fill")+
  geom_polygon(data=pumps2,
               aes(x = X, y = Y),
               colour = "midnightblue",alpha=0.3)+
  geom_point(data=pumps2,
             aes(x = X, y = Y),
             colour = "midnightblue")+
  geom_point(data = pumps2, aes(x = X, y = Y), shape = 21,
             colour = "gold", fill = NA,
             size = 7, stroke = 1,inherit.aes = FALSE) +
    coord_equal()+
  labs(title="John Snow Colera map of the pumps")+
  ggthemes::theme_map()+
  theme(text = element_text())


ragg::agg_png("js_map.png",
              res = 320, width = 14, height = 8, units = "in")
final

dev.off()


library(cowplot)
final<-ggdraw()+
  draw_image("R_general_resources/30DayMapChallenge/day18_water/js_map.png",
             x = 0.01, y = 0,width = 0.98) +

  draw_line(x = c(0.2, 0.8),y = c(0.8, 0.97),color = "green", size = 25) +
  draw_label(label="John Snow's 1854 investigation \nof a Cholera outbreak in London",
             x=0.5,y=0.89,size=20,color="grey20",fontface = "bold",
             angle = 12) +

  draw_line(x = c(0.6, 0.9),y = c(0.6, 0.67),color = "green", size = 20) +
  draw_label(label="Pumps locations\nvectors of the infections",
             x=0.75, y=0.63, size=16, angle=10,
             color = "black",fontface = "bold",
             lineheight = 1.1,
             alpha = 1) +
  draw_line(x = c(0.6, 0.58),y = c(0.6, 0.5),color = "green", size = 1) +
  #draw_grob(g, scale = 0.15,x = 0,y = -0.08)+
  draw_line(x = c(0.2, 0.805),y = c(0.05, 0.05),color = "green", size = 21) +
  draw_text("Datasource: blog.rtwilson.com - #30DayMapChallenge Day18 water\nInfographics: Federica Gazzelloni",
            x=0.5,y=0.05,size=14,fontface = "bold")




# save final plot
ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day18_water/water.png"),
              res = 320, width = 12, height = 8, units = "in")
final
dev.off()




