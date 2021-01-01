# $Id: minSigCor.R                                                        #
#-------------------------------------------------------------------------#
# This function is a part of HiClimR R package.                           #
#-------------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2021 Earth and Planetary Sciences (EPS), JHU.         #
#-------------------------------------------------------------------------#
# Function: Minimum significant correlation for a sample size             #
#-------------------------------------------------------------------------#

minSigCor <-
  function(n = 41,
           alpha = 0.05,
           r = seq(0, 1, by = 1e-06)) {
    dof <- n - 2
    Fstat <- r^2 * dof / (1 - r^2)
    p.value <- 1 - pf(Fstat, 1, dof)
    p.value[p.value > alpha] <- NA
    i <- which(p.value == max(p.value, na.rm = TRUE))

    RsMin <- list(cor = r[i], p.value = p.value[i])

    return(RsMin)
  }
