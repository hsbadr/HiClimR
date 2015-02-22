% File man/HiClimR.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2015 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{HiClimR}
\title{Hierarchical Climate Regionalization: 
An Improved Hierarchical Clustering in R for Climate Regionalization}
\alias{HiClimR}
\description{
  \code{HiClimR} package modifies and improves hierarchical clustering in R (\code{\link{hclust}} 
  function in the \code{stats} library), for climate regionalization. It adds a new clustering
  method (called, \code{regional} linkage) to the set of available methods together with
  several features including regridding (\code{\link{grid2D}} function), coarsening 
  spatial resolution (\code{\link{coarseR}} function), geographic masking 
  (\code{\link{geogMask}} function), data thresholds, detrending and standardization 
  preprocessing, faster correlation function(\code{\link{fastCor}} function), hybrid
  hierarchical clustering (\code{hybrid} logical argument), and 
  cluster validation (\code{\link{validClimR}} and \code{\link{minSigCor}} functions). 
  
  The \code{regional} linkage method is explained in the context of a spatio-temporal 
  problem, in which \code{N} spatial elements (e.g., weather stations) are divided 
  into \code{k} regions, given that each element has a time series of length \code{M}. 
  It is based on inter-regional correlation distance between the temporal means of 
  different regions (or elements at the first merging step). It modifies the update 
  formulae of \code{average} linkage method by incorporating the standard deviation 
  of the timeseries of the the merged region,  which is a function of the correlation 
  between the individual regions, and their standard deviations before merging. 
  It is equal to the average of their standard deviations if and only if the correlation 
  between the two merged regions is \code{100\%}. In this special case, the \code{regional} 
  linkage method is reduced to the classic \code{average} linkage clustering method. 
  Many features are added to facilitate spatiotemporal analysis applications and to utilize 
  a cluster validation function \code{\link{validClimR}}, which implements an objective 
  tree cutting to find an optimal number of clusters for a user-specified confidence 
  level. These include options for preprocessing and postprocessing as well as efficient
  code execution for large datasets.
  
  Badr et. al (2015) describes the regionalization algorithms and data processing tools
  included in the package and presents a demonstration application in which the package is
  used to regionalize Africa on the basis of interannual precipitation variability.
  
  \emph{It is applicable to any correlation-based clustering.}
}
\usage{
HiClimR(

  # Input data matrix (N spatial elements x M observations)
  x, 

  # Coarsening spatial resolution
  lon=NULL, lat=NULL, lonStep=1, latStep=1,

  # Geographic masking:
  geogMask=FALSE, gMask=NULL, continent=NULL, region=NULL, country=NULL,

  # Data thresholds:
  meanThresh=NULL, varThresh=0, 

  # Data preprocessing:
  detrend=FALSE, standardize=FALSE, nPC=NULL, 

  # Clustering options:
  method="ward", hybrid=FALSE, kH=NULL, members=NULL, 

  # Cluster validation:
  validClimR=TRUE, rawStats=TRUE, k=NULL, minSize=1, alpha=0.05, 

  # Graphical options:
  plot=TRUE, colPalette=NULL, hang=-1, labels=FALSE

  )
}
\arguments{
  \item{x}{an (\code{N} rows by \code{M} columns) matrix of 'double' values: 
  \code{N} objects (spatial points or stations) to be clustered by \code{M} 
  observations (temporal points or years).F or gridded data, the \code{N}
  objects should be created from the original matrix \code{dataMat} using
  \code{as.vector(dataMat)}, where \code{dataMat} is an (\code{n} rows by
  \code{m} columns) matrix, \code{n = length(unique(lon))} and
  \code{m = length(unique(lat))}. Zero-variance rows (e.g., stations 
  with zero variability) and/or missing values (e.g., years with missing 
  observations) are allowed. The zero-variance rows and the columns with
  missing values will be removed. However, it is recommended to take care of 
  both zero-variance rows and missing values before clustering.}

  \item{lon}{a vector of longitudes with length \code{N}. For gridded data, 
  the length may have the value (\code{n}) provided that \code{n * m = N} where 
  \code{n = length(unique(lon))} and \code{m = length(unique(lat))}.}

  \item{lat}{a vector of latitudes with length \code{N} or \code{m}. See \code{lon}.}

  \item{lonStep}{an integer greater than or equal to \code{1} for longitdue 
  step to coarsen gridded data in the longitudinal direction. If \code{lonStep = 1}, 
  gridded data will not be coarsened in the longitudinal direction (the default).
  If \code{lonStep = 2}, every other grid in longitudinal direction will be retained.}
  
  \item{latStep}{an integer greater than or equal to \code{1} for latitude 
  step to coarsen gridded data in the latitudinal direction. If \code{latStep = 1}, 
  gridded data will not be coarsened in the latitudinal direction (the default). 
  If \code{latStep = 2}, every other grid in latitudinal direction will be retained.
  \code{lonStep} and \code{latStep} are independent so that user can optionally 
  apply different coarsening level to each dimension.}
  
  \item{geogMask}{a logical: if \code{geogMask = TRUE}, \code{\link{geogMask}} 
  function will be called. Additional arguments are required. 
  It requires the longitute and latitude vector together with a string 
  (or array of strings) to specify \code{continent}, \code{region} 
  name(s), or \code{country} ISO3 character code(s). If \code{gMask != NULL}, 
  the provided \code{gmask} vector will be used for geographic masking without 
  calling \code{\link{geogMask}}.}
  
  \item{gMask}{A vector of indices for the spatial elements to be masked, 
  as required by \code{\link{HiClimR}}. This is typically an output vector 
  from \code{\link{geogMask}} function. This helps in saving time when the
  same geographic mask will be used many times.}

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

  \item{meanThresh}{\code{NULL} or a threshold for the temporal mean: 
  This is used with \code{varThresh} to mask zero- and near-zero-variance 
  data, Observations with mean less than or equal to meanThresh will 
  be removed. If \code{meanThresh = NULL}, then the \code{varThresh} will 
  be used either to mask zero-variance data by default or by increased 
  variance threshold to mask near-zero-variance data.}

  \item{varThresh}{zero or a threshold for the temporal variance: This is 
  used with \code{meanThresh} to mask zero- and near-zero-variance data, 
  Observations with variance less than or equal to varThresh will 
  be removed. If \code{varThresh = 0}, then the zero-variance data 
  will masked (defaut).}

  \item{detrend}{a logical: should the data be detrended before clustering? 
  Detrending (removing the linear trend) is important when variations from 
  temporal point to another is of interest (e.g., interannual variability). 
  The columns of the data matrix \code{x} should be temporally ordered (constant 
  step size) or have appropriate names (e.g., \code{colnames(x) = years[1:M]).}}

  \item{standardize}{a logical: should the data be standardized before 
  clustering? The standardized data makes use of the mean of equally-weighted 
  objects within each cluster (cluster mean = mean of standardized variables 
  within the cluster). Otherwise, the mean of raw data will be used (cluster 
  mean = mean of raw variables within the cluster). The variance of the mean 
  is updated at each agglomeration step.}

  \item{nPC}{\code{NULL} or number of principal components (PCs) to be retained. 
  If \code{nPC = NULL}, then the raw data will be used for clustering. 
  Otherwise, the data will be filtered and reconstructed using \code{nPC} PCs 
  obtained from SVD-based PCA. The \code{detrend} and/or \code{standardize} 
  options will be applied, if requested, before PCA.}

  \item{method}{the agglomeration method to be used. This should be (an 
  unambiguous abbreviation of) one of \code{"regional"}, \code{"ward"}, 
  \code{"single"}, \code{"complete"}, \code{"average"}, \code{"mcquitty"}, 
  \code{"median"} or \code{"centroid"}. The default is \code{"ward"} method.}
  
  \item{hybrid}{a logical: should the upper part of the tree be reconstructed
  using \code{regional} linkage clustering method?
  This adds hybrid hierarchical clustering feature to get the best of
  the availables methods. It utilizes the pros of available methods, especially
  the better overall homogeneity in Ward's method and the separation, contguity, 
  and objective tree cut of the regional linkage method.
  If \code{hybrid = FALSE}, only the default clustering using the slected
  \code{method} will be used (i.e., no hybrid clustering).
  Otherwise, the upper part of the tree will be reconstructed above a cut of
  /code{kH} clusters using \code{regional} linkage method. Note: hybrid option
  is redundant when using \code{regional} linkage as the main clustering
  method (\code{method} argument)!}
  
  \item{kH}{\code{NULL} or an integer for the number of regions/clusters in the
  upper part of the tree to be reconstructed with \code{regional} linkage method,
  if \code{hybrid = TRUE}. If \code{kH = NULL}, the tree will be reconstructed
  for the upper part with the first merging cost larger than the mean merging cost
  for the entire tree. If hybrid clustering is requested, the updated upper part
  of the tree will be used for cluster validation, and so \code{kH} should be
  greater than the final number of clusters \code{k}, if selected.}
  
  \item{members}{\code{NULL} or a vector with length size of \code{d}. 
  See the \sQuote{Details} section.}
  
  \item{validClimR}{a logical: If \code{validClimR = TRUE}, \code{\link{validClimR}} 
  will be called to compute validation indices including statistical summary for
  inter- and intra-cluster correlations. This is computationally expensive. It can
  also objectively cut the dendrogram tree for \code{regional} custering method,
  if \code{k = NULL}.}

  \item{rawStats}{a logical: should validation indices be computed based on 
  the raw data or PCA-filtered data?}

  \item{k}{\code{NULL} or an integer \code{k > 1} for the number of regions/clusters. 
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

  \item{plot}{a logical: should the plot method be called?}

  \item{colPalette}{a color palette or a list of colors such as that generated 
  by \code{rainbow}, \code{heat.colors}, \code{topo.colors}, 
  \code{terrain.colors} or similar functions.}

  \item{hang}{The fraction of the plot height by which labels should hang
    below the rest of the plot.
    A negative value will cause the labels to hang down from 0.}

  \item{labels}{A character vector of labels for the leaves of the
    tree. By default the row names or row numbers of the original data are
    used. If \code{labels = FALSE} no labels at all are plotted.}
}
\value{
  An object of class \bold{HiClimR} and \bold{hclust}, which 
  describes the tree produced by the clustering process.
  The object is a list with the following components:
  
  \item{merge}{an \eqn{n-1} by 2 matrix.
    Row \eqn{i} of \code{merge} describes the merging of clusters
    at step \eqn{i} of the clustering.
    If an element \eqn{j} in the row is negative,
    then observation \eqn{-j} was merged at this stage.
    If \eqn{j} is positive then the merge
    was with the cluster formed at the (earlier) stage \eqn{j}
    of the algorithm.
    Thus negative entries in \code{merge} indicate agglomerations
    of singletons, and positive entries indicate agglomerations
    of non-singletons.}

  \item{height}{a set of \eqn{n-1} real values (non-decreasing for
    ultrametric trees).
    The clustering \emph{height}: that is, the value of
    the criterion associated with the clustering
    \code{method} for the particular agglomeration.}

  \item{order}{a vector giving the permutation of the original
    observations suitable for plotting, in the sense that a cluster
    plot using this ordering and matrix \code{merge} will not have
    crossings of the branches.}

  \item{labels}{labels for each of the objects being clustered.}

  \item{method}{the cluster method that has been used.}

  \item{call}{the call which produced the result.}

  \item{dist.method}{the distance that has been used to create \code{d}
    (only returned if the distance object has a \code{"method"}
    attribute).}

  \item{skip}{a vector of \code{lonStep} and \code{latStep} if \code{coarseR = TRUE}.}

  \item{PCA}{if \code{nPC != NULL}, the eigenvalues, explained variance,
    and accumulated variance will be stored here.}

  \item{coords}{an (\code{Nc} rows by \code{2} columns) matrix of 'double' values:
    longitude and latitude coordinates for the preprocessed data used for clustering, 
    where \code{NC} is the number of spatial elements to be clustered after coarsening 
    spatial resolution by \code{lonStep} and \code{latStep}. It will be returned only 
    if \code{lon} and \code{lat} vectors were defined. It will be similar to the provided 
    \code{lon} and \code{lat} if \code{lonStep = 1} and \code{latStep = 1}.}

  \item{data}{the preprocessed data used for clustering will be stored here. 
    If \code{rawData = TRUE} and {nPC != NULL}, the preprocessed data without
    filtering (PCA) will be returned here.}

  \item{mask}{a vector of the indices of masked spatial points by both
    geographic masking and data thresholds.}

  \item{treeH}{An object of class \bold{hclust}, which describes the upper part of
    the tree reconstructed by the hybrid clustering process if \code{hybrid = TRUE}.}
  
  If \code{validClimR = TRUE}, an object of class \bold{HiClimR}, which produces 
  indices for validating the tree produced by the clustering process, will be merged 
  in the dendrogram tree above. This object is a list with the following components:
  
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
    is less than the \code{minSize} minmum cluster size. The sum of 
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
  
  There are \code{\link{print}}, \code{\link{plot}} and \code{identify}
  (see \code{\link{identify.hclust}}) methods and  
  \code{\link{rect.hclust}()} functions for \code{hclust} objects.
}
\details{
  The \code{\link{HiClimR}} function is based on \code{\link{hclust}}). It 
  performs a hierarchical cluster analysis using Pearson correlation distance 
  dissimilarity for the \eqn{N} objects being clustered. Initially, each 
  object is assigned to its own cluster and then the algorithm proceeds 
  iteratively, at each stage joining the two most similar clusters, continuing 
  until there is just a single cluster. At each stage distances between 
  clusters are recomputed by a dissimilarity update formula according to 
  the particular clustering method being used.

  The different clustering methods provided by \code{\link{hclust}}) are 
  available. The \emph{regional} linkage clustering method mainimizes inter-cluster 
  correlations between cluster means (see \code{Badr et al. 2015}). 
  \emph{Ward's} minimum variance method aims at finding compact, spherical clusters. 
  The \emph{complete linkage} method finds similar clusters. The \emph{single 
  linkage} method (which is closely related to the minimal spanning tree) 
  adopts a \sQuote{friends of friends} clustering strategy. The other methods 
  can be regarded as aiming for clusters with characteristics somewhere 
  between the single and complete link methods. Note however, that methods 
  \code{"median"} and \code{"centroid"} are \emph{not} leading to a 
  \emph{monotone distance} measure, or equivalently the resulting dendrograms 
  can have so called \emph{inversions} (which are hard to interpret).

  If \code{members != NULL}, then \code{d} is taken to be a
  dissimilarity matrix between clusters instead of dissimilarities
  between singletons and \code{members} gives the number of observations
  per cluster.  This way the hierarchical cluster algorithm can be
  \sQuote{started in the middle of the dendrogram}, e.g., in order to
  reconstruct the part of the tree above a cut (see examples).
  Dissimilarities between clusters can be efficiently computed (i.e.,
  without \code{hclust} itself) only for a limited number of
  distance/linkage combinations, the simplest one being squared
  Euclidean distance and centroid linkage.  In this case the
  dissimilarities between the clusters are the squared Euclidean
  distances between cluster means.

  In hierarchical cluster displays, a decision is needed at each merge to
  specify which subtree should go on the left and which on the right.
  Since, for \eqn{n} observations there are \eqn{n-1} merges,
  there are \eqn{2^{(n-1)}} possible orderings for the leaves
  in a cluster tree, or dendrogram.
  The algorithm used in \code{hclust} is to order the subtree so that
  the tighter cluster is on the left (the last, i.e., most recent,
  merge of the left subtree is at a lower value than the last
  merge of the right subtree).
  Single observations are the tightest clusters possible,
  and merges involving two observations place them in order by their
  observation sequence number.
}
\references{
  Badr, H. S., Zaitchik, B. F. and Dezfuli, A. K. (2015).
  Hierarchical Climate Regionalization. \emph{CRAN},
  \url{http://cran.r-project.org/package=HiClimR}.

  Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
  \emph{The New S Language}.
  Wadsworth & Brooks/Cole. (S version.)

  Everitt, B. (1974).
  \emph{Cluster Analysis}.
  London: Heinemann Educ. Books.

  Hartigan, J. A. (1975).
  \emph{Clustering  Algorithms}.
  New York: Wiley.

  Sneath, P. H. A. and R. R. Sokal (1973).
  \emph{Numerical Taxonomy}.
  San Francisco: Freeman.

  Anderberg, M. R. (1973).
  \emph{Cluster Analysis for Applications}.
  Academic Press: New York.

  Gordon, A. D. (1999).
  \emph{Classification}. Second Edition.
  London: Chapman and Hall / CRC

  Murtagh, F. (1985).
  \dQuote{Multidimensional Clustering Algorithms}, in
  \emph{COMPSTAT Lectures 4}.
  Wuerzburg: Physica-Verlag
  (for algorithmic details of algorithms used).

  McQuitty, L.L. (1966).
  Similarity Analysis by Reciprocal Pairs for Discrete and Continuous
  Data.
  \emph{Educational and Psychological Measurement}, \bold{26}, 825--831.
}
\author{
  Hamada Badr <badr@jhu.edu>, Ben Zaitchik <zaitchik@jhu.edu>, and 
  Amin Dezfuli <dez@jhu.edu>. The \code{\link{HiClimR}} is a modification of 
  \code{\link{hclust}} function, which is based on Fortran code 
  contributed to STATLIB by F. Murtagh.
}
\seealso{
  \code{\link{HiClimR}}, \code{\link{validClimR}}, \code{\link{geogMask}}, 
  \code{\link{coarseR}}, \code{\link{fastCor}}, \code{\link{grid2D}}, 
  \code{\link{minSigCor}}. \code{\link{identify.hclust}}, \code{\link{rect.hclust}}, 
  \code{\link{cutree}}, \code{\link{dendrogram}}, and \code{\link{kmeans}}.
}
\examples{
require(HiClimR)

#----------------------------------------------------------------------------------#
# Typical use of HiClimR:                                                          #
#----------------------------------------------------------------------------------#

## Load the test data included/loaded in the package (1 degree resolution)
x <- TestCase$x

lon <- TestCase$lon
lat <- TestCase$lat

## Generate/check longitude and latitude mesh vectors for gridded data
xGrid <- grid2D(lon = unique(TestCase$lon), lat = unique(TestCase$lat))

lon <- c(xGrid$lon)
lat <- c(xGrid$lat)

## Hierarchical Climate Regionalization
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "regional", hybrid = FALSE, 
    kH = NULL, members = NULL, validClimR = TRUE, k = NULL, minSize = 1, 
    alpha = 0.01, plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

#----------------------------------------------------------------------------------#
# Additional Examples:                                                             #
#----------------------------------------------------------------------------------#


## Use Ward's method
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL, 
    members = NULL, validClimR = TRUE, k = NULL, minSize = 1, alpha = 0.01, 
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Use hybrid Ward-Regional method
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = TRUE, kH = NULL, 
    members = NULL, validClimR = TRUE, k = NULL, minSize = 1, alpha = 0.01, 
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
## Check senitivity to kH for the hybrid method above

#----------------------------------------------------------------------------------#
# Advanced examples to provide more information about code                         #
# functionality and usage of the available helper functions                        #
# that can be used separately or for other applications.                           #
#----------------------------------------------------------------------------------#

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

## Use fastCor function to compute the correlation matrix
t0 <- proc.time()
xcor <- fastCor(t(x))
proc.time() - t0
## compare with cor function
t0 <- proc.time()
xcor0 <- cor(t(x))
proc.time() - t0

## Check the valid options for geographic masking
geogMask()

## geographic mask for Africa
gMask <- geogMask(continent = "Africa", lon = lon, lat = lat, plot = TRUE, 
    colPalette = NULL)

## Hierarchical Climate Regionalization Without geographic masking
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "regional", hybrid = FALSE, 
    kH = NULL, members = NULL, validClimR = TRUE, k = NULL, minSize = 1, 
    alpha = 0.01, plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## With geographic masking (specify the mask produced bove to save time)
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = TRUE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "regional", hybrid = FALSE, 
    kH = NULL, members = NULL, validClimR = TRUE, k = NULL, minSize = 1, 
    alpha = 0.01, plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Find minimum significant correlation at 95% confidence level
rMin <- minSigCor(n = nrow(x), alpha = 0.05, r = seq(0, 1, by = 1e-06))

## Validtion of Hierarchical Climate Regionalization
z <- validClimR(y, k = NULL, minSize = 1, alpha = 0.01, plot = TRUE, colPalette = NULL)

## Apply minimum cluster size (minSize = 25)
z <- validClimR(y, k = NULL, minSize = 25, alpha = 0.01, plot = TRUE, colPalette = NULL)

## The optimal number of clusters, including small clusters
k <- length(z$clustFlag)

## The selected number of clusters, after excluding small clusters (if minSize > 1)
ks <- sum(z$clustFlag)

## Dendrogram plot
plot(y, hang = -1, labels = FALSE)

## Tree cut
cutTree <- cutree(y, k = k)
table(cutTree)

## Visualization for gridded data
RegionsMap <- matrix(z$region, nrow = length(unique(y$coords[, 1])), byrow = TRUE)
colPalette <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", 
    "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
image(unique(y$coords[, 1]), unique(y$coords[, 2]), RegionsMap, col = colPalette(ks))

## Visualization for gridded or ungridded data
plot(y$coords[, 1], y$coords[, 2], col = z$region, pch = 20)
}
\keyword{HiClimR}
