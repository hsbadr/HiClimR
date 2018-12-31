% File man/HiClimR2nc.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{https://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{HiClimR2nc}
\title{Export NetCDF-4 file for Hierarchical Climate Regionalization}
\alias{HiClimR2nc}
\description{
  \code{\link{HiClimR2nc}} is a helper function that exports region map
  and mean timeseries into NetCDF-4 file, using the \code{ncdf4} package.
}
\usage{
HiClimR2nc(y=NULL, ncfile="HiClimR.nc", timeunit="", dataunit="")
}
\arguments{
  \item{y}{a dendrogram tree produced by \code{\link{HiClimR}}.}

  \item{ncfile}{Path and name of the NetCDF-4 file to be created.}

  \item{timeunit}{an optional character string for the time units,
  A zero-length string (default: \code{timeunit=""}) removes units attribute.}

  \item{dataunit}{an optional character string for the data units,
  A zero-length string (default: \code{timeunit=""}) removes units attribute.}
}
\value{
  An object of class \code{ncdf4}, which has the fields described in \code{\link[ncdf4]{nc_open}}.
}
\details{
  \code{\link{HiClimR2nc}} function estimates the minimum significant correlation 
  for a sample size (number of observations or temporal points in a timeseries) 
  at a certain confidence level selected by the argument \code{alpha} and an 
  optional search range \code{r}. It is called by \code{\link{validClimR}}
  function objective tree cut based on the specified confidence level.
}
\references{
  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015):
  A Tool for Hierarchical Climate Regionalization, \emph{Earth Science Informatics},
  \bold{8}(4), 949-958, \url{https://doi.org/10.1007/s12145-015-0221-7}.

  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
  Hierarchical Climate Regionalization,
  \emph{Comprehensive R Archive Network (CRAN},
  \url{https://cran.r-project.org/package=HiClimR}.
}
\author{
  Hamada Badr <badr@jhu.edu>, Ben Zaitchik <zaitchik@jhu.edu>, and 
  Amin Dezfuli <dez@jhu.edu>.
}
\seealso{
  \code{\link{HiClimR}}, \code{\link{HiClimR2nc}}, \code{\link{validClimR}},
  \code{\link{geogMask}}, \code{\link{coarseR}}, \code{\link{fastCor}},
  \code{\link{grid2D}} and \code{\link{minSigCor}}.
}
\examples{
require(HiClimR)
require(ncdf4)

## Load test case data
x <- TestCase$x

## Generate longitude and latitude mesh vectors
xGrid <- grid2D(lon = unique(TestCase$lon), lat = unique(TestCase$lat))
lon <- c(xGrid$lon)
lat <- c(xGrid$lat)

## Hierarchical Climate Regionalization
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE,
    kH = NULL, members = NULL, validClimR = TRUE, k = 12, minSize = 1,
    alpha = 0.01, plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Export region map and mean timeseries into NetCDF-4 file
HiClimR2nc(y=y, ncfile="HiClimR.nc", timeunit="years", dataunit="mm")
}
\keyword{HiClimR}
