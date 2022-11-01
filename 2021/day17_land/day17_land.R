# with Unfolded

library(cowplot)
library(tidyverse)

library(showtext)
library(extrafont)
# sysfonts::font_add("")
#fonts()
#loadfonts()
font_add_google("Cinzel","Cinzel")
showtext_opts(dpi = 320)
showtext_auto(enable = T)



nyc_image<- magick::image_read(here::here("R_general_resources/30DayMapChallenge/day17_land/unfolded.png"))

g <- grid::circleGrob(gp = grid::gpar(fill = NA,col="white",lwd=0.5))


final <- cowplot::ggdraw()+
  draw_image(nyc_image,x = 0.01, y = 0,width = 0.98)+

  draw_label(label="New York's population",
             x=0.6,y=0.63,fontfamily="Cinzel",size=10,color="gold") +


  draw_label(label="New York landscape",
             x=0.15, y=0.95, size=19, fontfamily="Cinzel",
             color = "black",fontface = "bold",
             lineheight = 1.1,
             alpha = 1) +
  #draw_grob(g, scale = 0.15,x = 0,y = -0.08)+

  draw_text("Made with: studio.unfolded.ai - #30DayMapChallenge Day17 Land\nInfographics: Federica Gazzelloni",
            x=0.5,y=0.05,family="Cinzel",size=12,fontface = "bold")




# save final plot
ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day17_land/land.png"),
              res = 320, width = 12, height = 8, units = "in")
final
dev.off()











