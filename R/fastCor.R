# $Id: fastCor.R, v2.1.5 2019/12/10 12:00:00 hsbadr EPS JHU               #
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
# Function: Fast correlation for large matrices                           #
#-------------------------------------------------------------------------#

fastCor <-
  function(xt,
           nSplit = 1,
           upperTri = FALSE,
           optBLAS = FALSE,
           verbose = TRUE) {
    varnames <- colnames(xt)
    
    # Remove zero-variance data
    nn <- ncol(xt)
    ii <- which(apply(xt, 2, var) > 0)
    if (verbose && length(ii) < nn) {
      write("---> Checking zero-variance data...", "")
      write(paste("--->\t Total number of variables: ", nn),
            "")
      write(paste(
        "--->\t WARNING:",
        nn - length(nn[ii]),
        "variables found with zero variance"
      ),
      "")
    }
    xt <- xt[, ii]
    
    x <- t(xt) - colMeans(xt)
    
    m <- nrow(xt)
    n <- ncol(xt)
    
    r <- matrix(NA, nrow = n, ncol = n)
    
    # Check if nSplit is a valid number
    nSplitMax <- floor(n / 2)
    if (nSplit > nSplitMax) {
      if (verbose) {
        write(paste("---> Maximum number of splits: floor(n/2) =", nSplitMax),
              "")
        write(paste("---> WARNING: number of splits nSplit \u003E", nSplitMax),
              "")
        write(paste(
          "---> WARNING: using maximum number of splits: nSplit =",
          nSplitMax
        ),
        "")
      }
      nSplit <- nSplitMax
    }
    
    if (nSplit == 1) {
      #if (verbose) write("\t full data mtrix: no splits", "")
      if (optBLAS & .Machine$sizeof.pointer == 8) {
        r <- tcrossprod(x / sqrt(rowSums(x ^ 2)))
      } else {
        r <- cor(xt)
      }
    } else if (nSplit > 1) {
      if (verbose)
        write("---> Computing split sizes...", "")
      lSplit <- floor(n / nSplit)
      iSplit <- vector("list", nSplit)
      for (i in 1:(nSplit - 1)) {
        iSplit[[i]] <- (lSplit * (i - 1) + 1):(lSplit * i)
      }
      iSplit[[nSplit]] <- (lSplit * (nSplit - 1) + 1):n
      
      if (verbose)
        write("---> Computing split combinations...", "")
      cSplit <-
        cbind(combn(nSplit, 2), rbind(c(1:nSplit), c(1:nSplit)))
      cSplit <- cSplit[, order(cSplit[1,], cSplit[2,])]
      if (verbose && n %% nSplit == 0) {
        write(paste(
          "---> Splitting data matrix:",
          nSplit,
          "splits of",
          paste(m, "x", length(iSplit[[1]]), sep = ""),
          "size"
        ),
        "")
      } else {
        write(paste(
          "---> Splitting data matrix:",
          (nSplit - 1),
          ifelse((nSplit - 1) == 1,
                 "split of", "splits of"),
          paste(m, "x", length(iSplit[[1]]), sep = ""),
          "size"
        ),
        "")
        write(paste(
          "---> Splitting data matrix:",
          1,
          "split of",
          paste(m, "x", length(iSplit[[nSplit]]), sep = ""),
          "size"
        ),
        "")
      }
      for (nc in 1:max(nSplit, ncol(cSplit))) {
        i1 <- iSplit[[cSplit[1, nc]]]
        i2 <- iSplit[[cSplit[2, nc]]]
        if (verbose)
          write(
            paste(
              "---> Correlation matrix: split #",
              sprintf("%3.0f", cSplit[1, nc]),
              "   x   split #",
              sprintf("%3.0f", cSplit[2, nc]),
              sep = ""
            ),
            ""
          )
        if (optBLAS & .Machine$sizeof.pointer == 8) {
          r[i2, i1] <- t(tcrossprod(x[i1,] / sqrt(rowSums(x[i1,] ^ 2)),
                                    x[i2,] / sqrt(rowSums(x[i2,] ^ 2))))
        } else {
          r[i2, i1] <- t(cor(xt[, i1], xt[, i2]))
        }
        if (!upperTri)
          r[i1, i2] <- t(r[i2, i1])
      }
    } else {
      stop(paste("invalid nSplit:", nSplit))
    }
    if (upperTri)
      r[col(r) >= row(r)] <- NA
    
    rr <- matrix(NA, nrow = nn, ncol = nn)
    rr[ii, ii] <- r
    rownames(rr) <- varnames
    colnames(rr) <- varnames
    
    #gc()
    return(rr)
  }
