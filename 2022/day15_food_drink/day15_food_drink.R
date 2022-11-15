#30DayMapChallenge 2022 Day 15: Food drink
# Author: Federica Gazzelloni


# source: https://www.r-bloggers.com/2016/10/mapping-efsas-food-consumption-data-with-tmap/
# updates https://rdrr.io/cran/tmaptools/man/deprecated_functions.html

# foodborne outbreak
# https://www.efsa.europa.eu/en/microstrategy/FBO-dashboard

library(tidyverse)
df <- readxl::read_excel("data/FBO_dashboard_2015-2020.xlsx", 
                                      skip = 2)
df1 <- df%>%
  select(1,contains("outbreak"))


names(df1) <- c("country",unlist(df1[1,2:23]))
df2 <- df1%>%
  filter(!is.na(country))

df2%>%head  

df2[is.na(df2)]<-"0"

df3 <- df2%>%
  select(-country)%>%
  mutate(across(where(is.character),as.numeric))%>%
  cbind(country=df2$country)%>%
  relocate(country)%>%
  #select(-"0") %>%
  pivot_longer(cols = 2:23,names_to="agent",values_to="values")%>%
  mutate(agent=case_when(str_detect(agent,"other|Other|unknwon|Unknown")~"Other",
                         TRUE~agent)) %>%
  filter(!agent=="Other") 


  
library(tmap)
data("World")

EU <- World%>%
  filter(continent=="Europe")

# EU %>%names

library(tmap)
tm_shape(EU)+tm_polygons()+tm_text('name',size = .1,
                                   col = "black",
                                   bg.color = "white") 

setdiff(df3$country,EU$name)  
setdiff(EU$name,df3$country)  

# df3%>%count(country)%>%View

df4 <- df3%>%
  mutate(country=case_when(str_detect(country,"Bos")~"Bosnia and Herz.",
                           country=="Czechia"~"Czech Rep.",
                           country=="Republic of North Macedonia"~"Macedonia",
                           TRUE~country))%>%
  filter(!country%in%c("Cyprus","Malta"))

setdiff(df4$country,EU$name)  
setdiff(EU$name,df4$country) 


library(rgdal)
library(raster) 

df5 <- df4%>%
  group_by(country)%>%
  summarise(agents_mean=mean(values)) %>%
  ungroup()

eu1 <- EU%>%
  filter(!name%in%c("Albania","Belarus",
                    "Kosovo","Moldova",
                    "Russia","Slovenia",
                    "Ukraine"))%>%
  left_join(df5,by=c("name"="country"))

library(sf)
eu1%>%st_bbox()

all <- World%>%
  left_join(df5,by=c("name"="country"))

library(tmap)
tmap_mode("plot")
data(World, metro, rivers, land)


spread_df <-  df3%>%
    spread(agent,values)%>%
    mutate(country=case_when(str_detect(country,"Bos")~"Bosnia and Herz.",
                             country=="Czechia"~"Czech Rep.",
                             country=="Republic of North Macedonia"~"Macedonia",
                             TRUE~country))%>%
    filter(!country%in%c("Cyprus","Malta"))
    

df_map<-  EU%>%
    filter(!name%in%c("Albania","Belarus",
                      "Kosovo","Moldova",
                      "Russia","Slovenia",
                      "Ukraine"))%>%
    left_join(spread_df,by=c("name"="country"))


df_map%>%st_bbox()
bbox <- c(xmin=-34.524754,
          ymin=20.053389,
          xmax=31.516092,
          ymax=80.657144)
       

map <- tm_shape(df_map,bbox=bbox) +
  tm_polygons(col='Campylobacter',
              title = "Agents") +
  tm_text('iso_a3',
          fontfamily = "Roboto Condensed",
          root = 2,
          size = .5,
          col = "black",
          bg.color = "white") +
  tm_credits(
    text="#30DayMapChallenge 2022 Day 15: Food/drink\nDataSource: www.efsa.europa.eu | Map: Federica Gazzelloni",
    align = "center",
    size=4,
    fontface = "bold",
    fontfamily = "Roboto Condensed",
    position = "center")+
  tm_scale_bar(text.size = 0.5,width = 0.4,
               position = c(0.5,0.1))+
  tm_style("natural", 
           inner.margins = .01)+
  tm_layout(title="European countries\nFoodborne Campylobacter outbreaks",
            main.title.fontfamily="Roboto Condensed",
            legend.text.size=0.8,
            legend.text.fontfamily="Roboto Condensed",
            legend.just = 2,
            legend.width = 0.4)


tmap_save(map,"day15_food_drink.png",width = 6.58,
          height=7.24
          ) # Saving 6.58 x 7.24 in image

