% File man/fastCor.Rd
% Part of the HiClimR R package
% Copyright(C) 2013-2019 Department of Earth and Planetary Sciences, JHU.
% Distributed under GPL 2 or later

\newcommand{\CRANpkg}{\href{https://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\name{fastCor}
\title{Fast correlation for large matrices}
\alias{fastCor}
\description{
  \code{\link{fastCor}} is a helper function that compute Pearson correlation matrix
  for \code{\link{HiClimR}} and \code{\link{validClimR}} functions. It is similar 
  to \code{\link{cor}} function in R but uses a faster implementation on 64-bit
  machines (an optimized \code{BLAS} library is highly recommended). \code{\link{fastCor}} 
  also uses a memory-efficient algorithm that allows for splitting the data matrix and 
  only compute the upper-triangular part of the correlation matrix. It can be used to 
  compute correlation matrix for the columns of any data matrix.
}
\usage{
fastCor(xt, nSplit = 1, upperTri = FALSE, optBLAS = FALSE, verbose = TRUE)
}
\arguments{
  \item{xt}{an (\code{M} rows by \code{N} columns) matrix of 'double' values: 
  \code{N} objects (spatial points or stations) to be clustered by \code{M} 
  observations (temporal points or years). It is the transpose of the imput
  matrix \code{x} required for \code{\link{HiClimR}} and 
  \code{\link{validClimR}} functions.}

  \item{nSplit}{integer number greater than or equal to one, to split the data matrix into 
  \code{nSplit} splits of the total number of columns \code{ncol(xt)}. If \code{nSplit = 1},
  the default method will be used to compute correlation matrix for the full data matrix 
  (no splits). If \code{nSplit > 1}, the correlation matrix (or the upper-triangular part 
  if \code{upperTri = TRUE}) will be allocated and filled with the computed correlation 
  sub-matrix for each split. the first \code{n-1} splits have equal size while the last 
  split may include any remaining columns. This is used with \code{upperTri = TRUE} to  
  compute only the upper-triangular part of the correlation matrix. The maximum number of 
  splits \code{nSplitMax = floor(N / 2)} makes splits with 2 columns; 
  if \code{nSplit > nSplitMax}, \code{nSplitMax} will be used. Very large number of splits
  \code{nSplit} makes computation slower but it could handle big data or if the available 
  memory is not enough to allocate the correlation matrix, which helps in solving the 
  \dQuote{Error: cannot allocate vector of size...} memory limitation problem. It is
  recommended to start with a small number of splits. If the data is very large
  compared to the physical memory, it is highly recommended to use a 64-Bit machine 
  with enough memory resources and/or use coarsening feature for gridded data by setting 
  \code{lonStep > 1} and \code{latStep > 1}.}

  \item{upperTri}{logical to compute only the upper-triangular half of the correlation 
  matrix if \code{upperTri = TRUE} and \code{nSplit > 1}., which includes all required info 
  since the correlation/dissimilarity matrix is symmetric. This almost halves memory use, 
  which can be very important for big data.}

  \item{optBLAS}{logical to use optimized BLAS library if installed and \code{optBLAS = TRUE}
  only on 64-bit machines.}

  \item{verbose}{logical to print processing information if \code{verbose = TRUE}.}
}
\value{
  An (\code{N} rows by \code{N} columns) correlation matrix.
}
\details{
  The \code{\link{fastCor}} function computes the correlation matrix by 
  calling the cross product function in the Basic Linear Algebra Subroutines 
  (BLAS) library used by R. A significant performance improvement can be 
  achieved when building R on 64-bit machines with an optimized BLAS library,
  such as \emph{ATLAS}, \emph{OpenBLAS}, or the commercial \emph{Intel MKL}.
  For big data, the memory required to allocate the square matrix of correlations
  may exceed the total amount of physical memory available resulting in
  \dQuote{Error: cannot allocate vector of size...}. \code{\link{fastCor}} allows
  for splitting the data matrix into \code{nSplit} splits and only computes the 
  upper-triangular part of the correlation matrix with \code{upperTri = TRUE}.
  This almost halves memory use, which can be very important for big data. 
  If \code{nSplit > 1}, the correlation matrix (or the upper-triangular part if
  \code{upperTri = TRUE}) will be allocated and filled with computed correlation 
  sub-matrix for each split. the first \code{n-1} splits have equal size while 
  the last split may include any remaining columns. 
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

## Load test case data
x <- TestCase$x

## Use fastCor function to compute the correlation matrix
t0 <- proc.time() ; xcor <- fastCor(t(x)) ; proc.time() - t0
## compare with cor function
t0 <- proc.time() ; xcor0 <- cor(t(x)) ; proc.time() - t0

\dontrun{

## Split the data into 10 splits and return upper-triangular half only
xcor10 <- fastCor(t(x), nSplit = 10, upperTri = TRUE)

}
}
\keyword{HiClimR}
