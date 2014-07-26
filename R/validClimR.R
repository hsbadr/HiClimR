# $Id: validClimR.R, v 1.1.2 2014/07/26 12:07:00 EPS JHU $             #
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
# Function: Validation of Hierarchical Climate Regionalization         #
#----------------------------------------------------------------------#

validClimR <- function (y=NULL, k=NULL, minSize=1, alpha=0.05, plot=FALSE, colPalette=NULL)
{
    # Coordinates
    lon <- y$coords[,1]
    lat <- y$coords[,2]

    # Preprocessed raw or PCA-reconstructed data
    x <- y$data
	
    # Cut the dendogram tree based on minimum significant inter-regional correlation
    if (is.null(k))
    {
        # Check clustering method
        if (y$method != "regional" && is.null(y$treeH))
        {
            write("Objective tree cut is supported only for Regional Linkage method!", "")
            write(paste("   ", y$method, "method requires a prespecified number of clusters!"), "")
        } else {
            if (is.null(y$treeH))
            {
                cutHight <- y$height
            } else{                
                cutHight <- y$treeH$height
            }
        
	    # Minimum significant correlation coefficient at 95% confidence level for sample size of n years
    	    nn <- dim(x)[2] - length(y$missVal)
            RsMin <- minSigCor(n=nn, alpha=alpha, r=seq(0, 1, by=1e-6))$cor

	    k <- (length(cutHight) - min(which(1-cutHight < RsMin)) + 1)
	}
    } else {
        alpha <- NULL
        RsMin <- NULL
    }
    
    index <- list()
    if (!is.null(k))
    {
	# Tree cut
        if (is.null(y$treeH))
        {
            cutTree <- cutree(y, k=k)
        } else {
            # The reconstructed upper part tree
            yH <- y$treeH
            
            cutTreeH <- cutree(yH, k=k)
            cutTree0 <- cutree(y, k=length(cutTreeH))
            
            cutTree <- cutTree0 + NA
            for (ik in 1:k)
            {
                cutTree[which(cutTree0 %in% as.integer(names(which(cutTreeH == ik))))] <- ik
            }
        }
        #table(cutTree)
	
    	# Check cluster size
    	clustFlag <- rep(1, k)
    	if (minSize > 1)
    	{
    	    clustFlag[which(table(cutTree) < minSize)] <- NA
    	}
    
    	# Regions’ Means
    	RM <- t(apply(x, 2, function(r) tapply(r, cutTree, mean)))

    	# Correlation between Regions’ Means
    	#RMcor <- fastCor(RM)
    	#RMcor[lower.tri(RMcor, diag=TRUE)] <- NA
    	RMcor <- t(fastCor(RM) * clustFlag) * clustFlag
    	RMcor[lower.tri(RMcor, diag=TRUE)] <- NA
    
    	# Correlation between Regions’ Means and Regions’ Members
    	Rcor <- cor(RM, t(x))
    
    	# Average Correlation between Regions’ Means and Regions’ Members for each region
    	#RcorAvg <- t(apply(Rcor, 1, function(r) tapply(r, cutTree, mean)))
    	RcorAvg <- t(apply(Rcor, 1, function(r) tapply(r, cutTree, mean)) * clustFlag)
    
    	clustFlag[is.na(clustFlag)] <- 0
    
    	index$cutLevel <- c(alpha, RsMin)
    	index$clustMean <- RM
    	index$clustSize <- table(cutTree)
    
    	index$clustFlag <- clustFlag
    	names(index$clustFlag) <- 1:length(clustFlag)
    
    	#index$interCor <- RMcor[upper.tri(RMcor)]
    	#names(index$interCor) <- paste(combn(length(table(cutTree)), 2)[1,], 
    	#    combn(length(table(cutTree)), 2)[2,], sep=" & ")
    	index$interCor <- RMcor[!is.na(RMcor)]
    	i1.interCor <- which(RMcor %in% index$interCor)
    	i2.interCor <- grid2D(c(1:nrow(RMcor)),c(1:ncol(RMcor)))
    	names(index$interCor) <- paste(i2.interCor$lat[c(i1.interCor)], 
        	i2.interCor$lon[c(i1.interCor)], sep=" & ")
    
    	#index$intraCor <- diag(RcorAvg)
    	index$intraCor <- diag(RcorAvg)[!is.na(diag(RcorAvg))]

    	index$diffCor <- index$intraCor - max(index$interCor)

    	index$statSum <- cbind(summary(index$interCor, digits=7), summary(index$intraCor, digits=7), summary(index$diffCor, digits=7))
    	colnames(index$statSum) <- c("interCor", "intraCor", "diffCor")

    	# Correct the average intra-cluster correlation by cluster size
    	#index$statSum[4,2] <- sum(index$intraCor * index$clustSize) / sum(index$clustSize)
    	index$statSum[4,2] <- sum(index$intraCor * index$clustSize[which(clustFlag == 1)]) / 
        	sum(index$clustSize[which(clustFlag == 1)])
    
    	# Oredered regions vector for the selected regions
	ks <- sum(index$clustFlag)
	Regions <- rep(NA, length(lon))
        #Regions[gMask] <- NA
        if (is.null(y$mask))
        {
        Regions <- cutTree
        } else {
        Regions[-y$mask] <- cutTree
        }
        Regions[which(Regions %in% which(index$clustFlag != 1))] <- NA
        for (i in 1:ks)
        {
                Regions[which(Regions == which(index$clustFlag == 1)[i])] <- i
        }
        index$region <- Regions
        index$regionID <- (1:sum(index$clustFlag)) * index$clustFlag[-which(index$clustFlag != 1)]
	
    	if (plot)
    	{
            write("Generating region maps...", "")
            if (is.null(colPalette))
            {
#                colPalette <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
#                    "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
                colPalette <- colorRampPalette(c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3",
                    "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F"))
            }
#            if (!is.null(lon) && !is.null(lat))
#            {
#                if (length(lon) == length(unique(lon)) * length(unique(lat)))
#                {
#                   RegionsMap <- matrix(Regions, nrow=length(unique(lon)), byrow=TRUE)
#
#	            dev.new()
#	            Longitude <- unique(lon)
#	            Latitude <- unique(lat)
#	            image(Longitude, Latitude, RegionsMap, col=colPalette(ks))
#                } else {
#	            #write("ungridded data is not supported for Plotting!", "")
#                    
                    dev.new()
	            Longitude <- y$coords[,1]
	            Latitude <- y$coords[,2]
                    plot(Longitude, Latitude, col=colPalette(max(Regions, na.rm=TRUE))[Regions], pch=20)
#	        }
#	    } else {
#                write("	warning: valid longitude and latitude vectors are not provided!", "")
#           }
        }

    	class(index) <- "HiClimR"
    }
	
    return(index)
}
