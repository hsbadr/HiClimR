% File man/grid2D.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2015 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{grid2D}
\title{Generate longitude and latitude grid matrices}
\alias{grid2D}
\description{
  \code{\link{grid2D}} is a helper function that generates longitude and latitude
  rectangular mesh from short longitude and latitude vectors in gridded data.
}
\usage{
grid2D(lon=lon, lat=lat)
}
\arguments{
  \item{lon}{a vector of unique longitudes with length \code{n}.
  For gridded data, \code{n * m = N} where m is the length of
  unique latitudes and N is the total number of spatial elements.}

  \item{lat}{a vector of unique latitudes with length \code{m}.
  For gridded data, \code{n * m = N} where n is the length of
  unique longitudes and N is the total number of spatial elements.}
}
\value{
  A list with the following components:
  
  \item{lon}{an (\code{n} rows by \code{m} columns) matrix of 'double' values 
  for longitude mesh grid, or a vector with length \code{n * m}.}

  \item{lat}{an (\code{n} rows by \code{m} columns) matrix of 'double' values 
  for latitude mesh grid, or a vector with length \code{n * m}.}
}
\details{
  \code{\link{grid2D}} function convert the long latitude and longitude vectors 
  to a rectangular two-dimensional grid for visualization and geographic masking 
  purposes for gridded data in \code{HiClimR} package.
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

## Load test case data
x <- TestCase$x

## Generate longitude and latitude mesh vectors
xGrid <- grid2D(lon = unique(TestCase$lon), lat = unique(TestCase$lat))
lon <- c(xGrid$lon)
lat <- c(xGrid$lat)
}
\keyword{HiClimR}
