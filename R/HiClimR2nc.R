# $Id: HiClimR2nc.R                                                       #
#-------------------------------------------------------------------------#
# This function is a part of HiClimR R package.                           #
#-------------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2021 Earth and Planetary Sciences (EPS), JHU.         #
#-------------------------------------------------------------------------#
# Function: Export NetCDF-4 file for Hierarchical Climate Regionalization #
#-------------------------------------------------------------------------#

HiClimR2nc <-
  function(y = NULL,
           ncfile = "HiClimR.nc",
           timeunit = "",
           dataunit = "") {
    # Check input tree
    if (is.null(y)) {
      stop("\tHiClimR tree is not provided!")
    } else {
      if (!inherits(y, "HiClimR") || is.null(y$region)) {
        stop("\tinvalid HiClimR tree")
      }
    }

    Longitude <- unique(y$coords[, 1])
    Latitude <- unique(y$coords[, 2])

    RegionsMap <-
      matrix(y$region, nrow = length(Longitude), byrow = TRUE)

    timeseries <- y$clustMean

    ID <- y$regionID
    Time <- seq_len(dim(timeseries)[1])

    # define dimensions
    londim <- ncdim_def("lon", "degrees_east", as.double(Longitude))
    latdim <- ncdim_def("lat", "degrees_north", as.double(Latitude))

    iddim <- ncdim_def("id", "level", as.integer(ID))

    timedim <- ncdim_def("time", timeunit, as.double(Time))

    # define variables
    fillvalue <- -999
    region.def <-
      ncvar_def(
        "region",
        "ID",
        list(londim, latdim),
        fillvalue,
        "Region ID",
        prec = "integer",
        shuffle = TRUE,
        compression = 9
      )
    timeseries.def <-
      ncvar_def(
        "timeseries",
        dataunit,
        list(timedim, iddim),
        fillvalue,
        "Region mean timeseries",
        prec = "double",
        compression = 9
      )

    # create NetCDF-4 file and put arrays
    ncout <-
      nc_create(ncfile, list(region.def, timeseries.def), force_v4 = TRUE)

    # put variables
    ncvar_put(ncout, region.def, RegionsMap)
    ncvar_put(ncout, timeseries.def, timeseries)

    # add dimensions & global attributes
    ncatt_put(ncout, "lon", "axis", "X")
    ncatt_put(ncout, "lat", "axis", "Y")
    ncatt_put(ncout, "id", "axis", "Z")
    ncatt_put(ncout, "time", "axis", "T")
    ncatt_put(
      ncout,
      0,
      "title",
      "Hierarchical Climate Regionalization (HiClimR)"
    )
    ncatt_put(
      ncout,
      0,
      "author",
      "Hamada S. Badr [aut, cre], Benjamin F. Zaitchik [aut], Amin K. Dezfuli [aut]"
    )
    ncatt_put(ncout, 0, "maintainer", "Hamada S. Badr <badr@jhu.edu>")
    ncatt_put(
      ncout,
      0,
      "url",
      "https://cran.r-project.org/package=HiClimR"
    )
    ncatt_put(
      ncout,
      0,
      "citation",
      "https://cran.r-project.org/package=HiClimR/citation.html"
    )
    ncatt_put(ncout, 0, "source", "https://github.com/hsbadr/HiClimR")
    ncatt_put(ncout, 0, "history", paste(
      paste("File created by HiClimR v", packageVersion("HiClimR"), sep = ""),
      date(),
      sep = " on "
    ))

    return(ncout)
  }
