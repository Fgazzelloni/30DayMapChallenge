# Collage Maker

setwd(rstudioapi::getActiveProject())

library(tidyverse)
library(magick)


## get paths to single topic collections
paths <- list.dirs(path = "2024", 
                   full.names = TRUE, 
                   recursive = TRUE)
# List all image files in the directory
image_files <-  list.files(path = paths, 
                           pattern = "\\.(png|jpg)$", 
                           full.names=TRUE)

# Reorder the images by their file name
image_files <- image_files %>%
  as_tibble() %>%
  mutate(filename = basename(value),
         id=parse_number(filename),
         id=trimws(id,which = "both"),
         id=as.numeric(id)) %>%
  arrange(id)  # Sort by file name

images <- image_files$value

# Read all images
images <- lapply(images, image_read)

# Define the grid dimensions (e.g., 6 columns)
cols <- 6
rows <- ceiling(length(images) / cols)

# Combine images into a single image
collage <- image_montage(
  image_join(images),
  tile = paste0(cols, "x", rows),  # Specify the grid (cols x rows)
  geometry = "500x500+1+1"        # Adjust size (300x300 pixels per image) and spacing (+2 pixels)
)

# Save the collage
image_write(collage, 
            path = "collage/collage2024.png", 
            format = "png")

