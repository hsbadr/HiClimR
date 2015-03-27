% File man/minSigCor.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2015 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{minSigCor}
\title{Minimum significant correlation for a sample size}
\alias{minSigCor}
\description{
  \code{\link{minSigCor}} is a helper function that estimates the minimum
  significant correlation for a smaple size \code{n} at a confidence level 
  defined by the argument \code{alpha}.
}
\usage{
minSigCor(n=41, alpha=0.05, r=seq(0, 1, by=1e-6))
}
\arguments{
  \item{n}{sample size or the length of a timeseries vector.}

  \item{alpha}{confidence level: the default is \code{alpha = 0.05} for 
  95\% confidence level.}

  \item{r}{a vector of values from \code{0} to \code{1} to search for the 
  minimum signifcant correlation for the user-specified sample size 
  \code{n} at confidence level \code{alpha}. This should be a subset of the
  valid positiva correlation range \code{0-1}. The default is to search for the
  minimum significant correlation in the complete range \code{0-1} with a very 
  fine step of \code{1e-6}. For faster computations, the user may set a shorter
  range with larger step (e.g., seq(0.1, 0.5, by=1e-3)).}
}
\value{
  A positive value beween \code{0} and \code{1} for the estimated the minimum 
  significant correlation.
}
\details{
  \code{\link{minSigCor}} function estimates the minimum significant correlation 
  for a sample size (number of observations or temporal points in a timeseries) 
  at a certain confidence level selected by the argument \code{alpha} and an 
  optional search range \code{r}. It is called by \code{\link{validClimR}}
  function objective tree cut based on the specified confidence level.
}
\references{
  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015):
  A Tool for Hierarchical Climate Regionalization, \emph{Earth Science Informatics}, 
  In Review.

  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
  Hierarchical Climate Regionalization, \emph{CRAN},
  \url{http://cran.r-project.org/package=HiClimR}.
}
\author{
  Hamada Badr <badr@jhu.edu>, Ben Zaitchik <zaitchik@jhu.edu>, and 
  Amin Dezfuli <dez@jhu.edu>.
}
\seealso{
  \code{\link{HiClimR}}, \code{\link{validClimR}}, \code{\link{geogMask}}, 
  \code{\link{coarseR}}, \code{\link{fastCor}}, \code{\link{grid2D}}, and 
  \code{\link{minSigCor}}.
}
\examples{
require(HiClimR)

## Find minimum significant correlation at 95% confidence level
rMin <- minSigCor(n = 41, alpha = 0.05, r = seq(0, 1, by = 1e-06))
}
\keyword{HiClimR}
