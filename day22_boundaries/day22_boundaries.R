


# https://www.tug.org/pracjourn/2007-4/walden/color.pdf
library(ggplot2)
library(rgeoboundaries)
library(sf)
library(spData)
spData::world


rgeoboundaries::gb_clear_cache()
# save final plot
ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day22_boundaries/boundaries_base.png"),
              res = 320, width = 6, height = 6, units = "in")
world <- gb_adm1()
world_lambert <- st_transform(world, "+proj=laea +x_0=0 +y_0=0 +lon_0=0 +lat_0=0")
world_lambert%>%
  ggplot()+
  geom_sf(aes(geometry=geometry),
          fill = rgb(red = 0.5, green = 0.7, blue = 0.5, alpha = 0.5),
          col="grey45",size=0.08)+
  coord_sf()+
  ggthemes::theme_fivethirtyeight()+
  theme(panel.background = element_rect(color=rgb(red = 0.2, green = 0.1, blue = 0.3, alpha = 0.5),
                                        fill=rgb(red = 0.2, green = 0.4, blue = 0.5, alpha = 0.5)),
        plot.background = element_blank()
  )
dev.off()


library(cowplot)
final1<- ggdraw()+
  draw_image("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day22_boundaries/boundaries_base.png")+
  draw_label("World Boundaries",x=0.5,y=0.1,fontface="bold",size=24,color = "#2B2933")+
  draw_text("Data: {rgeoboundaries}-#30DayMapChallenge Day 22 Boundaries\nInfographics: Federica Gazzelloni",
            x=0.5,y=0.04,size=10)

ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day22_boundaries/boundaries.png"),
              res = 320, width = 6, height = 6, units = "in")
final1
dev.off()
