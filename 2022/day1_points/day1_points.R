#30DayMapChallenge 2022 day 1: Points
# author: Federica Gazzelloni


# load the libraries
library(tidyverse)
library(geoR)
library(sf)
library(afrilearndata)
library(cowplot)

# set the fonts
library(showtext)
library(sysfonts)
library(extrafont)
showtext::showtext_auto()
showtext::showtext_opts(dpi=320)
font_add_google(name = "Mukta",family="Mukta")


# load data and transform UTM coords into Lat and Long 
# data(package="geoR")
# ?gambia
# gambia %>% head

gambia1 <- gambia %>%
  select(x,y) %>%
  sf::st_as_sf(coords = c(1,2), 
               crs = "+proj=utm +zone=28") %>%
  # utm tranformation to longlat
  sf::st_transform(crs = "+proj=longlat +datum=WGS84")  %>%
  sf::st_coordinates() %>%
  cbind(gambia) %>%
  rename(long=X,lat=Y) 


# gambia.borders
# gambia.borders %>%DataExplorer::profile_missing()
# NA in the borders coords 
st_write(gambia.borders,
        "gambia_borders.csv",
         layer_options = "GEOMETRY=AS_XY")
  
# replacing null geometries with empty geometries
gambia.borders2 = st_read("gambia_borders.csv",
                          options = c("X_POSSIBLE_NAMES=X",
                                      "Y_POSSIBLE_NAMES=Y"),
                          crs="+proj=utm +zone=28") 
  
gambia.borders3 <- gambia.borders2 %>%
  sf::st_as_sf(coords = c(1,2), 
              crs = "+proj=utm +zone=28") %>%
  # utm tranformation to longlat
  sf::st_transform(crs = "+proj=longlat +datum=WGS84") 
           
 
gambia.borders4 <- gambia.borders3 %>%
  sf::st_coordinates() %>%
  as.data.frame()%>%
  rename(long=X,lat=Y) 
  

# check the bbox
# bbox = left,bottom,right,top
# bbox = min Longitude , min Latitude , max Longitude , max Latitude 
# gambia.borders3%>%
#  st_bbox()
  

# make the map
map <- gambia1 %>%
  filter(pos==1) %>%
  ggplot(aes(long,lat)) +
  geom_point(shape=21,stroke=0.5,size=2,color="grey40") +
  geom_point(aes(color=age)) +
  geom_point(data=gambia1 %>%
               filter(pos==1,phc==1) ,
             inherit.aes = TRUE,
             shape="H",stroke=0.1,size=2,color="red") +
  coord_map()+
  scale_color_gradient2() +
  geom_path(data = gambia.borders4, aes(long,lat),size=0.1)+
  labs(title="Malaria prevalence in children",
       subtitle="data recorded at villages in The Gambia, Africa",
       caption="#30DayMapChallenge 2022 day 1 Points\nDataSource: Gambia data from {geoR} package\nMap: Federica Gazzelloni",
       color="Age in days")+
  ggthemes::theme_map()+
  theme(text=element_text(family="Mukta"),
        legend.position = c(0.1,-0.1),
        legend.direction = "horizontal",
        legend.background = element_blank(),
        legend.key.size = unit(10,units="pt"),
        legend.text = element_text(size=4),
        legend.title = element_text(size=5),
        plot.title = element_text(vjust=3,hjust=0.5),
        plot.subtitle = element_text(vjust=3,hjust=0.5),
        plot.caption = element_text(vjust=-9,hjust=0.5),
        plot.title.position = "panel",
        # margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")
        plot.margin = margin(10,1,20,1,unit = "pt"),
        plot.background = element_rect(color = "black",fill="grey95",size=0.05),
        panel.background = element_rect(color = "grey95",fill="grey95"))



# add a little Africa on a side
# remotes::install_github("afrimapr/afrilearndata")
# library(afrilearndata)
afr_sf <- afrilearndata::africountries
# afr_sf%>%head

gamb_sf <- afr_sf%>%filter(name_sw=="Gambia")

afrimap<-   ggplot()+
  geom_sf(data=afr_sf,
          aes(fill=pop_est),
          size=0.1,
          show.legend = F,alpha=0.1) +
  geom_sf(data=gamb_sf,
          fill="brown",alpha=0.9)+
  theme_void()


# draw the plot
cowplot::ggdraw()+
  draw_plot(map)+
  draw_plot(afrimap,scale = 0.2,
            x=0.3,y=0.25)


# save it
ggsave("day1_points.png",
       dpi=300,
      bg="grey95",
       width = 6,height = 3.5)