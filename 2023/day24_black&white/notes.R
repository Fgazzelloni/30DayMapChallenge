# 30DayMapChallenge | November 8, 2023 | Africa

# libraries ---------------------------------------------------------------
library(tidyverse)
library(showtext)
library(maps)
library(sf)
library(DescTools)
library(sysfonts)

# add font ----------------------------------------------------------------
font_add_google(name = "Besley", family = "Besley")
font <- "Besley"

# turn on showtext --------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320)

# get map boundary data ---------------------------------------------------
ghana <- map_data('world')[map_data('world')$region == "Ghana",] 

# get the bounding box of points ------------------------------------------
# Calculate the range of longitude and latitude
min_lon <- min(ghana$long)
max_lon <- max(ghana$long)
min_lat <- min(ghana$lat)
max_lat <- max(ghana$lat)

# calculate the grid of points --------------------------------------------
df_points <- expand_grid(x = seq(from = min_lon, to = max_lon, length.out = 100),
                         y = seq(from = min_lat, to = max_lat, length.out = 100))

# get the outline of points of map ----------------------------------------
ghana_map_line <- ghana %>% 
  select(1:2) %>% 
  rename(x = long, y = lat)

# calculate the points from the grid within the bounding box line ---------

# seed
set.seed(777)

# kente colors
colors <- c("#00aff0", "#000000", "#fec000", "#00af50", "#ffff00", "#a6a6a6", "#f15be9", "#fafbfc", "#6c3b2b", "#ff0000", "#70309f", "#c0c0c0")

# create data frame for plotting ------------------------------------------
map_df <- data.frame(PtInPoly(df_points, ghana_map_line)) %>% 
  filter(pip == 1) %>% 
  group_by(y) %>% 
  mutate(id = cur_group_id()) %>%
  mutate(color = sample(colors, 1, replace = TRUE)) %>%
  ungroup()

# create plot -------------------------------------------------------------
ggplot() +
  geom_path(data = map_df, aes(x, y, group = id, color = color), 
            linewidth = 1.3) +
  scale_color_identity() +
  annotate("text", y = 11, x = -4.35, label = "G\nh\na\nn\na", lineheight = 0.75,
            fontface = "bold", size = 14, color = "#000000", vjust = "top") +
  annotate("text", y = 7.4, x = -4.6, label = "Kente\ncloth\ncolors", 
           lineheight = 0.9, size = 6, color = "#000000", vjust = "top", hjust = "left") +
  scale_x_continuous(limits = c(-4.7, NA)) +
  coord_map() +
  theme_void() +
  theme(plot.caption = element_text( hjust = 0.5, size = 7, color = "#000000", margin = margin(t = 25)),
        plot.caption.position = "plot",
        plot.margin = unit(c(0.5, 1, 1, 1), "cm"),
        panel.background = element_rect(color = NA, fill = "#f7f7f5"),
        plot.background = element_rect(color = NA, fill = "#f7f7f5")) +
  labs(caption = "#30DayMapChallenge | Day 8: Africa | Design: Ryan Hart")

# save plot ---------------------------------------------------------------
ggsave(paste0("ghana_kente_colors_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, width = 6, height = 6)