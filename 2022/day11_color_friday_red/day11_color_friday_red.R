#30DayMapChallenge 2022 Day 11: Color Friday Red
# Author: Federica Gazzelloni

library(tidyverse)
raw_contour <- read_delim(
  "data/FM_service_contour_current.txt",
  delim = "|"
)

conv_contour <- raw_contour |>
  select(-last_col()) |>
  set_names(nm = c(
    "application_id", "service", "lms_application_id", "dts_site_number", "transmitter_site",
    glue::glue("deg_{0:360}")
  ))

lng_lat <- conv_contour |>
  separate(
    transmitter_site, 
    into = c("site_lat", "site_long"), 
    sep = " ,")
# save(lng_lat,file= "data/lng_lat.RData")
# load("rdata/lng_lat.RData")

df_coords <- lng_lat%>%
  select(-dts_site_number) %>%
  distinct() %>%
  drop_na() %>%
  mutate_all(trimws)%>%
  mutate(application_id=as.numeric(application_id),
         site_lat=as.numeric(site_lat),
         site_long=as.numeric(site_long))

df_coords %>%
  as.data.frame() %>%
  arrange(service) %>%  
  count(service)

df_coords1_FM <- df_coords %>%
  as.data.frame() %>%
  arrange(service) %>%  #count(service)
  filter(service=="Full Service (FM)") 


df_coords1_FB <- df_coords %>%
  as.data.frame() %>%
  arrange(service) %>%  #count(service)
  filter(service=="FM Boosters (FB)") 
# save(df_coords1,file="rdata/df_coords1_FB.RData")
# load("rdata/df_coords1_FB.RData")

df_coords2 <- df_coords1_FB %>%
  pivot_longer(cols = deg_0:deg_360,
               names_to = "angle",
               values_to = "values") 

df_coords3 <- df_coords2 %>%
  mutate(angle = str_remove(angle, "deg_"),
         angle = as.integer(angle))


df_coords4 <- df_coords3 %>%
  separate(values,
           into = c("deg_lat", "deg_lng"),
           sep = " ,")


df_coords5_FB <- df_coords4 %>%
  mutate(deg_lat= ifelse(is.na(deg_lng),site_lat,deg_lat),
         deg_lng= ifelse(is.na(deg_lng),site_long,deg_lng))

# save(df_coords5,file="rdata/df_coords5_FB.RData")
# load("rdata/df_coords5_FB.RData")

library(sf) # spatiotemporal
world <- sf::st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
states <- sf::st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))


df_coords5_FB_sf <- df_coords5_FB %>%
   st_as_sf(coords=c(8,7),crs=4326) 


# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Xanh Mono",family="Xanh Mono")



library(ggnewscale)

ggplot() +
  geom_sf(data= world, aes(fill=ID),
          color="#590303",
          show.legend = F) +
  scale_fill_viridis_d(alpha = 0.3,
                       begin = 0.55,
                       end = 0.35,
                       option = "F") +
  # geoms below will use another color scale
  new_scale_color() +
  geom_sf(data=states,aes(fill=ID),
          color="#8a1313",
          linewidth =0.05,
          show.legend = F) +
  scale_fill_viridis_d(alpha = 0.3,
                       begin = 0.55,
                       end = 0.35,
                       option = "F") +
  geom_point(data = df_coords1_FM,
             mapping = aes(site_long,site_lat),
             shape=".",color="#e37f78",
             inherit.aes = F) +
  geom_sf(data = df_coords5_FB_sf,
          shape=21,stroke=0.009,
          alpha=0.2,
          fill= NA, #"#eba7a7",
          color="#ab251b",
          inherit.aes = F) +
  coord_sf(xlim = c(-171.73031,-55),ylim = c(20,71.29194))+
  labs(title="FM Boosters - FB Radio Stations",
       caption="FM Boosters contours on central point FM Radio Stations. DataSource: FM Service Contour Data Points (fcc.gov)\nData provides FM additional services: FM Auxiliary (FS), FM Boosters (FB), Full Service (FM), Low Power FM (FL), Translators (FX).
       #30DayMapChallenge 2022 Day 11: Color Friday Red & #TidyTuesday 2022 Week 45 Radio Stations | Map: Federica Gazzelloni (@fgazzelloni)")+
  theme_classic() +
  theme(text=element_text(face="bold",color="#ab251b",family="Xanh Mono"),
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(),
        #plot.margin = margin(5,0,5,0,unit = "pt"),
        plot.caption = element_text(size=5,lineheight = 1.1,hjust=0.5),
        plot.background = element_rect(fill="#e3b7b3",color="#590303"),# a8a2a2
        panel.background = element_rect(fill="#e3b7b3",color="#590303"))

ggsave("day11_color_friday_map.png",
       dpi=280,
       bg="white",
       width = 6.1,
       height = 4.3)




