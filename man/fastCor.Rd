% File man/fastCor.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2015 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{fastCor}
\title{Fast correlation for large matrices}
\alias{fastCor}
\description{
  \code{\link{fastCor}} is a helper function that compute Pearson correlation matrix
  for \code{\link{HiClimR}} and \code{\link{validClimR}} functions. It is similar 
  to \code{\link{cor}} function in R but uses a faster implementation on 64-bit
  machines (an optimized \code{BLAS} library is highly recommended). It can be 
  used to compute correlation matrix for the columns of any data matrix.
}
\usage{
fastCor(xt)
}
\arguments{
  \item{xt}{an (\code{M} rows by \code{N} columns) matrix of 'double' values: 
  \code{N} objects (spatial points or stations) to be clustered by \code{M} 
  observations (temporal points or years). It is the transpose of the imput
  matrix \code{x} required for \code{\link{HiClimR}} and 
  \code{\link{validClimR}} functions.}
}
\value{
  An (\code{N} rows by \code{N} columns) correlation matrix.
}
\details{
  The \code{\link{fastCor}} function computes the correlation matrix by 
  calling the cross product function in the Basic Linear Algebra Subroutines 
  (BLAS) library used by R. A significant performance improvement can be 
  achieved when building R  on 64-bit machines with an optimized BLAS library,
  such as ATLAS, OpenBLAS, or the commercial Intel Math Kernel Library.
}
\references{
  Badr, H. S., Zaitchik, B. F. and Dezfuli, A. K. (2015).
  Hierarchical Climate Regionalization. \emph{CRAN},
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

## Load test case data
x <- TestCase$x

## Use fastCor function to compute the correlation matrix
t0 <- proc.time() ; xcor <- fastCor(t(x)) ; proc.time() - t0
## compare with cor function
t0 <- proc.time() ; xcor0 <- cor(t(x)) ; proc.time() - t0
}
\keyword{HiClimR}
