library(cbsodataR)
library(tidyverse)
library(sf)



# https://www.cbs.nl/en-gb/onze-diensten/open-data/statline-as-open-data/cartography
# https://simplemaps.com/data/nl-cities



#----

data_house <- cbs_get_data("83765NED",
                     select=c("WijkenEnBuurten",
                              "Appartement_48",
                              "ScholenBinnen3Km_98")) %>%
  mutate(WijkenEnBuurten = str_trim(WijkenEnBuurten),#boroughs
         houses = Appartement_48,
         schools=ScholenBinnen3Km_98)


# Retrieve data with municipal boundaries from PDOK
municipalBoundaries <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2017_gegeneraliseerd&outputFormat=json")


# obtain the coordinates
as.data.frame(st_coordinates(municipalBoundaries$geometry))

df <- municipalBoundaries$statnaam
df<- as.data.frame(df)

df_xy <- municipalBoundaries%>%
  select(statnaam,geometry) %>%
  st_centroid()%>%
  st_coordinates()



state <- cbind(df,df_xy)%>%
  filter(df%in%c("Amsterdam","The Hague",
                 "Utrecht","Rotterdam",
                 "Eindhoven",
                 "Groningen","Breda",
                 "Apeldoorn"))



library(showtext)
library(extrafont)
#fonts()
#loadfonts()
font_add_google("Roboto Condensed","RobotoCondensed")
showtext_opts(dpi = 320)
showtext_auto(enable = T)



# Link data from Statistics Netherlands to geodata
data_house <-
  municipalBoundaries %>%
  left_join(data_house, by=c(statcode="WijkenEnBuurten"))

# Create a thematic map
plot <- data_house %>%
  ggplot() +
  geom_sf(aes(fill = schools)) +
  geom_text(data=state,aes(x=X,y=Y,label=df),
            color="gold",fontface="bold",family="RobotoCondensed")+
  scale_fill_gradient(low="#c97d2c",high = "darkblue")+
  labs(title = "The Netherlands: Hurban and Rural",
       subtitle="Schools near by...",
       caption="Datasource: cbs.nl opendata - #30DayMapChallenge\nGraphics: Federica Gazzelloni\n",
       fill = "Schools") +
  coord_sf()+
  theme_void()+
  theme(text = element_text(color="gold",face="bold",family="RobotoCondensed"),
        plot.background = element_rect(color = "grey20",fill="grey60",size=2),
        legend.position = c(0.1,0.08),
        plot.caption = element_text(hjust=0.5,size=11),
        plot.caption.position = "panel",
        plot.title = element_text(size=25,hjust=0.2,vjust=-1.5),
        plot.subtitle = element_text(size=18,hjust=0.06,vjust=-1))


library(cowplot)
final <- cowplot::ggdraw(plot)+
  draw_label("The Hague",x=0.4,y=0.5,color="gold",
             fontface = "bold",fontfamily="RobotoCondensed")


# save final plot
ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day15_urban_rural/urban_rural.png"),
              res = 320, width = 12, height = 8, units = "in")
final
dev.off()



# data for oland capitals

library(readr)

nl <- read_csv("R_general_resources/30DayMapChallenge/day15_urban_rural/nl.csv")


nl%>%count(city,population)%>%arrange(-population)

nl%>%
  filter(!lat<20)%>%
  ggplot(aes(x=lng,y=lat))+
  geom_point()+
  ggrepel::geom_text_repel(aes(label=capital))



