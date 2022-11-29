#30DayMapChallenge 2022 Day 29: Out of my comfort zone
# Author: Federica Gazzelloni

# map made with https://studio.foursquare.com/
# link: https://studio.foursquare.com/public/1525b083-1b3d-46ec-a661-0833ca5e87cb

library(tidyverse)
library(cowplot)
ggdraw()+
  draw_image("basemap.png")+
  draw_image("legend1.png",
             scale=0.5,
             x=-0.43,y=0)+
  draw_label("United States of America precipitations",
             x=0.5,y=0.93,
             size=18,
             color="black") +
  draw_label("Permanent amount of precipitations on Global Railways\n#30DayMapchallenge 2022 Day 29: Out of my comfort zone | Tool: studio.foursquare.com | Map: @fgazzelloni",
             x=0.5,y=0.05,
             size=9,
             color="black") 
ggsave("test.png",
       bg="white",
       width=8.92,
       height=5.9)
