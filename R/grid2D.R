# $Id: grid2D.R, v 1.1.0 2014/05/15 12:07:00 EPS JHU $                 #
#----------------------------------------------------------------------#
# This function is a part of HiClimR R package.                        #
#----------------------------------------------------------------------#
#  HISTORY:                   					       #
#----------------------------------------------------------------------#
#  Version  |  Date      |  Comment   |  Author       |  Email         #
#----------------------------------------------------------------------#
#  	    |  May 1992  |  Oringinal |  F. Murtagh   |                #
#	    |  Dec 1996  |  Modified  |  Ross Ihaka   |                #
#           |  Apr 1998  |  Modified  |  F. Leisch    |                #
#           |  Jun 2000  |  Modified  |  F. Leisch    |	       	       #
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
#----------------------------------------------------------------------#
# COPYRIGHT(C) Department of Earth and Planetary Sciences, JHU.        #
#----------------------------------------------------------------------#
# Function: Generate longitude and latitude grid matrices              #
#----------------------------------------------------------------------#

grid2D <- function (lon=lon, lat=lat)
{
    gGrid <- list()

    lon <- unique(lon)
    lat <- unique(lat)
    if (!is.null(lon) && !is.null(lat))
    {
        gGrid$lon <- tcrossprod(rep(1, length(lat)), lon)
        gGrid$lat <- tcrossprod(lat, rep(1, length(lon)))
    }

    return(gGrid)
}
