


# mapmate vignettes
# https://rdrr.io/github/leonawicz/mapmate/f/vignettes/mapmate.Rmd
# https://leonawicz.github.io/mapmate/articles/usage_and_limitations.html


rm(list=ls())
library(mapmate)
library(dplyr)
library(RColorBrewer)
pal <- rev(brewer.pal(11, "BrBg"))
RColorBrewer::display.brewer.all()

data(annualtemps)
data(borders)
data(bathymetry)




id <- "frameID"
temps <- mutate(annualtemps, frameID = Year - min(Year) + 1) %>% 
  filter(frameID == 1)  # subset to first frame

my_df<- temps%>%full_join(borders,by=c("lon","lat"))


brdrs <- mutate(borders, frameID = 1)
bath <- mutate(bathymetry, frameID = 1)

save_map(brdrs, id = id, 
         type = "maplines", save.plot = FALSE, return.plot = TRUE)


save_map(my_df, id = id, 
         col = pal, 
         type = "density", contour = "overlay", save.plot = FALSE, 
         return.plot = TRUE)


