#30DayMapChallenge 2022 Day 14: Hexagons
# Author: Federica Gazzelloni

# Load the library
library(tidyverse)
library(geojsonio)
library(sf)
# Set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Island Moments",
                family="Island Moments")



us_covid <- read_csv("~/Documents/R/R_general_resources/30DayMapChallenge/2022/day14_hexagons/data/covid_cases_by_County.csv")


covid_data <- us_covid%>%
  select(county,
         county_fips,
         state,
         county_population,
         covid_cases_per_100k) %>%
  distinct()


# source: https://walker-data.com/tidycensus/reference/get_decennial.html
library(tidycensus)
options(tigris_use_cache = TRUE)


tarr <- get_acs(geography = "county",
                variables = "B19013_001",
                geometry = TRUE, 
                year = 2020)

# save(tarr,file="data/tarr.RData")
load("data/tarr.RData")

tarr%>%count(NAME)

tarr2 <- tarr%>%
  separate(NAME,into=c("county","name"),remove=F,sep=",")


coords <- tarr2%>%
  st_centroid() %>%
  st_coordinates() 

# check the dimensions
tarr2%>%dim
coords%>%dim
covid_data%>%dim

full <- cbind(tarr2,coords)

df <- covid_data%>%
  left_join(full,by=c("county"="county")) %>%
  distinct()%>%
  mutate(county=as.factor(county))

df2 <- covid_data%>%
  left_join(tarr2,by=c("county"="county")) %>%
  distinct()


df3 <- df2%>%
  st_as_sf()


df%>%DataExplorer::profile_missing()
# A tibble: 12 × 3
# feature              num_missing pct_missing
# <fct>                      <int>       <dbl>
#   1 county                         0  0         
# 2 county_fips                    0  0         
# 3 state                          0  0         
# 4 county_population              1  0.00000180
# 5 covid_cases_per_100k           0  0         
# 6 GEOID                       4911  0.00884   
# 7 NAME                        4911  0.00884   
# 8 name                        4911  0.00884   
# 9 variable                    4911  0.00884   
# 10 estimate                    4987  0.00898   
# 11 moe                         4987  0.00898   
# 12 geometry                       0  0   



  ggplot()+
# geom_point(data= df, aes(X,Y),inherit.aes = F)+
  stat_summary_hex(data= df, aes(x=X,y=Y,z=covid_cases_per_100k),
           linewidth=0.01,
           inherit.aes = F)+
    geom_sf(data=tarr2,aes(geometry=geometry),
            fill=NA,
            linewidth=0.05)+
   coord_sf(xlim = c(-125,-68),ylim = c(20,50))+
    scale_fill_viridis_c(option = "H")+
    labs(title="United States of America",
         subtitle = "Covid Cases per 100k",
         fill="Value",
         caption="#30DayMapChallenge 2022 Day 14: Hexagons\nDataSource: CDC Covid data & Census data from {tidycensus}\nMap: Federica Gazzelloni (@fgazzelloni)")+
    ggthemes::theme_map()+
    theme(plot.caption = element_text(lineheight = 1.5,size=5),
          plot.title = element_text(size=14),
          legend.background = element_blank())

  
  ggsave("day14_hexagons.png",
         bg="grey90",
         width=6.78,
         height = 5.78,
         dpi=200)
    









