
# Datasource: http://www.cpom.ucl.ac.uk/csopr/icesheets2/dems.php?ais_subject=dem&user_type=normal



library(raster)
library(tidyverse)

library(extrafont)
loadfonts()
font="Verdana"


antaritca_tif <- raster(here::here("R_general_resources/30DayMapChallenge/day21_elevation/photo.tif"))

antaritca_aggr <- raster::aggregate(antaritca_tif, fact = 2, fun = "mean") %>%
  as.data.frame(xy = TRUE)  %>%
  rename(elevation = 3)

antaritca_aggr <- antaritca_aggr%>%filter(!elevation=="NaN")
antaritca_aggr <- antaritca_aggr%>%filter(elevation>0)


ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day21_elevation/elevation.png"),
              res = 320, width = 12, height = 8, units = "in")

ggplot(antaritca_aggr) +
  geom_point(aes(x, y, color=elevation), size = 0.01)+

  annotate("text", 23.5, 33, hjust = 0.5, vjust = 1, label = "elevation", family = font,
           fontface = "bold", size = 6, color = "white") +

  scale_color_gradient(low="#1e83bd",high="white")+

  labs(title="Antarctic Ice Sheet",color="Elevation",
       subtitle="Surface Elevation Change (SEC)",
    caption = "DataSource: CPOM CryoSat - #30DayMapChallenge Elevation - Graphic: Federica Gazzelloni\n"
  ) +
  coord_sf() +

  theme_void(base_size = 12, base_family = font) +
  theme(
    legend.position = c(0.11, 0.1),
    legend.title = element_blank(),
    legend.text = element_text(color = "grey97", size = 11),
    plot.background = element_rect(fill = "#272a3b", color = NA),
    plot.title.position = "panel",
    plot.title = element_text(size=35,face="bold",color="grey97",hjust = 0.1,vjust = -1),
    plot.subtitle = element_text(size=15,face="bold",color="grey97",hjust = 0.1,vjust = -1.1),
    plot.caption = element_text(color = "grey97", hjust = 0.5, lineheight = 1,vjust=1)
  )
dev.off()
