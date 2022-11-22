#30DayMapChallenge 2022 Day 22: NULL
# Author: Federica Gazzelloni


library(tmap)
data(World)

tmap_style("cobalt")

  tm <- tm_shape(World) +
    tm_polygons("HPI",
                alpha = 0.9,border.alpha = 0.5) +
    tm_layout(legend.position = c(0.1,0.2), 
              title= "Happy Planet Index NULL", 
              title.position = c(0.4,0.2))+
    tm_credits("#30DayMapChallenge 2022 Day 22: NULL\nDataSource: {tmap} | Map: Federica Gazzelloni (@fgazzelloni)",
               align = "center") 
  

tmap_save(tm, filename = "day22_null.png")
