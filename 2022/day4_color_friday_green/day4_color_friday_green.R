#30DayMapChallenge 2022 Day 4: Color Friday Green
# Author: Federica Gazzelloni


library(osmdata)
library(mapdeck)
library(cowplot)

# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Island Moments",
                family="Island Moments")



ms <- opq(c(12.4146,41.7836,12.5327,42.0064)) %>% 
  add_osm_feature (key = "highway") %>%
  osmdata_sf (quiet = FALSE)

# save(ms,file="data/ms.RData")
# mapdeck::set_token("your-token") easy to get just register on the web-site mapbox.com
# restrict the polygons to road access
lines<- ms$osm_lines%>%filter(!is.na(access))
# style: https://docs.mapbox.com/api/maps/styles/
# fonts: curl "https://api.mapbox.com/fonts/v1/fgazzelloni?access_token=pk.eyJ1IjoiZmdhenplbGxvbmkiLCJhIjoiY2w5enphdHR3MGtkMjN2bnZja2s1eWRuaCJ9.akYCOcUXC7OJ7PkF1JZ86A

# make the map
mapdeck(style = 'mapbox://styles/mapbox/navigation-night-v1',
        location =  c(12.4924,41.8903),
        padding=1,
        zoom = 12) %>%
  add_path(data = lines,
           layer_id = "ms",
           stroke_colour = "#2e7521",
           stroke_width = 0,
           stroke_opacity = 0,
           tooltip = "ROAD_NAME",
           auto_highlight = TRUE,
           legend = FALSE,
           update_view = FALSE) %>%
  add_polygon(data = ms$osm_polygons,
              layer_id = "ms",
              stroke_colour = "#6ced55",
              stroke_width = 20,
              stroke_opacity = 200,
              fill_opacity = 0,
              update_view = FALSE) 


# draw the map
ggdraw()+
  draw_image("base_map.png")+
  draw_label("#30DayMapChallenge 2022 Day 4: Color Friday Green | DataSource: osmdata Rome, Italy | Map: Federica Gazzelloni (@fgazzelloni)",
             x=0.5,y=0.02,size=7,
             fontfamily = "Island Moments",
             color="#6ced55")+
  labs(title="Historic district of Rome") + 
  theme_bw()+
  theme(plot.title = element_text(family="Island Moments",face="bold",color="#6ced55"),
        plot.background = element_rect(colour = "#43605b",fill = "#43605b"),
        panel.background = element_rect(colour = "#43605b",fill = "#43605b")) 
 

# save it! 
# ggsave("day4_color_friday_green_2.png",
#        dpi=200,
#        width = 8.86,
#        height = 6.04)









