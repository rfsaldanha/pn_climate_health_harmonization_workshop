# First, install packages
# install.packages("pak")
# pak::pkg_install(c("sf", "terra", "exactextractr", "dplyr"))

# Load packages
library(sf) # To read shapefiles
library(terra) # To read raster
library(exactextractr) # To compute zonal statistics
library(dplyr) # To manipulate tabular data

# Read shapefile
shp <- read_sf("geoBoundaries-DZA-ADM2-all/geoBoundaries-DZA-ADM2.shp")
plot(shp)

# Read raster
rst <- rast("TerraClimate_tmax_2024.nc")
plot(rst)

# Compute zonal statistics
res <- exact_extract(
  x = rst,
  y = shp,
  fun = c("mean", "stdev"),
  append_cols = "shapeID"
)

# Insert zonal statistics into shp object
shp_tmax <- left_join(shp, res, by = "shapeID")

# Write new shapefile with temperatures
write_sf(shp_tmax, "tmax.shp")
