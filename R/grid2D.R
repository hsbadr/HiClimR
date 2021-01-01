# $Id: grid2D.R                                                           #
#-------------------------------------------------------------------------#
# This function is a part of HiClimR R package.                           #
#-------------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2021 Earth and Planetary Sciences (EPS), JHU.         #
#-------------------------------------------------------------------------#
# Function: Generate longitude and latitude grid matrices                 #
#-------------------------------------------------------------------------#

grid2D <- function(lon = lon, lat = lat) {
  gGrid <- list()

  lon <- unique(lon)
  lat <- unique(lat)
  if (!is.null(lon) && !is.null(lat)) {
    gGrid$lon <- tcrossprod(rep(1, length(lat)), lon)
    gGrid$lat <- tcrossprod(lat, rep(1, length(lon)))
  }

  return(gGrid)
}
