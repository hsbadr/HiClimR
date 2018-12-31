% File man/TestCase.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\name{TestCase}
\alias{TestCase}
\alias{lon}
\alias{lat}
\alias{x}
\docType{data}
\title{Test Data for Functionality Demonstration of \code{HiClimR} Package}
\description{
  This data is a subset of University of East Anglia Climatic Research Unit
  (CRU) TS (timeseries) precipitation dataset version 3.2.
}
\usage{
data(TestCase)
}
\format{
  \code{TestCase} is a list of three components: \code{x}, \code{lon}, and \code{lat}.
  \code{x} is an (\code{6400} rows by \code{41} columns) matrix as required for
  \code{\link{HiClimR}} function. The rows represent spatial points (or stations),
  while the columns represent observations (temporal points or years). \code{lon}
  and \code{lat} are vectors of length \code{80} for unique longitudes and
  latitudes corrrdinates, where \code{80 * 80 = 6400} for this gridded data.
}
\details{
  CRU TS 3.21 data (1901-2012) is monthly gridded precipitation with \code{0.5} 
  degree resolution. This test data is a subset with 1 degree resolution for 
  African precipitation in January, 1949-1989.
}
\source{
  Climatic Research Unit (CRU) time-series datasets of variations in climate with
  variations in other phenomena.
}
\references{
  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015):
  A Tool for Hierarchical Climate Regionalization, \emph{Earth Science Informatics},
  \bold{8}(4), 949-958, \url{https://doi.org/10.1007/s12145-015-0221-7}.

  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
  Hierarchical Climate Regionalization,
  \emph{Comprehensive R Archive Network (CRAN},
  \url{https://cran.r-project.org/package=HiClimR}.

  Harris, I., Jones, P. D., Osborn, T. J., and Lister, D. H. (2014):
  Updated high-resolution grids of monthly climatic observations - the CRU TS3.10 Dataset,
  \emph{International journal of climatology}, \bold{34}, 623-642,
  \url{https://doi.org/10.1002/joc.3711}.
}
\examples{
require(HiClimR)

x <- TestCase$x
dim(x)
colnames(x)
}
\keyword{datasets}
