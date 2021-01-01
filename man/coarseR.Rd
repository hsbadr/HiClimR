% File man/coarseR.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL v3

\newcommand{\CRANpkg}{\href{https://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{coarseR}
\title{Coarsening spatial resolution for gridded data}
\alias{coarseR}
\description{
  \code{\link{coarseR}} is a helper function that helps coarsening spatial
  resolution of the input matrix for the \code{\link{HiClimR}} function.
}
\usage{
coarseR(x = x, lon = lon, lat = lat, lonStep = 1, latStep = 1, verbose = TRUE)
}
\arguments{
  \item{x}{an (\code{N} rows by \code{M} columns) matrix of 'double' values:
  \code{N} objects (spatial points or stations) to be clustered by \code{M}
  observations (temporal points or years). For gridded data, the \code{N}
  objects should be created from the original matrix \code{x0} using
  \code{as.vector(t(x0))}, where \code{x0} is an (\code{n} rows by
  \code{m} columns) matrix, \code{n = length(unique(lon))} and
  \code{m = length(unique(lat))}.}

  \item{lon}{a vector of longitudes with length \code{N}. For gridded data,
  the length may have the value (\code{n}) provided that \code{n * m = N} where
  \code{n = length(unique(lon))} and \code{m = length(unique(lat))}.}

  \item{lat}{a vector of latitudes with length \code{N} or \code{m}. See \code{lon}.}

  \item{lonStep}{an integer greater than or equal to \code{1} for longitude
  step to coarsen gridded data in the longitudinal direction. If \code{lonStep = 1},
  gridded data will not be coarsened in the longitudinal direction (the default).
  If \code{lonStep = 2}, every other grid in longitudinal direction will be retained.}

  \item{latStep}{an integer greater than or equal to \code{1} for latitude
  step to coarsen gridded data in the latitudinal direction. If \code{latStep = 1},
  gridded data will not be coarsened in the latitudinal direction (the default).
  If \code{latStep = 2}, every other grid in latitudinal direction will be retained.
  \code{lonStep} and \code{latStep} are independent so that user can optionally
  apply different coarsening level to each dimension.}

  \item{verbose}{logical to print processing information if \code{verbose = TRUE}.}
}
\value{
  A list with the following components:

  \item{lon}{longitude mesh vector for the coarsened data.}

  \item{lat}{latitude mesh vector for the coarsened data.}

  \item{rownum}{original row numbers for the coarsened data.}

  \item{x}{coarsened data of the input data matrix \code{x}.}
}
\details{
  For high-resolution data, the computational and memory requirements may not be
  met on old machines. This function enables the user to use coarser data in any
  spatial dimension:longitude, latitude, or both. It is available  for testing
  or running \code{HiClimR} package on old computers or machines with small memory
  resources. The rows of output matrix (\code{x} component) will be also named
  by longitude and latitude coordinates. If \code{lonStep = 1} and \code{latStep = 1},
  \code{\link{coarseR}} function will just rename rows of matrix \code{x}.
}
\references{
  Hamada S. Badr, Zaitchik, B. F., and Dezfuli, A. K. (2015):
  A Tool for Hierarchical Climate Regionalization, \emph{Earth Science Informatics},
  \bold{8}(4), 949-958, \doi{10.1007/s12145-015-0221-7}.

  Hamada S. Badr, Zaitchik, B. F., and Dezfuli, A. K. (2014):
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

## Coarsening spatial resolution
xc <- coarseR(x = x, lon = lon, lat = lat, lonStep = 2, latStep = 2)
lon <- xc$lon
lat <- xc$lat
x <- xc$x
}
\keyword{HiClimR}
