# build_package_data.R -- build data to be automatically loaded for use in 
# scripts and functions across entire sfwctR pacakge.
# John Bannister
# 
load_all()
library(dplyr)

proj_string <- paste0("+proj=utm +zone=11 +datum=NAD83 +units=m +no_defs", 
                      "+ellps=GRS80 +towgs84=0,0,0")

dcm_dsn <- "~/dropbox/data/gis/owens/DCM_layer_thru_phase10_EPSG26911"
dcm_layer <- "DCM_layer_thru_phase10"
dcm_data <- shape_data(dcm_dsn, dcm_layer, proj_string)
dcm_polygons <- lists2df(dcm_data, 12, 1)
dcm_labels <- lists2df(dcm_data, 11, 1)
colnames(dcm_data)[1] <- "dcm"
colnames(dcm_labels)[3] <- "dcm"
colnames(dcm_polygons)[3] <- "dcm"

shoreline_dsn <- "~/analysis/Rowens/data-raw/shoreline_150k"
shoreline_layer <- "shoreline_150k"
shoreline_data <- shape_data(shoreline_dsn, shoreline_layer, proj_string)
shoreline_polygon <- lists2df(shoreline_data, 11, 1)

save(dcm_polygons, dcm_labels, dcm_data, shoreline_polygon, proj_string, 
     file="./data/map_data.RData")
