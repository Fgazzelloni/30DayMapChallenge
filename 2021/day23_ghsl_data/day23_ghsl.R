#30DayMapChallenge 23 Data Challenge 3: GHSL
#Italy 1km resolution, population in 2015

#Data source
#https://cidportal.jrc.ec.europa.eu/ftp/jrc-opendata/GHSL/GHS_POP_MT_GLOBE_R2019A/GHS_POP_E2015_GLOBE_R2019A_54009_1K/V1-0/GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0.zip
#https://cidportal.jrc.ec.europa.eu/ftp/jrc-opendata/GHSL/GHS_POP_MT_GLOBE_R2019A/GHS_POP_E1975_GLOBE_R2019A_54009_1K/V1-0/GHS_POP_E1975_GLOBE_R2019A_54009_1K_V1_0.zip
# https://gist.github.com/leeolney3/61f88791b70a4781aa62717ce77d4d70
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(raster)
library(tidyverse)
library(ggtext)

pop2015 = raster(here::here("day23_ghsl_data/GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0.tif"))

it = ne_countries(scale=10,country = 'italy', returnclass = "sf")
it2 = st_transform(it, crs(pop2015))

# reduce the raster to it data
it_crop = raster::crop(pop2015, raster::extent(it2))
it_mask = raster::mask(it_crop, it2)
it_df = as.data.frame(it_mask, xy=TRUE)

it_df2<-it_df%>%
  rename(year_2015=3)%>%
  dplyr::filter(!is.na(year_2015))


library(extrafont)
loadfonts()
font="Roboto Condensed Light"


ragg::agg_png(here::here("/Users/federica/Documents/R/R_general_resources/30DayMapChallenge/day23_ghsl_data/ghsl.png"),
              res = 320, width = 6, height = 6, units = "in")
ggplot() +
  geom_raster(data=it_df2,
              aes(x=x, y=y, fill=year_2015)) +
  colorspace::scale_fill_continuous_sequential(palette = "PuBuGn", begin = 0.9, end = 0.4,
                                               breaks=c(0,200,20000),
                                               trans="pseudo_log",
                                               labels=scales::comma)+
  theme_void() +
  coord_fixed() +
  theme(text = element_text(color="#FCB9B2",family=font),
        plot.background = element_rect(fill="#151E3F", color=NA),
        legend.position="top",
        legend.justification = "center",
        plot.title=element_markdown(lineheight=1.3, size=25, hjust = .5),
        plot.caption=element_text(size=8, margin=margin(t=-5,b=10), hjust=.5,color="#FCB9B2"),
        plot.margin=margin(.3,0,0,0, unit="cm"),
        legend.margin=margin(t=-5)
  ) +
  guides(fill = guide_colorbar(title.position = "top",
                               barwidth = unit(11, "lines"),
                               barheight = unit(.4, "lines"))) +
  labs(fill="",
       title="Population in Italy - 2015",
       caption="Data source: Global Human Settlement Layer (GHSL) data #30DayMapChallenge
       Map: Federica Gazzelloni")
dev.off()
