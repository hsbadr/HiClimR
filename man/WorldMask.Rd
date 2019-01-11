% File man/WorldMask.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\name{WorldMask}
\alias{WorldMask}
\alias{info}
\alias{mask}
\docType{data}
\title{World Mask for Geographic Masking in HiClimR}
\description{
  This data is used for geographic masking by \code{\link{geogMask}}
  function in \code{HiClimR} package.
}
\usage{
data(WorldMask)
}
\format{
  \code{WorldMask} is a list with two components: \code{info} and \code{mask}. 
  \code{info} is an (\code{284} rows by \code{10} columns) matrix. The rows are for
  areas or countries while the columns are for codes required by \code{\link{geogMask}}.
  \code{mask} is an (\code{3601} rows by \code{1801} columns) matrix with integer
  values from \code{1} to \code{284} for the areas defined in \code{info}.

}
\details{
  This data is used internally by \code{\link{geogMask}} function for geographic masking
  in \code{HiClimR} package. The user is advised to refer to the function manual for more
  details. The world mask is available in \code{0.1} degree (\code{10} km) resolution. The
  \code{info} data provides information for continents, regions, and country codes).
}
\source{
  The data are based on the Humanitarian Information Unit (HIU) Large Scale
  International Boundaries (LSIB) dataset.
}
\references{
  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015):
  A Tool for Hierarchical Climate Regionalization, \emph{Earth Science Informatics},
  \bold{8}(4), 949-958, \url{https://doi.org/10.1007/s12145-015-0221-7}.

  Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
  Hierarchical Climate Regionalization,
  \emph{Comprehensive R Archive Network (CRAN},
  \url{https://cran.r-project.org/package=HiClimR}.

  LSIB Data: \url{https://hiu.state.gov/data/}.
}
\examples{
require(HiClimR)

geogMask()
}
\keyword{datasets}
