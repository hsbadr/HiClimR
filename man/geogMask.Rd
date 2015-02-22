% File man/geogMask.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2015 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{geogMask}
\title{Geographic mask from longitude and latitute}
\alias{geogMask}
\description{
  \code{\link{geogMask}} is a helper function that preprocess input for the 
  \code{\link{HiClimR}} via \code{geogMask} parameter. 
}
\usage{
geogMask(continent=NULL, region=NULL, country=NULL, lon=NULL, lat=NULL,
  InDispute=TRUE, plot=FALSE, colPalette=NULL)
}
\arguments{
  \item{continent}{\code{NULL} or a string (or array of strings) to specify 
  \code{continent} name(s): only one of \code{continent}, \code{region}, or
   \code{country} should be speciefied. Valid list of \code{continent} names 
  can be obtained by running \code{geogMask()}.}

  \item{region}{\code{NULL} or a string (or array of strings) to specify 
  \code{region} name(s): only one of \code{continent}, \code{region}, or 
  \code{country} should be speciefied. Valid list of \code{region} names 
  can be obtained by running \code{geogMask()}.}

  \item{country}{\code{NULL} or a string (or array of strings) to specify 
  \code{country} ISO3 character code(s): only one of \code{continent}, 
  \code{region}, or \code{country} should be speciefied. Valid list of 
  \code{country} ISO3 character code(s) can be obtained by running 
  \code{geogMask()}.}

  \item{lon}{a vector of longitudes with length \code{N}.}

  \item{lat}{a vector of latitudes with length \code{N}.}

  \item{InDispute}{a logical: should the areas in dispute be considered for
  geographic masking by country? If \code{InDispute = TRUE} (the default),
  areas in dispute will be considered as a part of the \code{country}.}

  \item{plot}{a logical: should the plot method be called?}

  \item{colPalette}{a color palette or a list of colors such as that generated 
  by \code{rainbow}, \code{heat.colors}, \code{topo.colors}, 
  \code{terrain.colors} or similar functions.}
}
\value{
  A vector of indices for the spatial elements to be masked, 
  as required by \code{\link{HiClimR}}.
}
\details{
  In some applications, a user may want to focus on an area that is a 
  mask-defined subset of the full dataset. For instance, the NASA Tropical 
  Rainfall Measuring Mission (TRMM) data covers ocean and land, while a 
  researcher might be interested in the precipitation variability only over 
  land, a country, or a list of countries (e.g., Nile Basin countries). This 
  masking capability is supported by the \code{\link{geogMask}} helper function.
  It requires the longitute (\code{lon}) and latitude (\code{lat}) vectors 
  together with a string (or array of strings) to specify \code{continent} 
  name(s), \code{region} name(s), or \code{country} ISO3 character code(s) via 
  either \code{continent}, \code{region}, or \code{country} parameters. Valid 
  values for them can be obtained by running \code{geogMask()}. World mask data
  is based on the HIU Large Scale International Boundaries (LSIB) data
  (http://hiu.state.gov/data/data.aspx).
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
xGrid <- grid2D(lon = unique(TestCase$lon), lat = unique(TestCase$lat))
lon <- c(xGrid$lon)
lat <- c(xGrid$lat)

## Check the valid options for geographic masking
geogMask()

## geographic mask for Africa
gMask <- geogMask(continent = "Africa", lon = lon, lat = lat, plot = TRUE)
}
\keyword{HiClimR}
