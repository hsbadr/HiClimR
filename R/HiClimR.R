# $Id: HiClimR.R, v1.1.6 2015/03/01 12:00:00 hsbadr EPS JHU            #
#----------------------------------------------------------------------#
# This is the main function of                                         #
# HiClimR (Hierarchical Climate Regionalization) R package             #
#----------------------------------------------------------------------#
#  HiClimR package modifies and improves hierarchical clustering in R  #
#  ('hclust' function in 'stats' library), climate regionalization.    #
#  It adds a new clustering method (called, regional linkage) to the   #
#  set of available methods  together with several features including  #
#  regridding (grid2D function), coarsening spatial resolution         #
#  (coarseR function), geographic masking (geogMask function), data    #
#  thresholds, detrending and standardization preprocessing, faster    #
#  correlation function (fastCor function), and cluster validation     #
#  (validClimR and minSigCor functions). The regional linkage method   #
#  is explained in the context of a spatio-temporal problem, in which  #
#  N spatial elements (e.g., weather stations) are divided into k      #
#  regions, given that each element has a time series of length M.     #
#  It is based on inter-regional correlation distance between the      #
#  temporal means of different regions (or elements at the first       #
#  merging step). It modifies the update formulae of average linkage   #
#  method by incorporating the standard deviation of the timeseries    #
#  of the the merged region, which is a function of the correlation    #
#  between the individual regions, and their standard deviations       #
#  before merging. It is equal to the average of their standard        #
#  deviations if and only if the correlation between the two merged    #
#  regions is 100%. In this special case, the regional linkage method  #
#  is reduced to the classic average linkage clustering method. The    #
#  added features facilitate spatiotemporal analysis applications as   #
#  well as cluster validation function validClimR, which implements    #
#  an objective tree cutting to find the optimal number of clusters    #
#  for a user-specified confidence level. These include options for    #
#  preprocessing and postprocessing as well as efficient code          #
#  execution for large datasets.                                       #
#  It is applicable to any correlation-based clustering.               #
#----------------------------------------------------------------------#
# References:                                                          #
#                                                                      #
#  Badr, H. S., Zaitchik, B. F. and Dezfuli, A. K. (2015).             #
#  Hierarchical Climate Regionalization. CRAN,                         #
#  http://cran.r-project.org/package=HiClimR.                          #
#----------------------------------------------------------------------#
# Clustering Methods:                                                  #
#                                                                      #
#  0. REGIONAL linakage or minimum inter-regional correlation.         #
#  1. WARD's minimum variance or error sum of squares method.          #
#  2. SINGLE linkage or nearest neighbor method.                       #
#  3. COMPLETE linkage or diameter.                                    #
#  4. AVERAGE linkage, group average, or UPGMA method.                 #
#  5. MCQUITTY's or WPGMA method.                                      #
#  6. MEDIAN, Gower's or WPGMC method.                                 #
#  7. CENTROID or UPGMC method (7).                                    #
#----------------------------------------------------------------------#
# This code is modified by Hamada Badr <badr@jhu.edu> from:            #
# File src/library/stats/R/hclust.R                                    #
# Part of the R package, http://www.R-project.org                      #
#                                                                      #
# Copyright(C)  1995-2014  The R Core Team                             #
#                                                                      #
# This program is free software; you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by #
# the Free Software Foundation; either version 2 of the License, or    #
# (at your option) any later version.                                  #
#                                                                      #
# This program is distributed in the hope that it will be useful,      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         #
# GNU General Public License for more details.                         #
#                                                                      #
# A copy of the GNU General Public License is available at             #
# http://www.r-project.org/Licenses                                    #
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
#  1.1.3    |  08/28/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.4    |  09/01/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.5    |  11/12/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#----------------------------------------------------------------------#
#  1.1.6    |  01/03/15  |  GitHub    |  Hamada Badr  |  badr@jhu.edu  #
#----------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2015 Earth and Planetary Sciences (EPS), JHU.      #
#----------------------------------------------------------------------#
# Function: Hierarchical Climate Regionalization                       #
#----------------------------------------------------------------------#

