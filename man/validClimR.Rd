% File man/validClimR.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL v3

\newcommand{\CRANpkg}{\href{https://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{validClimR}
\title{Validation of Hierarchical Climate Regionalization}
\alias{validClimR}
\description{
  \code{\link{validClimR}} computes indices for cluster validation, and an
  objective tree cut for \code{regional} linkage clustering method.
}
\usage{
validClimR(y = NULL, k = NULL, minSize = 1, alpha = 0.05, verbose = TRUE,
    plot = FALSE, colPalette = NULL, pch = 15, cex = 1)
}
\arguments{
  \item{y}{a dendrogram tree produced by \code{\link{HiClimR}}.}

  \item{k}{\code{NULL} or a n integer \code{k > 1} for the number of regions/clusters.
  Only for \code{regional} linkage method, \code{k = NULL} is supported, where the
  "optimal" number of regions will be used at a user specified significance
  level \code{alpha}. It is required to specify number of clusters \code{k}
  for the other methods, since they are not based on inter-cluster correlation.
  If \code{k = NULL} for these methods (except \code{regional}) linkage, the
  \code{validClimR} with be aborted. One can use \code{\link{validClimR}} function
  to compute inter-cluster correlation at different number of clusters to objectively
  cut the tree for the other methods, which could be computationally expensive to
  cover the entire merging history for large number of spatial elements.}

  \item{minSize}{minimum cluster size. The \code{regional} linkage method tend to
  isolate noisy data in small clusters. The \code{minSize} can be used to
  exclude these very small clusters from the \code{statSum} statistical
  summary, because they are most likely noisy data that need to be checked
  in a quality control step. The analysis may be then repeated.}

  \item{alpha}{confidence level: the default is \code{alpha = 0.05} for
  95\% confidence level.}

  \item{verbose}{logical to print processing information if \code{verbose = TRUE}.}

  \item{plot}{logical to call the plotting method if \code{plot = TRUE}.}

  \item{colPalette}{a color palette or a list of colors such as that generated
  by \code{rainbow}, \code{heat.colors}, \code{topo.colors},
  \code{terrain.colors} or similar functions.}

  \item{pch}{Either an integer specifying a symbol or a single character to
  be used as the default in plotting points. See \code{\link{points}} for
  possible values.}

  \item{cex}{A numerical value giving the amount by which plotting symbols should
  be magnified relative to the \code{default = 1}.}
}
\value{
  An object of class \code{HiClimR} which produces indices for validating
  the tree produced by the clustering process.
  The object is a list with the following components:

  \item{cutLevel}{the minimum significant correlation used for objective
    tree cut together with the corresponding confidence level.}

  \item{clustMean}{the cluster means which are the region's mean timeseries for
    all selected regions.}

  \item{clustSize}{cluster sizes for all selected regions.}

  \item{clustFlag}{a flag \code{0 or 1} to indicate the cluster used
    in \code{statSum} validation indices (\code{interCor},
    \code{intraCor}, \code{diffCor}, and \code{statSum}), based on
    \code{minSize} minimum cluster size.
    If \code{clustFlag = 0}, the cluster has been excluded because its size
    is less than the \code{minSize} minimum cluster size. The sum of
    \code{clustFlag} elements represents the selected number clusters.}

  \item{interCor}{inter-cluster correlations for all selected regions. It is
    the inter-cluster correlations between cluster means. The maximum inter-cluster
    correlation is a measure for separation or contiguity, and it is
    used for objective tree cut (to find the "optimal" number of clusters).}

  \item{intraCor}{intra-cluster correlations for all selected regions. It is
    the intra-cluster correlations between the mean of each cluster and its
    members. The average intra-cluster correlation is a weighted average for
    all clusters, and it is a measure for homogeneity.}

  \item{diffCor}{difference between intra-cluster correlation and maximum
  	inter-cluster correlation for all selected regions.}

  \item{statSum}{overall statistical summary for i\code{nterCluster},
    \code{intraCor}, and \code{diffCor}.}

  \item{region}{ordered regions vector of size \code{N} number of spatial
  	elements for the selected number of clusters, after excluding the
  	small clusters defined by \code{minSize} argument.}

  \item{regionID}{ordered regions ID vector of length equals the selected number
  	of clusters, after excluding the small clusters defined by \code{minSize} argument.
  	It helps in mapping ordered regions and their actual names before ordering.
  	Only the \code{region} component uses ordered ID, while other components use
  	the names used during the clustering process.}
}
\details{
  The \code{validClimR} function is used for validation of a dendrogram tree
  produced by \code{HiClimR}, by computing  detailed statistical information for
  each cluster about cluster means, sizes, intra- and inter-cluster correlations,
  and overall summary. It requires the preprocessed data matrix and the tree from
  \code{\link{HiClimR}} function as inputs. An optional parameter can be used to
  validate clustering for a selected number of clusters \code{k}. If \code{k = NULL},
  the default which supports only the \code{regional} linkage method, objective cutting
  of the tree to find the optimal number of clusters will be applied based on a user
  specified significance level (\code{alpha} parameter). In \code{regional} linkage method,
  noisy spatial elements are isolated in very small-size clusters or individuals since
  they do not correlate well with any other elements. They can be excluded from the
  validation indices (\code{interCor}, \code{intraCor}, \code{diffCor}, and \code{statSum}),
  based on \code{minSize} minimum cluster size. The excluded clusters are identified in
  the output of \code{validClimR} in \code{clustFlag}, which takes a value of \code{1}
  for selected clusters or \code{0} for excluded clusters. The sum of \code{clustFlag}
  elements represents the selected number clusters.This should be followed by a quality
  control step before repeating the analysis.
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
  and Amin K. Dezfuli <amin.dezfuli@nasa.gov>. \code{\link{HiClimR}} is
  a modification of \code{\link{hclust}} function, which is based on
  Fortran code contributed to STATLIB by F. Murtagh.
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

## Hierarchical Climate Regionalization
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE,
    kH = NULL, members = NULL, validClimR = TRUE, k = 12, minSize = 1,
    alpha = 0.01, plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Validtion of Hierarchical Climate Regionalization
z <- validClimR(y, k = 12, minSize = 1, alpha = 0.01, plot = TRUE)

## Use a specified number of clusters (k = 12)
z <- validClimR(y, k = 12, minSize = 1, alpha = 0.01, plot = TRUE)

## Apply minimum cluster size (minSize = 25)
z <- validClimR(y, k = 12, minSize = 25, alpha = 0.01, plot = TRUE)

## The optimal number of clusters, including small clusters
k <- length(z$clustFlag)

## The selected number of clusters, after excluding small clusters (if minSize > 1)
ks <- sum(z$clustFlag)
}
\keyword{HiClimR}
