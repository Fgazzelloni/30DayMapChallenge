# Day 24 historical ############################

# The data are from:
# https://webs.ucm.es/info/cliwoc/
# https://jcheshire.com/wp-content/uploads/2016/10/shipping_map.zip
# https://jcheshire.com/visualisation/mapping-historic-tracks-ggplot2/

rm(list=ls())

library(rgdal)
library(ggplot2)
library(png)

wrld <- rgdal::readOGR("data/shipping_map/ne_110m_admin_0_countries.shp")
wrld.f <- fortify(wrld, region="sov_a3")

bdata <- read.csv("data/shipping_map/british_shipping_example.csv")

# btitle <- readPNG("data/shipping_map/brit_titles.png")
compass <- readPNG("data/shipping_map/windrose.png")
earth <- readPNG("data/shipping_map/earth_raster.png")



library(sysfonts)
library(showtext)
showtext_opts(dpi = 320)
font_add_google("Roboto Condensed")
showtext_auto()
font= "Roboto Condensed"


map <- ggplot(wrld.f, aes(x = long, y = lat))+
  annotation_raster(earth, xmin = -180, xmax = 180, ymin = -90, ymax = 90) +
  geom_polygon(aes(group=group),
               size = 0.1, colour= "black", fill="#D6BF86",alpha=0.4) +
  geom_path(data= bdata,aes(long,lat,group = paste(trp, group.regroup, sep = "."),
                            colour=nat), size = 0.2, alpha = 0.5, lineend = "round") +
  #annotation_raster(btitle, xmin = 30, xmax = 140, ymin = 51, ymax = 87) +
  annotation_raster(compass, xmin = -125, xmax = -165, ymin = 5, ymax = 45) +
  scale_x_continuous("", breaks=NULL)+
  scale_y_continuous("", breaks=NULL)+
  guides(colour = guide_legend(override.aes = list(size = 3)))+
  coord_equal() +
  labs(title="Map of 18th Century Shipping Expeditions",
       subtitle="1781 - 1799",
       color="Nationality of the ships",
       caption = "DataSource: Climatological Database for the World's Oceans 1750-1850\n#30DayMapChallenge Historical\nGraphic:Federica Gazzelloni")+
  ggthemes::theme_map()+
  theme(text = element_text(color="midnightblue",family="Roboto Condensed"),
        panel.background = element_rect(fill='#BAC4B9',colour='black'),
        legend.position = c(0.1,0.2),
        legend.background = element_blank(),
        legend.text = element_text(color="white",size=8),
        legend.key = element_blank(),
        legend.title = element_text(color="white",size=10),
        plot.title = element_text(size=40),
        plot.subtitle = element_text(size=18),
        plot.caption = element_text(size=12)
        )

# save map plot
ragg::agg_png(here::here("data/historical.png"),
              res = 320, width = 12, height = 8, units = "in")
map
dev.off()

