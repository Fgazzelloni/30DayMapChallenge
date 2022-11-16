#30DayMapChallenge 2022 Day 16: Minimal
# Author: Federica Gazzelloni


library(tidyverse)
library(spData)
library(RColorBrewer)
library(rcartocolor)

# Load libraries
# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Kanit",
                family="Kanit")



my_df <- spData::boston.c
my_df %>%
  ggplot(aes(x=LON,y=LAT,group=MEDV))+
  geom_hex(aes(fill=MEDV),
           size=0.05,
           color="grey20",
           bins=60,
           alpha=0.8)+
  coord_equal()+
  labs(title="\nBoston Housing",
       subtitle="UTM Zone 19",
       caption="Median values of owner-occupied housing in USD 1000\n#30DayMapChallenge 2022 Day 16: Minimal\nDataSource: Boston Housing from {spData::boston.c}\nMap: Federica Gazzelloni")+
  scico::scale_fill_scico(palette = "lajolla")+
  ggthemes::theme_map()+
  theme(text = element_text(family="Kanit",color="gold"),
        plot.title = element_text(size=20),
        legend.background = element_blank())


ggsave("day16_minimal.png",
       bg="black",
       width = 8.25,
       height = 6.31,
       dpi=280)





