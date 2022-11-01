# https://github.com/schochastics/roughsf
# https://leonawicz.github.io/mapmate/articles/usage_and_limitations.html

library(mapmate)
library(dplyr)
library(RColorBrewer)
RColorBrewer::display.brewer.all()
pal <- rev(brewer.pal(11, "Blues"))

data(annualtemps)
data(borders)
data(bathymetry)

id <- "frameID"
annualtemps
temps <- mutate(annualtemps, frameID = Year - min(Year) + 1) %>%
  filter(frameID == 1)  # subset to first frame
brdrs <- mutate(borders, frameID = 1)
bath <- mutate(bathymetry, frameID = 1)


save_map(annualtemps,
         z.name = "z",
         id = "Year",
         col = pal,
         lat = 30,
         lon= 20,
         rotation.axis= 22,# defaults to 23.4 degrees
         type = "density",
         contour = "overlay",
         save.plot = FALSE,
         return.plot = TRUE)





#------
library(sf)
library(tidyverse)

world <- rnaturalearth::ne_countries(scale = 50,
                                     type = "countries",
                                     returnclass = "sf")

# little <- rnaturalearth::ne_countries(scale = 50,
#                                      type = "tiny_countries",
#                                      returnclass = "sf")
# little_coord<- st_coordinates(little)
# little_coord<-as.data.frame(little_coord)
# ggplot(little_coord,aes(x=X,y=Y))+
#   geom_point()+
#   coord_map("ortho", orientation = c(25.849945, 16.525750, 0))
# x_little<- little_coord$X
# y_little<- little_coord$Y



world_cr<- st_coordinates(world)
world_cr<-as.data.frame(world_cr)%>%
  fortify()

earth<-ggplot(world_cr,aes(x=X,y=Y,group=L3))+
  geom_line(aes(color= factor(L3)),
            size=0.15,show.legend = F)+
  geom_point(shape=".")+
  labs(x="",y="")+
  coord_map("ortho", orientation = c(5.849945, 56.525750, 0)) +
  theme(plot.background = element_blank(), # element_rect(fill="#11657A",color="#11657A"),
        panel.background = element_blank(), #element_rect(fill="#11657A",color="#11657A"),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank()
        )

g <- grid::circleGrob(gp = grid::gpar(fill = "#68aade",color="#68aade"))

# set the text options
library(showtext)
showtext_opts(dpi = 320)
showtext_auto(enable = T)
font_add_google("Share Tech Mono", "techmono")

library(cowplot)
final <- ggdraw()+
  draw_image("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day28_earth_not_flat/space.png",
             scale=1.4,height=1)+
  draw_grob(g, scale = 1)+
  draw_plot(earth)+
  #draw_image(mono_it, x = 0, y = 0,width = 1)+
  draw_text("The Earth is not flat",color="white",
            x=0.15,y=0.96,angle=0,size=23,
            family="techmono",fontface="bold")+
  draw_text("DataSource: rnaturalearth\n#30DayMapChallenge-The Earth is not flat\nGraphic: Federica Gazzelloni",
            x=0.855,y=0.05,
            family="techmono",
            size=11,color="white")



# save final plot
ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day28_earth_not_flat/earth_not_flat.png"),
              res = 320, width = 12, height = 10, units = "in")
final
dev.off()





