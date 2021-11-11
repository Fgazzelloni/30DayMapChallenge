
# day11-3D
# source: https://ggplot2-book.org/maps.html
#--------------
library(rayshader)
library(tidyverse)


files <- bomrang::get_available_imagery() %>%
  stringr::str_subset("202111100700")

curl::curl_download("ftp://ftp.bom.gov.au/anon/gen/gms/IDE00427.202111110800.tif",
                    "IDE00427.202111110800.tif")

localtif=raster::raster("day11_3D/IDE00427.202111110800.tif")

#And convert it to a matrix:
elmat = rayshader::raster_to_matrix(localtif)

require(rayshader)
#We use another one of rayshader's built-in textures:
earth1 <- elmat %>%
  sphere_shade(colorintensity = 2,
               zscale = 1/2,
               texture="unicorn") %>%
  plot_map()

# save plot
ragg::agg_png(here::here("day11_3D/3D.png"),
              res = 320, width = 12, height = 8, units = "in")
elmat %>%
  sphere_shade(colorintensity = 2,
               zscale = 1/2,
               texture="unicorn") %>%
  plot_map()
dev.off()

# fonts

library(showtext)
library(extrafont)
#fonts()
#loadfonts()
font_add_google("Shadows Into Light","ShadowsIntoLight")
showtext_opts(dpi = 320)
showtext_auto(enable = T)




# final touches
library(cowplot)
library(magick)

image_3D<- magick::image_read(here::here("day11_3D/3D.png"))


final <- cowplot::ggdraw()+
  draw_image(image_3D,x = 0.1, y = 0,width = 0.7) +
  draw_label(label="Australia perspective",x=0.3,y=0.15,
             fontfamily="ShadowsIntoLight",size=20) +


  draw_label(label="World 3D Sat-view (8am 11.11.2021-GMT+11)", x=0.45, y=0.9,
             size=30,
             fontfamily="ShadowsIntoLight") +

  draw_text("Datasource: bom.gov.au and #30DayMapChallenge day11 3D\nInfographics: Federica Gazzelloni",
            x=0.5,y=0.05,family="ShadowsIntoLight",size=12)



ragg::agg_png(here::here("day11_3D/world_3D.png"),
              res = 320, width = 8, height = 6, units = "in")
final
dev.off()


