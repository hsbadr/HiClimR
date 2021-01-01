% File man/grid2D.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL v3

\newcommand{\CRANpkg}{\href{https://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{grid2D}
\title{Generate longitude and latitude grid matrices}
\alias{grid2D}
\description{
  \code{\link{grid2D}} is a helper function that generates longitude and latitude
  rectangular mesh from short longitude and latitude vectors in gridded data.
}
\usage{
grid2D(lon = lon, lat = lat)
}
\arguments{
  \item{lon}{a vector of longitudes with length \code{N}. Longitudes takes
  values from \code{-180} to \code{180} (not \code{0} to \code{360}).
  For gridded data, the length may have the value (\code{n}) provided that
  \code{n * m = N} where \code{n = length(unique(lon))} and \code{m = length(unique(lat))}.}

  \item{lat}{a vector of latitudes with length \code{N} or \code{m}. See \code{lon}.}
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
  \bold{8}(4), 949-958, \doi{10.1007/s12145-015-0221-7}.

  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
  Hierarchical Climate Regionalization,
  \emph{Comprehensive R Archive Network (CRAN)},
  \url{https://cran.r-project.org/package=HiClimR}.
}
\author{
  Hamada S. Badr <badr@jhu.edu>, Benjamin F. Zaitchik <zaitchik@jhu.edu>,
  and Amin K. Dezfuli <amin.dezfuli@nasa.gov>.
}
\seealso{
  \code{\link{HiClimR}}, \code{\link{HiClimR2nc}}, \code{\link{validClimR}},
  \code{\link{geogMask}}, \code{\link{coarseR}}, \code{\link{fastCor}},
  \code{\link{grid2D}} and \code{\link{minSigCor}}.
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
