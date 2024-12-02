# Building a collage of all images
library(tidyverse)

dirs <- list.dirs("~/Documents/R/R_general_resources/EDA_and_maps/30DayMapChallenge/2024")
files <- list.files(dirs)

#Get the list of all images: (".jpg", ".png", etc) 
allFiles <- list.files(dirs,
                      pattern = "png|gif|jpg", 
                      full.names = T)

library(fs)
all_images<- allFiles %>% 
  path() %>%
  as_tibble() %>%
  mutate(fullpath = value,
         filename = basename(value))

all_images1<-all_images %>%
  mutate(id=parse_number(filename),
         id=trimws(id,which = "both"),
         id=as.numeric(id))

library(gt)
library(gtExtras)  

tb_images <- matrix(all_images1$fullpath,
                    ncol=5,
                    byrow = TRUE)%>%
  as.data.frame() %>% 
  gt::gt()%>%
  gt_theme_538() %>%
  tab_header(title = html("<strong>#30DayMapChallenge 2024</strong>")) %>%
  tab_source_note(source_note = md("by Federica Gazzelloni"))%>%
  tab_options(column_labels.hidden = TRUE) %>%
  gtExtras::gt_img_rows(columns=V1, 
                        img_source = "local", 
                        height = 100)%>%
  gtExtras::gt_img_rows(columns=V2, 
                        img_source = "local", 
                        height = 100)%>%
  gtExtras::gt_img_rows(columns=V3, 
                        img_source = "local", 
                        height = 100)%>%
  gtExtras::gt_img_rows(columns=V4, 
                        img_source = "local", 
                        height = 100) %>%
  gtExtras::gt_img_rows(columns=V5, 
                        img_source = "local", 
                        height = 100) 


library(webshot2)
tb_images %>%
  gtsave_extra("~/Documents/R/R_general_resources/EDA_and_maps/30DayMapChallenge/2024/collage2024.png",
               vwidth = 1400)

