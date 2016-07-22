# data_func.R -- functions related to building pacakge data
# John Bannister
# 

#' Get polygon data from shapefile
#' 
#' @param dsn String. Path to shapefile directory.
#' @param layer String. Name of shapefile.
#' @param proj_string String. CRS projection string in "proj4string" format.
#' @return Data frame with treatment area polygon data.
shape_data <- function(dsn, layer, proj_string){
  dsn <- path.expand(dsn)
  areas <- rgdal::readOGR(dsn=dsn, layer=layer, verbose=FALSE)
  areas <- sp::spTransform(areas, proj_string)
  dat <- areas@data 
  labpnts <- lapply(c(1:length(areas@polygons)), 
                    function(x) areas@polygons[[x]]@labpt)
  polypnts <- lapply(c(1:length(areas@polygons)), 
                     function(x) areas@polygons[x][[1]]@Polygons[[1]]@coords)
  area_data <- cbind(dat, I(labpnts), I(polypnts)) 
  colnames(area_data) <- tolower(colnames(area_data))
  area_data
}

#' Build data frame from multiple lists contained in a data frame.
#' 
#' @param df_in Data frame. 
#' @param list_ind Integer. Column index of lists to process.
#' @param id_ind Integer. Column index of object id to be associated with all 
#' elements of corresponding list.
#' @return Data frame.
lists2df <- function(df_in, list_ind, id_ind){
  df_out <- data.frame(x=numeric(), y=numeric(), objectid=integer())
  for (i in 1:nrow(df_in)){
    df1 <- data.frame(matrix(df_in[, list_ind][[i]], ncol=2))
    df1$objectid <- rep(df_in[i, id_ind], nrow(df1))
    colnames(df1)[1:2] <- c("x", "y")
    df_out <- rbind(df_out, df1)
  }
  df_out
}

