# #30DayMapChallenge 2022 Day 3: Polygons
# Author: Federica Gazzelloni

# census tracts
# source: https://walker-data.com/census-r/mapping-census-data-with-r.html

# load libraries
library(tidyverse)
#library(kableExtra)
library(tidycensus)
options(tigris_use_cache = TRUE)

# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Poor Story",family="Poor Story")

# Census API key
# census_key <- "bd6ed5f4a30d3672816bb179889338b50ca87a3f"
# census_api_key(census_key, install = TRUE)

# Find census data
# https://api.census.gov/data.html

# Dataset used to identify geography availability in the 5-year ACS Detailed Tables
acs5_vars <- load_variables(2020, "acs5")
# save(acs5_vars,file="data/acs5_vars.RData")
############## PRIVATE HEALTH INSURANCE ############## 
# female
# select the variable of interest: B27002_030
acs5_vars%>%
  filter(geography=="tract",
         concept=="PRIVATE HEALTH INSURANCE STATUS BY SEX BY AGE",
         label=="Estimate!!Total:!!Female:") 


private_h_insurance_f <- get_acs(
  geography = "tract", 
  variables = "B27002_030",
  state = "NY", # fips 41
  year = 2020,
  geometry = TRUE
)
# save(private_h_insurance_f,file="data/private_h_insurance_f.RData")

# male
# select the variable of interest: B27002_002
acs5_vars%>%
  filter(geography=="tract",
         concept=="PRIVATE HEALTH INSURANCE STATUS BY SEX BY AGE",
         label=="Estimate!!Total:!!Male:") 


private_h_insurance_m <- get_acs(
  geography = "tract", 
  variables = "B27002_002",
  state = "NY", # fips 41
  year = 2020,
  geometry = TRUE
)
# save(private_h_insurance_m,file="data/private_h_insurance_m.RData")

# Map
ggplot(private_h_insurance_f) +
  geom_sf(aes(fill=estimate),
          size=0.2,
          show.legend = T) +
  scale_fill_gradient2(name="Female",
                       low="white",mid="grey80",high="navy")+
  geom_sf(data = private_h_insurance_m, 
          aes(color=estimate),
          size=0.2,
          fill=NA)+
  scale_color_gradient2(name="Male",
                        low="white",mid="grey40",high="gold")+
  labs(title="Private health insurance status in New York",
       subtitle="Female and Male all ages",
       caption="5-year ACS Detailed Tables - Year 2020\n#30DayMapChallenge 2022 Day 3: Polygons\nDataSource: census.gov | Map: Federica Gazzelloni (@fgazzelloni)") +
  ggthemes::theme_map() +
  theme(text = element_text(family="Poor Story"),
        plot.caption = element_text(lineheight = 1.5),
        legend.position = c(0.85,0.3),
        #legend.direction = "horizontal",
        legend.background = element_blank(),
        legend.text = element_text(size=6),
        legend.key.size = unit(8,units = "pt"))


# ggsave("day3_polygons.png",
#        bg="white",
#        dpi=200)
