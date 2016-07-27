# build_package_data.R -- build data to be automatically loaded for use in 
# scripts and functions across entire sfwctR pacakge.
# John Bannister
# 
load_all()
library(dplyr)
library(rgdal)

proj_string <- paste0("+proj=utm +zone=11 +datum=NAD83 +units=m +no_defs", 
                      "+ellps=GRS80 +towgs84=0,0,0")

areas_gdb <- path.expand("~/dropbox/data/gis/owens/StdPolyLayers_20160623.gdb")
areas_levels <- ogrListLayers(areas_gdb)
owens_areas <- vector(mode="list", length=length(areas_levels)+1)
names(owens_areas) <- c("bacm", "dca", "parent", "shoreline")
for (i in 1:length(areas_levels)){
  dat <- shape_data(areas_gdb, areas_levels[i], proj_string)
  owens_areas[[i]]$data <- dat
  owens_areas[[i]]$data$objectid <- seq(1, nrow(dat))
  owens_areas[[i]]$polygons <- lists2df(dat, 12, 1)
  owens_areas[[i]]$labels <- lists2df(dat, 11, 1)
  colnames(owens_areas[[i]]$data)[1] <- "area"
  colnames(owens_areas[[i]]$polygons)[3] <- "area"
  colnames(owens_areas[[i]]$labels)[3] <- "area"
}

shoreline_dsn <- "~/dropbox/data/gis/owens/shoreline_150k"
shoreline_layer <- "shoreline_150k"
shoreline_data <- shape_data(shoreline_dsn, shoreline_layer, proj_string)
owens_areas$shoreline$polygon <- lists2df(shoreline_data, 11, 1)

save(owens_areas, proj_string, file="./data/map_data.RData")
