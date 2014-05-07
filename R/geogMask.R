# $Id: geogMask.R, v 1.0.9 2014/05/07 12:07:00 EPS JHU $                #
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
#----------------------------------------------------------------------#
# COPYRIGHT(C) Department of Earth and Planetary Sciences, JHU.        #
#----------------------------------------------------------------------#
# Function: Geographic mask from longitude and latitute                #
#----------------------------------------------------------------------#

# Function: Geographic mask for an area from longitude and latitute
geogMask <- function (continent=NULL, region=NULL, country=NULL, lon=NULL, lat=NULL, plot=FALSE, colPalette=NULL)
{
    
    if (is.null(continent) && is.null(region) && is.null(country))
    {
        gMask <- list()
        gMask$continent <- unique(sort(WorldMask$info[,7]))
        gMask$region <- unique(sort(WorldMask$info[,6]))
        gMask$country <- unique(as.character(sort(WorldMask$info[!is.na(WorldMask$info[,3]),3])))
    } else {

        if (is.null(lon) || is.null(lat) || length(lon) != length(lat)) stop("invalid coordinates")

        if (!is.null(continent))
        {
            area <- which(WorldMask$info[,7] %in% continent)

            if (length(area) < 1) stop("invalid continent")

        } else if (!is.null(region)) {
            area <- which(WorldMask$info[,6] %in% region)

            if (length(area) < 1) stop("invalid region")

        } else if (!is.null(country)) {
            area <- which(WorldMask$info[,3] %in% country)

            if (length(area) < 1) stop("invalid country")

            for (i in 1:length(area))
            {
                area <- union(area, which(gregexpr(pattern = WorldMask$info[area[i],3], WorldMask$info[,1]) != -1))
            }
        }

        dx <- as.numeric(rownames(WorldMask$mask))[2] - as.numeric(rownames(WorldMask$mask))[1]
        dy <- as.numeric(colnames(WorldMask$mask))[2] - as.numeric(colnames(WorldMask$mask))[1]

        rx <- abs(as.integer(round(log(dx, 10))))
        ry <- abs(as.integer(round(log(dy, 10))))

        i <- (round(lon, rx) - as.numeric(rownames(WorldMask$mask))[1]) / dx + 1
        j <- (round(lat, ry) - as.numeric(colnames(WorldMask$mask))[1]) / dy + 1

        gMask <- seq(1,length(lon))[-which(diag(WorldMask$mask[i,j]) %in% area)]
    }

    if (plot)
    {
        if (length(lon) == length(unique(lon)) * length(unique(lat)))
        {
            Regions <- rep(-1, length(lon))
            Regions[gMask] <- NA
            RegionsMap <- matrix(Regions, nrow=length(unique(lon)), byrow=TRUE)

            if (is.null(colPalette))
            {
#                colPalette <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
#                    "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
                colPalette <- colorRampPalette(c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3",
                    "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F"))
            }
            Longitude <- unique(lon)
            Latitude <- unique(lat)
            image(Longitude, Latitude, RegionsMap, col=colPalette(2))
        } else {
            write("plot is avaiable only for gridded data", "")
        }
    }

    return(gMask)
}

