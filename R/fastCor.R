# $Id: fastCor.R, v1.1.6 2015/03/01 12:00:00 hsbadr EPS JHU            #
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
#  1.1.3    |  08/28/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.4    |  09/01/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#  1.1.5    |  11/12/14  |  Updated   |  Hamada Badr  |  badr@jhu.edu  #
#----------------------------------------------------------------------#
#  1.1.6    |  01/03/15  |  GitHub    |  Hamada Badr  |  badr@jhu.edu  #
#----------------------------------------------------------------------#
# COPYRIGHT(C) 2013-2015 Earth and Planetary Sciences (EPS), JHU.      #
#----------------------------------------------------------------------#
# Function: Fast correlation for large matrices                        #
#----------------------------------------------------------------------#

fastCor <- function(xt) {

    x <- t(xt) - colMeans(xt)
    
    if (.Machine$sizeof.pointer == 8) {
        r <- tcrossprod(x/sqrt(rowSums(x^2)))
    } else {
        r <- cor(xt)
    }
    
    return(r)
}