HiClimR <- function(x, lon = NULL, lat = NULL, lonStep = 1, latStep = 1, 
    geogMask = FALSE, gMask = NULL, continent = NULL, region = NULL, country = NULL, 
    meanThresh = NULL, varThresh = 0, detrend = FALSE, standardize = FALSE, 
    nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL, members = NULL, 
    validClimR = TRUE, rawStats = TRUE, k = NULL, minSize = 1, alpha = 0.05, 
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE) {

    start.time <- proc.time()
    write("PROCESSING STARTED", "")
    
    # Coarsening spatial resolution
    if (lonStep > 1 && latStep > 1) {
        write("Coarsening spatial resolution...", "")
        xc <- coarseR(x = x, lon = lon, lat = lat, lonStep = lonStep, latStep = latStep)
    } else {
        xc <- coarseR(x = x, lon = lon, lat = lat, lonStep = 1, latStep = 1)
    }
    lon <- xc$lon
    lat <- xc$lat
    x <- xc$x
    rm(xc)
    
    # Check data dimensions
    write("Checking data dimensions...", "")
    n <- dim(x)[1]
    m <- dim(x)[2]
    if (is.null(n)) 
        stop("\tinvalid data size")
    # if (is.na(n) || n > 65536L) stop(' size cannot be NA nor exceed
    # 65536')
    if (is.na(n)) 
        stop("\tsize cannot be NA")
    if (n < 2) 
        stop("\tmust have n \u2265 2 objects to cluster")
    
    # Check row names (important if detrending is requested)
    write("Checking row names...", "")
    if (is.null(rownames(x))) {
        rownames(x) <- seq(1, n)
    }
    
    # Check column names (important if detrending is requested)
    write("Checking column names...", "")
    if (is.null(colnames(x))) {
        colnames(x) <- seq(1, m)
    }
    
    # Mask geographic region
    mask <- NULL
    if (geogMask) {
        write("Geographic masking...", "")
        if (is.null(gMask)) {
            gMask <- geogMask(continent = continent, region = region, country = country, 
                lon = lon, lat = lat, plot = FALSE, colPalette = colPalette)
        }
        
        if (min(gMask) >= 1 && max(gMask) <= n) {
            mask <- union(mask, as.integer(gMask))
        }
    }
    
    # Remove rows with observations mean bellow meanThresh
    write("Checking rows with observations mean bellow meanThresh...", 
        "")
    # xmean <- rowMeans(x, na.rm=TRUE)
    xmean <- rowMeans(x)
    if (!is.null(meanThresh)) {
        meanMask <- which(is.na(xmean) | xmean <= meanThresh)
        if (length(meanMask) > 0) {
            write(paste("\t", length(meanMask), "rows found, mean \u2264 ", 
                meanThresh), "")
            
            mask <- union(mask, meanMask)
        }
    }
    
    # Center data (this has no effect on correlations but speedup compuations)
    x <- x - xmean
    v <- rowSums(x^2, na.rm = TRUE)
    
    # Remove rows with near-zero-variance observations
    write("Checking rows with near-zero-variance observations...", "")
    if (is.null(varThresh)) {
        varThresh <- 0
    }
    varMask <- which(is.na(v) | v <= varThresh)
    if (length(varMask) > 0) {
        # stop('data cannot include zero-variance rows')
        write(paste("\t", length(varMask), "rows found, variance \u2264 ", 
            varThresh), "")
        
        mask <- union(mask, varMask)
    }
    
    # Mask data
    if (length(mask) > 0) {
        x <- x[-mask, ]
        v <- v[-mask]
    }
    
    # Remove columns with missing values
    write("Checking columns with missing values...", "")
    x <- t(na.omit(t(x)))
    if (length(attr(x, "na.action")) > 0) {
        write(paste("\twarning:", length(attr(x, "na.action")), "columns found with missing values"), 
            "")
    }
    
    # Recheck data dimensions after ommitting missing values and/or
    # zero-variance data
    n <- dim(x)[1]
    m <- dim(x)[2]
    if (is.null(n)) 
        stop("invalid data size")
    # if (is.na(n) || n > 65536L) stop('size cannot be NA nor exceed
    # 65536')
    if (is.na(n)) 
        stop("\tsize cannot be NA")
    if (n < 2) 
        stop("must have n \u2265 2 objects to cluster")
    
    # Detrend data if requested
    if (detrend) {
        write("Removing linear trend...", "")
        x <- x - t(fitted(lm(t(x) ~ as.integer(colnames(x)))))
    }
    
    # Standardize data if requested
    if (standardize) {
        write("Standardizing the data...", "")
        x <- x/sqrt(v)
        # Correlation matrix (fast calculation using BLAS library)
        r <- tcrossprod(x)
        # Variance of each variable (object/station)
        v <- rep(1, n)
        
        # Standardized data
        x <- x * sqrt(m - 1)
    } else {
        # Correlation matrix (fast calculation using BLAS library)
        r <- tcrossprod(x/sqrt(v))
        # Variance of each variable (object/station)
        v <- v/(m - 1)
    }
    # This is equivalent to upper triangular part of dissimilarity matrix
    r <- r[col(r) < row(r)]
    
    # Re-adding the mean for nonstandardized data (July 26, 2014)
    if (!standardize) {
        if (length(mask) > 0) {
            x <- x + xmean[-mask]
        } else {
            x <- x + xmean
        }
    }
    
    # Reconstruct data from PCs if requested
    if (!is.null(nPC)) {
        write("Reconstructing data from PCs...", "")
        if (nPC >= 1 && nPC <= min(n, m)) {
            xSVD <- La.svd(t(x), nPC, nPC)
            eigVal <- xSVD$d
            expVar <- eigVal^2/sum(eigVal^2) * 100
            accVar <- sapply(seq(1, length(expVar)), function(r) sum(expVar[1:r]))
            x1 <- xSVD$u %*% diag(xSVD$d[1:nPC], nPC, nPC) %*% xSVD$vt
            x1 <- t(x1) - colMeans(x1)
            
            # Cleanup memory from unnecessary variables
            rm(xSVD)
        } else {
            stop(paste("invalid number of PCs,", 1, "\u2264 nPC \u2264", min(m, 
                n)))
        }
        v1 <- rowSums(x1^2)
        # Correlation matrix (fast calculation using BLAS library)
        r1 <- tcrossprod(x1/sqrt(v1))
        # Variance of each variable (object/station)
        v1 <- v1/(m - 1)
        # This is equivalent to upper triangular part of dissimilarity matrix
        r1 <- r1[col(r1) < row(r1)]
    } else {
        x1 <- x
        v1 <- v
        r1 <- r
    }
    
    # Compute validation indices based on raw (100% of the total variance)
    # or PCA-filtered data?  Note that in both cases detrending and/or
    # standarding options are applied (before PCA)
    if (!rawStats) {
        x <- x1
        v <- v1
        r <- r1
    }
    
    # Dissimilarity matrix (correlation distance)
    d <- 1 - r1
    
    # Check dissimilarity matrix
    len <- as.integer(n * (n - 1)/2)
    if (length(d) != len) 
        (if (length(d) < len) 
            stop else warning)("data of improper length")
    
    
    # Cleanup memory from unnecessary variables
    rm(x1, r1)
    
    # Clustering method
    METHODS <- c("regional", "ward", "single", "complete", "average", "mcquitty", 
        "median", "centroid")
    method <- pmatch(method, METHODS) - 1
    if (is.na(method)) 
        stop("invalid clustering method")
    if (method == -1) 
        stop("ambiguous clustering method")
    
    # Check for restart clustering
    if (is.null(members)) 
        members <- rep(1, n) else if (length(members) != n) 
        stop("invalid length of members")
    
    write("Starting clustering process...", "")
    # Call Fortran subroutine for agglomerative hierarchical clustering
    storage.mode(d) <- "double"
    hcl <- .Fortran("HiClimR", n = n, len = len, method = as.integer(method), 
        ia = integer(n), ib = integer(n), crit = double(n), members = as.double(members), 
        var = v, diss = d, PACKAGE = "HiClimR")
    
    # interpret the output from previous step (such as merge, height, and
    # order lists)
    hcass <- .Fortran("hcass2", n = n, ia = hcl$ia, ib = hcl$ib, order = integer(n), 
        iia = integer(n), iib = integer(n), PACKAGE = "HiClimR")
    
    write("Constructing dendrogram tree...", "")
    # Construct 'hclust'/'HiClimR' dendogram tree
    tree <- list(merge = cbind(hcass$iia[1L:(n - 1)], hcass$iib[1L:(n - 
        1)]), height = hcl$crit[1L:(n - 1)], order = hcass$order, labels = rownames(x), 
        method = METHODS[method + 1], call = match.call(), dist.method = "correlation")
    class(tree) <- "hclust"
    
    tree$skip <- c(lonStep, latStep)
    names(tree$skip) <- c("lonStep", "latStep")
    
    if (!is.null(nPC)) {
        tree$PCA = cbind(eigVal = eigVal, expVar = expVar, accVar = accVar)
    }
    
    # return coordinates
    if (!is.null(lon) && !is.null(lat)) {
        tree$coords <- cbind(lon, lat)
        colnames(tree$coords) <- c("Lon", "Lat")
    }
    
    # return preprocessed raw or PCA-reconstructed data
    if (rawStats) {
        tree$data <- x
    } else {
        tree$data <- x1
    }
    
    # Return mask vector
    if (length(mask) > 0) {
        tree$mask <- mask
    }
    
    # Return locations of missing values
    if (length(attr(x, "na.action")) > 0) {
        tree$missVal <- attr(x, "na.action")
    }
    
    if (hybrid) {
        write("Reonstructing the upper part of the tree...", "")
        if (tree$method == "regional") {
            write("\twarning: hybrid option is redundant when using regional linkage method!", 
                "")
        } else {
            if (is.null(kH)) {
                kH <- length(tree$height) - min(which(diff(tree$height) > 
                  mean(diff(tree$height)))) + 1
            }
            kH <- as.integer(kH)
            if (kH < 2) 
                stop("\tmust have kH \u2265 2 objects to cluster")
            
            lenH <- as.integer(kH * (kH - 1)/2)
            
            methodH <- pmatch("regional", METHODS) - 1
            
            # Update variances dissimilarities of the upper part of the tree
            cutTreeH <- cutree(tree, k = kH)
            RMH <- t(apply(tree$data, 2, function(r) tapply(r, cutTreeH, 
                mean)))
            vH <- apply(RMH, 2, var)
            rH <- fastCor(RMH)
            rH <- rH[col(rH) < row(rH)]
            dH <- 1 - rH
            
            # Call Fortran subroutine for agglomerative hierarchical clustering
            storage.mode(d) <- "double"
            hclH <- .Fortran("HiClimR", n = kH, len = lenH, method = as.integer(methodH), 
                ia = integer(kH), ib = integer(kH), crit = double(kH), 
                members = as.double(table(cutTreeH)), var = vH, diss = dH, 
                PACKAGE = "HiClimR")
            
            # interpret the output from previous step (such as merge, height, and
            # order lists)
            hcassH <- .Fortran("hcass2", n = kH, ia = hclH$ia, ib = hclH$ib, 
                order = integer(kH), iia = integer(kH), iib = integer(kH), 
                PACKAGE = "HiClimR")
            
            # Construct 'hclust'/'HiClimR' dendogram tree for the upper part
            treeH <- list(merge = cbind(hcassH$iia[1L:(kH - 1)], hcassH$iib[1L:(kH - 
                1)]), height = hclH$crit[1L:(kH - 1)], order = hcassH$order, 
                labels = names(table(cutree(tree, kH))), method = METHODS[methodH + 
                  1], call = match.call(), dist.method = "correlation")
            class(treeH) <- "hclust"
            
            # Add the new upper part of the tree to the original tree
            tree$treeH <- treeH
        }
    }
    
    # Plot dendrogram tree
    if (plot) {
        dev.new(width = 10)
        if (hybrid && tree$method != "regional") {
            opar <- par(mfrow = c(1, 2))
            plot(tree, hang = hang, labels = labels, main = paste(METHODS[method + 
                1], "Method | Original Tree"))
            # rect.hclust(tree, k=kH, border='blue', cluster=cutTreeH)
            plot(treeH, hang = hang, labels = FALSE, main = paste("Regional Linkage |", 
                kH, "clusters"), axes = FALSE, ylab = "Maximum Inter-Regional Correlation")
            axis(2, at = pretty(treeH$height), labels = 1 - pretty(treeH$height))
            par(opar)
        } else {
            if (tree$method == "regional") {
                plot(tree, hang = hang, labels = labels, axes = FALSE, 
                  ylab = "Maximum Inter-Regional Correlation")
                axis(2, at = pretty(tree$height), labels = 1 - pretty(tree$height))
            } else {
                plot(tree, hang = hang, labels = labels)
            }
        }
    }
    
    # Cluster validation
    if (validClimR) {
        write("Calling cluster validation...", "")
        z <- validClimR(y = tree, k = k, minSize = minSize, alpha = alpha, 
            plot = plot, colPalette = colPalette)
        
        tree <- c(tree, z)
    }
    
    class(tree) <- c("hclust", "HiClimR")
    write("PROCESSING COMPLETED", "")
    
    # Print running time
    write("Running Time:", "")
    print(proc.time() - start.time)
    
    # Output Tree
    tree
}
