

library(tidyverse)
library(sf)
library(tigris)
library(rayshader)
library(PrettyCols)
library(stars)

# inspiration:
# https://github.com/Pecners/30DayMapChallenge/blob/main/R/day_21_kontur/colorado.R

# url <- "https://geodata-eu-central-1-kontur-public.s3.amazonaws.com/kontur_datasets/kontur_population_US_20220630.gpkg.gz"
# downloader::download(url, dest="data/kontour_pop_cr.zip", mode="wb") 

data <- st_read("data/kontur_population_US_20220630.gpkg")
# save(data,file="data/data.RData")

s <- tigris::states() |> 
  st_transform(crs = st_crs(data))
# save(s,file="data/s.RData")

s%>%count(NAME)

or <- s |> 
  filter(NAME == "Oregon")


or_d <- st_intersection(data, or)
# save(or_d,file="data/or_d.RData")
load("data/or_d.RData")

bb <- st_bbox(or_d)
yind <- st_distance(st_point(c(bb[["xmin"]], bb[["ymin"]])), 
                    st_point(c(bb[["xmin"]], bb[["ymax"]])))
xind <- st_distance(st_point(c(bb[["xmin"]], bb[["ymin"]])), 
                    st_point(c(bb[["xmax"]], bb[["ymin"]])))

xind / yind

size <- 2500
rast <- st_rasterize(or_d |> 
                       select(population, geom),
                     nx = floor(size * (xind/yind)), ny = size)
# save(rast,file="data/rast.RData")
load("data/rast.RData")

mat <- matrix(rast$population, 
              nrow = floor(size * (xind/yind)), 
              ncol = size)

pal <- "pink_greens"

c1 <- prettycols("TangerineBlues")
colors <- c(c1[c(6:8, 2:4)])
# swatchplot(colors)

scico::scico_palette_show()
colors <- scico::scico(6,palette="bamako")

texture <- grDevices::colorRampPalette(colors, bias = 2)(256)
# swatchplot(texture)

rgl::rgl.close()

mat |> 
  height_shade(texture = texture) |> 
  plot_3d(heightmap = mat, 
          solid = FALSE,
          soliddepth = 0,
          z = 20,
          shadowdepth = 0,
          windowsize = c(800,800), 
          phi = 90, 
          zoom = 1, 
          theta = 0, 
          background = "white") 

rayshader::render_camera(phi = 50, 
                         zoom = .85, 
                         theta = 45)
render_snapshot(title_text = "#30DayMapChallenge Day 28:3D | Graphics: @fgazzelloni\n\nOregon Population density, US",
                title_color = "navy",
                title_font = "Comic Sans",
                title_size = 25,
                title_bar_alpha = 0.5,
                title_bar_color = "#a5a7c4",
                vignette = 0.2,
                filename = "day28_3D2.png")




