% File man/coarseR.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2014 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{coarseR}
\title{Coarsening spatial resolution for gridded data}
\alias{coarseR}
\description{
  \code{\link{coarseR}} is a helper function that helps coarsening spatial 
  resolution of the input matrix for the \code{\link{HiClimR}} function. 
}
\usage{
coarseR(x=x, lon=lon, lat=lat, lonSkip=1, latSkip=1)
}
\arguments{
  \item{x}{an (\code{N} rows by \code{M} columns) matrix of 'double' values: 
  \code{N} objects (spatial points or stations) to be clustered by \code{M} 
  observations (temporal points or years). The \code{N} objects should be
  created from the original matrix \code{dataMat} using \code{as.vector(dataMat)},
  where \code{dataMat} is an (\code{n} rows by \code{m} columns) matrix,
  \code{n = length(unique(lon))}, and \code{m = length(unique(lat))}.}

  \item{lon}{a vector of longitudes with length \code{N}. For gridded data, 
  the length may have the value (\code{n}) provided that \code{n * m = N} where 
  \code{n = length(unique(lon))} and \code{m = length(unique(lat))}.}

  \item{lat}{a vector of latitudes with length \code{N} or \code{m}. See \code{lon}.}

  \item{lonSkip}{an integer greater than or equal to \code{1} for longitdue 
  step to coarsen the data. If \code{lonStep = 1}, the data will not be coarsened
  in the longitudinal dimension.}
  
  \item{latSkip}{an integer greater than or equal to \code{1} for latitude 
  step to coarsen the data. If \code{lonStep = 1}, the data will not be coarsened
  in the latitudinal dimension.}
}
\value{
  A list with the following components:
  
  \item{lon}{longitude mesh vector for the coarse data.}

  \item{lat}{latitude mesh vector for the coarse data.}

  \item{x}{coarser resolution of the input data matrix \code{x}.} 
}
\details{
  For high-resolution data, the computational requirements may not be met on
  old machines. This function enables the user to use coarser data in any 
  spatial dimension:longitude, latitude, or both. It is available  for testing
  the \code{HiClimR} package on old computers or machines with small memory 
  resources. The rows of output matrix (\code{x} component) will be also named 
  by longitude and latitude coordinates. If \code{lonSkip = 1} and \code{latSkip = 1}, 
  \code{\link{coarseR}} function will rename rows of matrix \code{x}.
}
\references{
  Badr, H. S., Zaitchik, B. F. and Dezfuli, A. K. (2014).
  Hierarchical Climate Regionalization: An Improved Hierarchical
  Clustering in R for Climate Regionalization. \emph{R package version},
  \code{1.1.0}, \url{http://cran.r-project.org/package=HiClimR}.
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
xGrid <- grid2D(lon=unique(TestCase$lon), lat=unique(TestCase$lat))
lon <- c(xGrid$lon)
lat <- c(xGrid$lat)

## Coarsening spatial resolution
xc <- coarseR(x=x, lon=lon, lat=lat, lonSkip=2, latSkip=2)
lon <- xc$lon
lat <- xc$lat
x <- xc$x

}
\keyword{HiClimR}
