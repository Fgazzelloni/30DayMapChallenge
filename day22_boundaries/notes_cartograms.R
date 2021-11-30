
library(maps)
library(tidyverse)
library(spData)
spData::world
spData::nz
spData::lnd
#spDataLarge::
library(sf)
library(maptools)
library(cartogram)
library(rgdal)
data(wrld_simpl)


afr <- spTransform(wrld_simpl[wrld_simpl$REGION==2 & wrld_simpl$POP2005 > 0,],
                   CRS("+init=epsg:3395"))

# construct a cartogram using the population in 2005
afr_cartogram <- cartogram(afr, "POP2005", itermax=5)
# This is a new geospatial object, we can visualise it!
plot(afr_cartogram)

# Create cartogram
afr_carto <- cartogram_cont(afr, "POP2005", 3)

par(mfcol=c(1,2))
plot(afr, main="original")
plot(afr_carto, main="distorted (sp)")



# london
lnd

library(viridis)
ggplot() +
  geom_polygon(data = afr, aes(fill = POP2005/1000000, x = long,
                               y = lat, group = group) , size=0, alpha=0.9) +
  theme_void() +
  scale_fill_viridis(name="Population (M)", breaks=c(1,50,100, 140),
                     guide = guide_legend( keyheight = unit(3, units = "mm"),
                                           keywidth=unit(12, units = "mm"),
                                           label.position = "bottom",
                                           title.position = 'top', nrow=1)) +
  labs( title = "Africa 2005 Population" ) +
  ylim(-35,35) +
  theme(
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f4", color = NA),
    panel.background = element_rect(fill = "#f5f5f4", color = NA),
    legend.background = element_rect(fill = "#f5f5f4", color = NA),
    plot.title = element_text(size= 22, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    legend.position = c(0.2, 0.26)
  ) +
  coord_map()



# set the colors
# source: https://www.rdocumentation.org/packages/colorspace/versions/2.0-2/topics/rainbow_hcl
wheel <- function(col, radius = 1, ...)
  pie(rep(1, length(col)), col = col, radius = radius, ...)
wheel(rainbow(15537))

us_state_map <- map_data("state")


nz<- map_data("nz")


lnd

ggplot()+
  geom_polygon(data=auckland,aes(x=Northing,y=Easting,group = "Deaths.1977.85"),
               fill= rainbow(167),color = "lightblue") +
  #geom_polygon(data=nz,aes(x=long,y=lat,group=group),fill=NA)+
   ggthemes::theme_map()

state_plot



# save final plot
ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resourses/30DayMapChallenge/day3_polygons/polygons.png"),
              res = 320, width = 6, height = 6, units = "in")
state_plot
dev.off()








# save final plot
ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day22_boundaries/boundaries1.png"),
              res = 320, width = 6, height = 6, units = "in")


world_europe = world[world$continent == "Europe", ]
italy = world[world$name_long == "Italy", ]
plot(st_geometry(italy), expandBB = c(0, 0.2, 0.1, 1), col = "gray", lwd = 3)
plot(world_europe[0], add = TRUE)
dev.off()


# to make a cartogram with different format:
st_crs(italy)=st_crs(4326)
class(world);class(wrld_simpl)
italy_sp <- as(italy, 'Spatial')


it <- spTransform(italy_sp,CRS("+init=epsg:3395"))
it_cartogram <- cartogram(it, "gdpPercap", itermax=5)
plot(it_cartogram)

# Create cartogram
it_cartogram <- cartogram_cont(it, "lifeExp", 3)

par(mfcol=c(1,2))
plot(it, main="original")
plot(it_cartogram, main="distorted (sp)")
#------

unique(wrld_simpl$NAME)

data(wrld_simpl)


it <- spTransform(wrld_simpl[wrld_simpl$NAME=="Italy" & wrld_simpl$POP2005 > 0,],
                   CRS("+init=epsg:3395"))

# construct a cartogram using the population in 2005
it_cartogram <- cartogram(it, "POP2005", itermax=5)
# This is a new geospatial object, we can visualise it!
plot(it_cartogram)

# Create cartogram
it_carto <- cartogram_cont(it, "POP2005", 3)

par(mfcol=c(1,2))
plot(it, main="original")
plot(it_carto, main="distorted (sp)")




library(cowplot)
library(ggimage)
library(magick)


poly_im <- image_read("/Users/federica/Documents/R/R_general_resourses/30DayMapChallenge/day3_polygons/polygons.png")




empty<-ggplot()+geom_blank()+xlim(0,50)+ylim(0,50)+theme_void()

final <- ggdraw()+
  draw_plot()+
  draw_image(poly_im, x = 0, y = 0,width = 15)


ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resourses/30DayMapChallenge/day3_polygons/polygons2.png"),
              res = 320, width = 6, height = 6, units = "in")
final
dev.off()





