#30DayMapChallenge 2022 Day 7: Raster
# Author: Federica Gazzelloni

# Load the library
library(tidyverse)
# Set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Island Moments",
                family="Island Moments")

# Load the raster layer
load("predictions.RData")
predictions$layer
# More info about the predictions raster layer can be found 
# else where: [here](https://fgazzelloni.github.io/How-to-Spatial-Modeling-with-R/)

# Make the map and save it as .png
library(raster)
# quartz()
showtext::showtext_opts(dpi=120)
agg_png(filename ="raster.png",
        width = 680,
        height = 680,
        units = "px",
        pointsize = 8,
        res = 80,
        scaling = 1.2,
        bitsize = 8,
        background="grey90")
raster::plot(predictions,
             xlim=c(-125,-100),ylim=c(35,55),axes=F)
dev.off()

# Draw the plot
library(cowplot)

ggdraw()+
  draw_image("raster.png")+
  draw_label("Oregon Spotted Frogs: Rana Pretiosa",
             fontfamily="Island Moments",
             x=0.5,y=0.9,size=18) +
  draw_label("Crane Prairie Reservoir, Deschutes County",
             fontfamily="Island Moments",
             lineheight = 0.5,
             size=12,
             x=0.5,y=0.88)+
  draw_label("Habitat study September-November 2018\nGreen areas show the most probable spotting locations\nas result of the prediction",
             fontfamily="Island Moments",
             lineheight = 0.5,hjust = 0,
             size=12,
             x=0.5,y=0.7)+
  draw_label("#30DayMapChallenge 2022 Day 7: Raster | DataSource: Oregon Spotted Frogs: Rana Pretiosa\nMap: Federica Gazzelloni (@fgazzelloni)",
             fontfamily="Island Moments",
             x=0.5,y=0.1)+
  draw_label("Credits: Results based on a study by Dr. Michael J Adams from the Forest and Rangeland Ecosystem Science Center in Oregon.",
             fontfamily="Island Moments",
             lineheight = 0.5,hjust = 0,
             x=0.15,y=0.03)

# Save it!
ggsave("final.png",dpi=200,
       width=6.5, height=5.57)

