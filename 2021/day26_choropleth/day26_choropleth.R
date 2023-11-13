#30DayMapChallenge 26 Choropleth map


# Inspiration:
# https://gist.github.com/leeolney3/8f26d720c1884fccab282bad23dc6038

rm(list=ls())

library(tidyverse)
library(sf)
library(biscale)
library(cowplot)

library(sysfonts)
library(showtext)
showtext_opts(dpi = 320)
font_add_google("Covered By Your Grace", "grace")
showtext_auto()
f1= "grace"
f2= "grace"

######################################
# datasource: https://datacatalog.worldbank.org/search/dataset/0042041/International-Poverty-Line---Subnational-Poverty



# 1. poverty data
# https://datacatalog.worldbank.org/search/dataset/0042041/International-Poverty-Line---Subnational-Poverty
# for example poor190_ln means Poverty rate at $1.9
library(readxl)
poverty_data <- read_excel("day26_choropleth/data/global-subnational-poverty-atlas-gsap-data.xlsx")
poverty_data%>%head

# 2. population data
library(readr)
Population_EstimatesData <- read_csv("day26_choropleth/data/Population-EstimatesData.csv")
Population_EstimatesData%>%head



# Join the sets
my_df <- poverty_data%>%
  select(region,code,contains("poor"), median_ln,mean_ln) %>%
  pivot_longer(cols=starts_with("poor"),names_to="poor_cat",values_to="poor_rate") %>%
  pivot_longer(cols=starts_with("npoor"),names_to="npoor_cat",values_to="poor_numb")



my_df2 <- Population_EstimatesData%>%
  janitor::clean_names()%>%
  select(country_name,country_code,starts_with("x"))%>%
  pivot_longer(cols=contains("x"),names_to="year",values_to="pop") %>%
  mutate(year=gsub("x","",year))%>%
  filter(year>2000,year<2021) %>%
  group_by(country_name,country_code,year)


my_df2$pop[is.na(my_df2$pop)]<-0


my_df3 <- my_df2%>%
  group_by(country_name,country_code,year)%>%
  summarize(tot_pop=sum(pop),.groups="drop")%>%
  ungroup()


# 3. map
# load data
library(tmap)
data("World")

my_df4 <- my_df3%>%
  left_join(my_df,by=c("country_code"="code"))%>%
  left_join(World %>%select(country_code=iso_a3,geometry),by="country_code")



my_df5 = bi_class(my_df4,
                  x=tot_pop,
                  y=poor_numb,
                  style = "quantile", dim = 3)


map = ggplot() +
  geom_sf(data=my_df5,
          aes(fill=bi_class, geometry=geometry),
          size=.1,show.legend=F, color="white") +
  bi_scale_fill(pal="GrPink", dim=3) +
  coord_sf(expand=F) +
  theme_void() +
  theme(plot.background = element_rect(fill="#212A2E", color=NA))

# save map plot
ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day26_choropleth/map.png"),
              res = 320, width = 12, height = 8, units = "in")
map
dev.off()

############################## ############################## ##############################

legend = bi_legend(pal = "GrPink",
                   dim = 3,
                   ylab = "Vunerables in the area",
                   xlab = "Population density",
                   size = 2.5) +
  theme(panel.border = element_blank(),
        axis.text = element_blank(),
        axis.title.x = element_text(size = 16, family=f1, hjust=0,
                                    color = "white", margin=margin(t=-5)),
        axis.title.y = element_text(size = 16, family=f1, hjust=0,
                                    color = "white", margin=margin(r=-5)),
        legend.text = element_text(size = 14),
        panel.background = element_blank(),
        panel.grid.major=element_blank(),
        plot.background = element_blank(),
        legend.text.align = 0)



library(cowplot)
p1 = ggdraw() +
  draw_image(image = here::here("day26_choropleth/data/map.png"),
             x=0,y=0,scale=2) +
  draw_plot(legend, x=0.75, y=0.05, width= 0.3, height= 0.3) +
  draw_line(x = c(-0.1, 0.36),y = c(0.95, 0.95),color = "#212A2E", size = 30) +
  draw_label("World focus on:", x=0.02, y=0.92,
             fontfamily = f2, hjust=0, vjust=0,size=52, color="white", fontface="bold") +
  draw_label("Population density per sq mile\n\nand\n\nNumber of vulnerable people\n\nin the area",
             x=0.13, y=0.55,
             fontfamily = f2, hjust=0, vjust=0, size=22, color="white",
             lineheight = 0.4) +
  draw_label("Datasource: datacatalog.worldbank.org | #30DayMapChallenge choropleth\nGraphic: Federica Gazzelloni ",
             x=0.5, y=0.05, size = 18, fontfamily = f2, color="white") +
  theme(plot.background = element_rect(fill="#212A2E", color=NA),
        panel.background = element_rect(fill="#212A2E", color=NA),
        plot.margin=margin(.5,.5,.5,.5, unit="cm"))

# save final plot
ragg::agg_png(here::here("day26_choropleth/choropleth.png"),
              res = 320, width = 12, height = 8, units = "in")
p1
dev.off()






