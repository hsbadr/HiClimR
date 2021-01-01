# $Id: coarseR.R                                                          #
#-------------------------------------------------------------------------#
# This function is a part of HiClimR R package.                           #
#-------------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2021 Earth and Planetary Sciences (EPS), JHU.         #
#-------------------------------------------------------------------------#
# Function: Coarsening spatial resolution for gridded data                #
#-------------------------------------------------------------------------#

coarseR <-
  function(x = x,
           lon = lon,
           lat = lat,
           lonStep = 1,
           latStep = 1,
           verbose = TRUE) {
    xc <- list()
    xc$lon <- lon
    xc$lat <- lat
    xc$x <- x

    if (!is.null(lon) && !is.null(lat)) {
      nlon_unique <- length(unique(lon))
      nlat_unique <- length(unique(lat))
      if (as.numeric(dim(x)[1]) == as.numeric(nlon_unique * nlat_unique)) {
        lon0 <- unique(lon)
        lat0 <- unique(lat)
        xGrid <- grid2D(lon0, lat0)

        rownames(x) <-
          paste(c(xGrid$lon), c(xGrid$lat), sep = ",")

        lon1 <- lon0[seq(1, length(lon0), by = lonStep)]
        lat1 <- lat0[seq(1, length(lat0), by = latStep)]

        xc$lon <- c(grid2D(lon1, lat1)$lon)
        xc$lat <- c(grid2D(lon1, lat1)$lat)

        if (lonStep > 1 || latStep > 1) {
          xc$x <- x[which(rownames(x) %in% paste(xc$lon, xc$lat,
            sep = ","
          )), ]

          # Return the original row numbers
          rownumbers <- seq_len(nrow(x))
          xc$rownum <-
            rownumbers[which(rownames(x) %in% paste(xc$lon, xc$lat,
              sep = ","
            ))]
        }
      } else {
        if (lonStep > 1 || latStep > 1) {
          if (verbose) {
            write(
              "---> WARNING: ungridded data is not supported for coarsening!",
              ""
            )
          }
        }
      }
    } else {
      if (verbose) {
        write(
          paste(
            "---> WARNING:",
            "valid longitude and latitude vectors are not provided!"
          ),
          ""
        )
      }
    }

    return(xc)
  }
