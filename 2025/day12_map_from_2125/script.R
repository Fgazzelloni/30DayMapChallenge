
```{r}
hex_summary <- hex_sf %>%
  group_by(geometry) %>%
  summarize(expected = sum(expected_deaths, na.rm = TRUE))
```



```{r}
# Convert to sf points
pts <- st_as_sf(world, coords = c("lon", "lat"), crs = 4326)
```



### Create wildfire density raster (kernel density)
```{r}
# # Create a base raster
# r_template <- rast(
#   extent(fires_sf),
#   resolution = 20000,       # 20 km cells
#   crs = "EPSG:3857"
# )
# 
# # Rasterize fire points (count per cell)
# fire_rast <- rasterize(
#   vect(fires_sf),
#   r_template,
#   field = 1,
#   fun = "count",
#   background = 0
# )
# 
# # Smooth using focal moving window (Gaussian-ish)
# w <- matrix(1, 5, 5)
# fire_density <- focal(fire_rast, w = w, fun = "mean", na.rm = TRUE)
# 
# # Normalize 0–1 for mapping
# fire_density_norm <- (fire_density - global(fire_density, "min", na.rm = TRUE)[1]) /
#                      (global(fire_density, "max", na.rm = TRUE)[1] -
#                       global(fire_density, "min", na.rm = TRUE)[1])
```
### Transform everything to Equal Earth

```{r}
# crs_equal_earth <- "ESRI:54034"
# 
# world_ee  <- st_transform(world, crs_equal_earth)
# fires_ee  <- st_transform(st_as_sf(coords_dt,
#                                    coords = c("longitude","latitude"),
#                                    crs = ), 
#                           crs_equal_earth)
# fires_den <- project(fire_density_norm, crs_equal_earth)

# Convert raster to data frame for ggplot
# fires_df <- as.data.frame(fires_den, xy = TRUE)
# names(fires_df)[3] <- "density"
```

```{r}
library(sf)
library(dplyr)
library(ggplot2)
library(viridis)

#--------------------------------
# 1. Load global expected deaths data
#--------------------------------
# Replace with your file
# Example structure assumed:
# country, lat, lon, expected_deaths

df <- read.csv("expected_fire_deaths_2023.csv")



#--------------------------------
# 2. Build global hex grid
#--------------------------------
# World boundary (naturalearth)
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")

# Project world to equal area
world_eq <- st_transform(world, 8857) # Equal Earth projection

# Transform points as well
pts_eq <- st_transform(pts, 8857)

# Hex grid (approx. 200km cells, adjust for detail)
hex <- st_make_grid(world_eq, cellsize = 200000, what = "polygons", square = FALSE)

hex_sf <- st_sf(geometry = hex)

#--------------------------------
# 3. Spatial join + aggregate
#--------------------------------
joined <- st_join(hex_sf, pts_eq, left = FALSE)

hex_summary <- joined %>%
  group_by(geometry) %>%
  summarize(expected = sum(expected_deaths, na.rm = TRUE))

#--------------------------------
# 4. Plot
#--------------------------------
ggplot() +
  geom_sf(data = world_eq, fill = "gray90", color = NA) +
  geom_sf(data = hex_summary, aes(fill = expected), color = NA) +
  scale_fill_viridis(option = "magma", direction = -1) +
  theme_void() +
  labs(
    title = "Expected Deaths Due to Fire, 2023",
    subtitle = "Global hex‐grid representation (GBD 2023 Study)",
    fill = "Expected\nDeaths"
  )

```



