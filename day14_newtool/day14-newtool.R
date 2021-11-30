# day14-newtool

library(cowplot)
library(tidyverse)

library(showtext)
library(extrafont)
sysfonts::font_info_google("Dancing Script")
fonts()
loadfonts()
font_add_google("Roboto Condensed","Scooby Doo")
showtext_opts(dpi = 320)
showtext_auto(enable = T)



ch_image<- magick::image_read(here::here("R_general_resources/30DayMapChallenge/day14_newtool/unfolded.png"))

g <- grid::circleGrob(gp = grid::gpar(fill = NA,col="white",lwd=0.5))


final <- cowplot::ggdraw()+
  draw_image(ch_image,x = 0.01, y = 0,width = 0.98)+

  draw_label(label="high density concentration found\nin some areas\nmore than others",
             x=0.6,y=0.65,fontfamily="Scooby Doo",size=10,color="gold") +

  draw_label(label="Chicago Income less than 10k (%)",
             x=0.45, y=0.95, size=32, fontfamily="Scooby Doo",
             color = "black",fontface = "bold") +

  draw_line(x = c(0.52, 0.6),y = c(0.38, 0.5),color = "gold", size = 0.2)+

  draw_line(x = c(0.535, 0.63),y = c(0.51, 0.51),color = "gold", size = 9)+

  draw_label(label="Chicago",
             x=0.582, y=0.51, size=19, fontfamily="Scooby Doo",
             color = "black",fontface = "bold",
             lineheight = 1.1,
             alpha = 1) +
  draw_grob(g, scale = 0.15,x = 0,y = -0.08)+

  draw_text("Datasource: unfolded - #30DayMapChallenge Day14 New Tool\nInfographics: Federica Gazzelloni",
            x=0.5,y=0.05,family="Scooby Doo",size=12)




# save final plot
ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day14_newtool/newtool.png"),
              res = 320, width = 12, height = 8, units = "in")
final
dev.off()






