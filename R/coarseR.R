# $Id: coarseR.R, v 1.1.2 2014/07/26 12:07:00 EPS JHU $                #
#----------------------------------------------------------------------#
# This function is a part of HiClimR R package.                        #
#----------------------------------------------------------------------#
#  HISTORY:                                                            #
#----------------------------------------------------------------------#
#  Version  |  Date      |  Comment   |  Author       |  Email         #
#----------------------------------------------------------------------#
#           |  May 1992  |  Original  |  F. Murtagh   |                #
#           |  Dec 1996  |  Modified  |  Ross Ihaka   |                #
#           |  Apr 1998  |  Modified  |  F. Leisch    |                #
#           |  Jun 2000  |  Modified  |  F. Leisch    |                #
#----------------------------------------------------------------------#
#  1.00     |  03/07/14  |  Modified  |  Hamada Badr  |  badr@jhu.edu  #
#  1.01     |  03/08/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.02     |  03/09/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.03     |  03/12/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.04     |  03/14/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.05     |  03/18/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.06     |  03/25/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.07     |  03/30/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.08     |  05/06/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#----------------------------------------------------------------------#
#  1.0.9    |  05/07/14  |  CRAN      |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.0    |  05/15/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.1    |  07/14/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.2    |  07/26/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#----------------------------------------------------------------------#
# COPYRIGHT(C) Department of Earth and Planetary Sciences, JHU.        #
#----------------------------------------------------------------------#
# Function: Coarsening spatial resolution for gridded data             #
#----------------------------------------------------------------------#

coarseR <- function (x=x, lon=lon, lat=lat, lonSkip=1, latSkip=1)
{
    xc <- list()
    xc$lon <- lon
    xc$lat <- lat
    xc$x <- x
	
    if (!is.null(lon) && !is.null(lat))
    {
	if (dim(x)[1] == length(unique(lon)) * length(unique(lat)))
	{
	    lon0 <- unique(lon)
    	    lat0 <- unique(lat)
	    xGrid <- grid2D(lon0, lat0)
	    
	    rownames(x) <- paste(c(xGrid$lon), c(xGrid$lat), sep=",")
    		
    	    lon1 <- lon0[seq(1, length(lon0), by=lonSkip)]
   	    lat1 <- lat0[seq(1, length(lat0), by=latSkip)]
	    
    	    xc$lon <- c(grid2D(lon1, lat1)$lon)
    	    xc$lat <- c(grid2D(lon1, lat1)$lat)
    		
    	    if (lonSkip > 1 || latSkip > 1)
    	    {
    	    	xc$x <- x[which(rownames(x) %in% paste(xc$lon, xc$lat, sep=",")),]
    	    }
    	} else {
    	    if (lonSkip > 1 || latSkip > 1)
    	    {
                write("	warning: ungridded data is not supported for coarsening!", "")
            }
        }
    } else {
	write(" warning: valid longitude and latitude vectors are not provided!", "")
    }
    return(xc)
}
