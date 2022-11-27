#30DayMapChallenge 2022 Day 27: Music
# Author: Federica Gazzelloni


library(tidyverse)
library(sf)


# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name="Syne Mono",
                family="Syne Mono")




artists <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-27/artists.csv')

states <- map_data("state")

states <- rnaturalearth::ne_states(country ="united states of america",
                                   returnclass = "sf") %>%
  filter(!name=="Alaska")


states%>%
  ggplot()+
  geom_sf()


my_states <- artists%>%
  count(state)%>%
  pull(state)

artists1 <- artists%>%
  rename(name=state)%>%
  group_by(race) %>%
  mutate(artists_avg=log10(mean(artists_n,na.rm = TRUE)))%>%
  ungroup()

artists1%>%DataExplorer::profile_missing()

full <- states %>%
  filter(name%in%my_states) %>%
  merge(artists1,by="name")
  
full %>%
  ggplot()+
  geom_sf(aes(fill=artists_avg))+
  scico::scale_fill_scico("N.Artists")+
  coord_sf(xlim = c(-130,-60))+
  labs(title="US Artists",
       subtitle="states distribution by avg numbers (log tranf)",
       caption = "#30DayMapChallenge 2022 Day 27: Music\nDataSource: #TidyTuesday 2022 week 39 US Artists | Map: Federica Gazzelloni (@fgazzelloni)")+
  ggthemes::theme_map()+
  theme(text = element_text(family="Syne Mono"),
        legend.background = element_blank(),
        plot.background = element_rect(color="#6b493e",linewidth=1.5))


ggsave("day27_music.png",
       dpi=280, 
       width = 8.47,
       height =5.07)
