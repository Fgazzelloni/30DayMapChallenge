# source: https://lhehnke.github.io/notes/2018/01/27/flight-routes-night-lights


library(data.table)
library(geosphere)
library(ggplot2)
library(grid)
library(jpeg)
library(plyr)
library(tidyverse)


download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airlines.dat",
              destfile = "airlines.dat", mode = "wb")
download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat",
              destfile = "airports.dat", mode = "wb")
download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat",
              destfile = "routes.dat", mode = "wb")

# Import data
airlines <- fread("airlines.dat", sep = ",", skip = 1)
airports <- fread("airports.dat", sep = ",")
routes <- fread("routes.dat", sep = ",")

# Add column names
colnames(airlines) <- c("airline_id", "name", "alias", "iata", "icao", "callsign", "country", "active")
colnames(airports) <- c("airport_id", "name", "city", "country", "iata", "icao", "latitude", "longitude",
                        "altitude", "timezone", "dst", "tz_database_time_zone", "type", "source")
colnames(routes) <- c("airline", "airline_id", "source_airport", "source_airport_id", "destination_airport",
                      "destination_airport_id", "codeshare", "stops", "equipment")

# Convert character to numeric
routes$airline_id <- as.numeric(routes$airline_id)

# Merge airline data with data on routes
flights <- left_join(routes, airlines, by = "airline_id")

# Merge data on flights with information on airports
airports_orig <- airports[, c(5, 7, 8)]
colnames(airports_orig) <- c("source_airport", "source_airport_lat", "source_airport_long")

airports_dest <- airports[, c(5, 7, 8)]
colnames(airports_dest) <- c("destination_airport", "destination_airport_lat", "destination_airport_long")

flights <- left_join(flights, airports_orig, by = "source_airport")
flights <- left_join(flights, airports_dest, by = "destination_airport")

# Remove observations with missing values
flights <- na.omit(flights, cols = c("source_airport_long", "source_airport_lat", "destination_airport_long", "destination_airport_lat"))

#---
# Split the data into separate data sets
flights_split <- split(flights, flights$name)

flights_split%>%head
# Calculate intermediate points between each two locations
flights_all <- lapply(flights_split,
                      function(x) gcIntermediate(x[, c("source_airport_long", "source_airport_lat")],
                                                 x[, c("destination_airport_long", "destination_airport_lat")],
                                                 100,
                                                 breakAtDateLine = FALSE,
                                                 addStartEnd = TRUE,
                                                 sp = TRUE))


# Turn data into a data frame for mapping with ggplot2
flights_fortified <- lapply(flights_all, function(x) ldply(x@lines, fortify))


# Unsplit lists
flights_fortified <- do.call("rbind", flights_fortified)

flights_fortified%>%head

# Add and clean column with airline names
flights_fortified$name <- rownames(flights_fortified)
flights_fortified$name <- gsub("\\..*", "", flights_fortified$name)

saveRDS(flights_fortified,here::here("R_general_resources/30DayMapChallenge/day20_movements/flights_fortified.rds"))

flights_fortified%>%count(id)


# Extract first and last observations for plotting source and destination points (i.e., airports)
flights_points <- flights_fortified %>%
  group_by(group) %>%
  filter(row_number() == 1 | row_number() == n())

saveRDS(flights_points,here::here("R_general_resources/30DayMapChallenge/day20_movements/flights_points.rds"))


# Download NASA night lights image
download.file("https://www.nasa.gov/specials/blackmarble/2016/globalmaps/BlackMarble_2016_01deg.jpg",
              destfile = here::here("R_general_resources/30DayMapChallenge/day20_movements//BlackMarble_2016_01deg.jpg"),
              mode = "wb")

# Load picture and render
earth <- readJPEG("BlackMarble_2016_01deg.jpg", native = TRUE)
earth <- rasterGrob(earth, interpolate = TRUE)


library(extrafont)
font_import()

p<- ggplot() +
  annotation_custom(earth, xmin = -180, xmax = 180, ymin = -90, ymax = 90) +

  geom_path(aes(long, lat, group = id, color = name),
            alpha = 0.0, size = 0.0,
            data = flights_fortified) +

  geom_path(aes(long, lat, group = id, color = name),
            alpha = 0.2, size = 0.3, color = "#f9ba00",
            data = flights_fortified[flights_fortified$name == "Lufthansa", ]) +

  geom_point(data = flights_points[flights_points$name == "Lufthansa", ],
             aes(long, lat), alpha = 0.8, size = 0.1, colour = "white")



theme(panel.background = element_rect(fill = "#05050f", colour = "#05050f"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.position = "none") +
  annotate("text", x = -150, y = -18, hjust = 0, size = 14,
           label = paste("Lufthansa"), color = "#f9ba00", family = "Helvetica Black") +
  annotate("text", x = -150, y = -26, hjust = 0, size = 8,
           label = paste("Flight routes"), color = "white") +
  annotate("text", x = -150, y = -30, hjust = 0, size = 7,
           label = paste("lhehnke.github.io || NASA.gov || OpenFlights.org"), color = "white", alpha = 0.5) +
  coord_equal()


# Subset multiple airlines
## Note: Change this code snippet if you're more interested in mapping other airline routes.
flights_subset <- c("Lufthansa", "Emirates", "British Airways")
flights_subset <- flights_fortified[flights_fortified$name %in% flights_subset, ]

flights_points_subset <- flights_subset %>%
  group_by(group) %>%
  filter(row_number() == 1 | row_number() == n())
#-------



ragg::agg_png(here::here("R_general_resources/30DayMapChallenge/day20_movements/movements5.png"),
              res = 320, width = 12, height = 8, units = "in")
p
dev.off()

# Plot
plotggplot() +
  annotation_custom(earth, xmin = -180, xmax = 180, ymin = -90, ymax = 90) +
  geom_path(aes(long, lat, group = id, color = name), alpha = 0.2, size = 0.3, data = flights_subset) +
  geom_point(data = flights_points_subset, aes(long, lat), alpha = 0.8, size = 0.1, colour = "white") +
  scale_color_manual(values = c("#f9ba00", "#ff0000", "#075aaa")) +
  theme(panel.background = element_rect(fill = "#05050f", colour = "#05050f"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.position = "none") +
  annotate("text", x = -150, y = -4, hjust = 0, size = 14,
           label = paste("Lufthansa"), color = "#f9ba00", family = "Helvetica Black") +
  annotate("text", x = -150, y = -11, hjust = 0, size = 14,
           label = paste("Emirates"), color = "#ff0000", family = "Fontin") +
  annotate("text", x = -150, y = -18, hjust = 0, size = 14,
           label = paste("BRITISH AIRWAYS"), color = "#075aaa", family = "Baker Signet Std") +
  annotate("text", x = -150, y = -30, hjust = 0, size = 8,
           label = paste("Flight routes"), color = "white") +
  annotate("text", x = -150, y = -34, hjust = 0, size = 7,
           label = paste("lhehnke.github.io || NASA.gov || OpenFlights.org"), color = "white", alpha = 0.5) +
  coord_equal()
dev.off()
