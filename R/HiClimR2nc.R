# $Id: HiClimR2nc.R, v2.1.5 2019/12/10 12:00:00 hsbadr EPS JHU           #
#-------------------------------------------------------------------------#
# This function is a part of HiClimR R package.                           #
#-------------------------------------------------------------------------#
#  HISTORY:                                                               #
#-------------------------------------------------------------------------#
#  Version  |  Date      |  Comment   |  Author          |  Email         #
#-------------------------------------------------------------------------#
#           |  May 1992  |  Original  |  F. Murtagh      |                #
#           |  Dec 1996  |  Modified  |  Ross Ihaka      |                #
#           |  Apr 1998  |  Modified  |  F. Leisch       |                #
#           |  Jun 2000  |  Modified  |  F. Leisch       |                #
#-------------------------------------------------------------------------#
#   1.0.0   |  03/07/14  |  HiClimR   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.1   |  03/08/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.2   |  03/09/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.3   |  03/12/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.4   |  03/14/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.5   |  03/18/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.6   |  03/25/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#-------------------------------------------------------------------------#
#   1.0.7   |  03/30/14  |  Hybrid    |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.0.8   |  05/06/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#-------------------------------------------------------------------------#
#   1.0.9   |  05/07/14  |  CRAN      |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.1.0   |  05/15/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.1.1   |  07/14/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.1.2   |  07/26/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.1.3   |  08/28/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.1.4   |  09/01/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.1.5   |  11/12/14  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#-------------------------------------------------------------------------#
#   1.1.6   |  03/01/15  |  GitHub    |  Hamada S. Badr  |  badr@jhu.edu  #
#-------------------------------------------------------------------------#
#   1.2.0   |  03/27/15  |  MVC       |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.2.1   |  05/24/15  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.2.2   |  07/21/15  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   1.2.3   |  08/05/15  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#-------------------------------------------------------------------------#
#   2.0.0   |  12/22/18  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   2.1.0   |  01/01/19  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   2.1.1   |  01/02/19  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   2.1.2   |  01/04/19  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   2.1.3   |  01/10/19  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   2.1.4   |  01/20/19  |  Updated   |  Hamada S. Badr  |  badr@jhu.edu  #
#   2.1.5   |  12/10/19  |  inherits  |  Hamada S. Badr  |  badr@jhu.edu  #
#-------------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2019 Earth and Planetary Sciences (EPS), JHU.         #
#-------------------------------------------------------------------------#
# Function: Export NetCDF-4 file for Hierarchical Climate Regionalization #
#-------------------------------------------------------------------------#

HiClimR2nc <-
  function(y = NULL,
           ncfile = "HiClimR.nc",
           timeunit = "",
           dataunit = "") {
    # Check input tree
    if (is.null(y))
    {
      stop("\tHiClimR tree is not provided!")
    } else {
      if (! inherits(y, "HiClimR") || is.null(y$region))
      {
        stop("\tinvalid HiClimR tree")
      }
    }
    
    Longitude <- unique(y$coords[, 1])
    Latitude <- unique(y$coords[, 2])
    
    RegionsMap <-
      matrix(y$region, nrow = length(Longitude), byrow = TRUE)
    
    timeseries <- y$clustMean
    
    ID <- y$regionID
    Time <- 1:dim(timeseries)[1]
    
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
    ncatt_put(ncout,
              0,
              "title",
              "Hierarchical Climate Regionalization (HiClimR)")
    ncatt_put(
      ncout,
      0,
      "author",
      "Hamada S. Badr [aut, cre], Benjamin F. Zaitchik [aut], Amin K. Dezfuli [aut]"
    )
    ncatt_put(ncout, 0, "maintainer", "Hamada S. Badr <badr@jhu.edu>")
    ncatt_put(ncout,
              0,
              "url",
              "https://cran.r-project.org/package=HiClimR")
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
    
    #gc()
    return(ncout)
  }
