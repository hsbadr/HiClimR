HiClimR
=======

[![Lifecycle: Stable](https://img.shields.io/badge/Lifecycle-Stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Commits since release](https://img.shields.io/github/commits-since/hsbadr/HiClimR/latest.svg?color=green)](https://GitHub.com/hsbadr/HiClimR/commit/master/)
[![Last commit](https://img.shields.io/github/last-commit/hsbadr/HiClimR)](https://github.com/hsbadr/HiClimR/commits/master)
[![R](https://github.com/hsbadr/HiClimR/workflows/R/badge.svg)](https://github.com/hsbadr/HiClimR/actions)
  
[![CRAN Status](https://www.r-pkg.org/badges/version/HiClimR)](https://cran.r-project.org/package=HiClimR)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/HiClimR)](https://cran.r-project.org/package=HiClimR)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![DOI: 10.1007/s12145-015-0221-7](https://zenodo.org/badge/DOI/10.1007%2Fs12145-015-0221-7.svg)](https://doi.org/10.1007/s12145-015-0221-7)

[**``HiClimR``**](https://cran.r-project.org/package=HiClimR): **Hi**erarchical **Clim**ate **R**egionalization

## Table of Contents

  * [HiClimR](#hiclimr)
    * [Introduction](#introduction)
    * [Features](#features)
    * [Implementation](#implementation)
    * [Installation](#installation)
        * [From CRAN](#from-cran)
        * [From GitHub](#from-github)
    * [Source](#source)
    * [License](#license)
    * [Citation](#citation)
    * [History](#history)
    * [Examples](#examples)
        * [Single-Variate Clustering](#single-variate-clustering)
        * [Multivariate Clustering](#multivariate-clustering)
        * [Miscellaneous Examples](#miscellaneous-examples)

## Introduction

[**`HiClimR`**](https://cran.r-project.org/package=HiClimR) is a tool for **Hi**erarchical **Clim**ate **R**egionalization applicable to any correlation-based clustering. Climate regionalization is the process of dividing an area into smaller regions that are homogeneous with respect to a specified climatic metric. Several features are added to facilitate the applications of climate regionalization (or spatiotemporal analysis in general) and to implement a cluster validation function with an objective tree cutting to find an optimal number of clusters for a user-specified confidence level. These include options for preprocessing and postprocessing as well as efficient code execution for large datasets and options for splitting big data and computing only the upper-triangular half of the correlation/dissimilarity matrix to overcome memory limitations. Hybrid hierarchical clustering reconstructs the upper part of the tree above a cut to get the best of the available methods. Multivariate clustering (MVC) provides options for filtering all variables before preprocessing, detrending and standardization of each variable, and applying weights for the preprocessed variables.

[⇪](#hiclimr)

## Features

[**`HiClimR`**](https://cran.r-project.org/package=HiClimR) adds several features and a new clustering method (called, `regional` linkage) to hierarchical clustering in [**R**](https://www.r-project.org) (`hclust` function in `stats` library) including:

* data regridding
* coarsening spatial resolution
* geographic masking
   * by continents
   * by regions
   * by countries
* contiguity-constrained clustering
* data filtering by thresholds
   * mean threshold
   * variance threshold
* data preprocessing
   * detrending
   * standardization
   * PCA
* faster correlation function
   * splitting big data matrix
   * computing upper-triangular matrix
   * using optimized `BLAS` library on 64-Bit machines
     * `ATLAS`
     * `OpenBLAS`
     * `Intel MKL`
* different clustering methods
   * `regional` linkage or minimum inter-regional correlation
   * `ward`'s minimum variance or error sum of squares method
   * `single` linkage or nearest neighbor method
   * `complete` linkage or diameter
   * `average` linkage, group average, or UPGMA method
   * `mcquitty`'s or WPGMA method
   * `median`, Gower's or WPGMC method
   * `centroid` or UPGMC method
* hybrid hierarchical clustering
   * the upper part of the tree is reconstructed above a cut
   * the lower part of the tree uses user-selected method
   * the upper part of the tree uses `regional` linkage method
* multivariate clustering (MVC)
   * filtering all variables before preprocessing
   * detrending and standardization of each variable
   * applying weight for the preprocessed variables
* cluster validation
   * summary statistics based on raw data or the data reconstructed by PCA
   * objective tree cut using minimum significant correlation between region means
* visualization of regionalization results
* exporting region map and mean timeseries into NetCDF-4

The `regional` linkage method is explained in the context of a spatiotemporal problem, in which `N` spatial elements (e.g., weather stations) are divided into `k` regions, given that each element has a time series of length `M`. It is based on inter-regional correlation distance between the temporal means of different regions (or elements at the first merging step). It modifies the update formulae of `average` linkage method by incorporating the standard deviation of the merged region timeseries, which is a function of the correlation between the individual regions, and their standard deviations before merging. It is equal to the average of their standard deviations if and only if the correlation between the two merged regions is `100%`. In this special case, the `regional` linkage method is reduced to the classic `average` linkage clustering method.

[⇪](#hiclimr)

## Implementation

[Badr et al. (2015)](https://doi.org/10.1007/s12145-015-0221-7) describes the regionalization algorithms, features, and data processing tools included in the package and presents a demonstration application in which the package is used to regionalize Africa on the basis of interannual precipitation variability. The figure below shows a detailed flowchart for the package. `Cyan` blocks represent helper functions, `green` is input data or parameters, `yellow` indicates agglomeration Fortran code, and `purple` shows graphics options. For multivariate clustering (MVC), the input data is a list of matrices (one matrix for each variable with the same number of rows to be clustered; the number of columns may vary per variable). The blue dashed boxes involve a loop for all variables to apply mean and/or variance thresholds, detrending, and/or standardization per variable before weighing the preprocessed variables and binding them by columns in one matrix for clustering. `x` is the input `N x M` data matrix, `xc` is the coarsened `N0 x M` data matrix where `N0 ≤ N` (`N0 = N` only if `lonStep = 1` and `latStep = 1`), `xm` is the masked and filtered `N1 x M1` data matrix where `N1 ≤ N0` (`N1 = N0` only if the number of masked stations/points is zero) and `M1 ≤ M` (`M1 = M` only if no columns are removed due to missing values), and `x1` is the reconstructed `N1` x `M1` data matrix if PCA is performed.

<img src="https://github.com/hsbadr/HiClimR/raw/master/HiClimR.png" title="HiClimR Flowchart" alt="HiClimR Flowchart" style="display: block; margin: auto;" />

*[`HiClimR`](https://cran.r-project.org/package=HiClimR) is applicable to any correlation-based clustering.*

[⇪](#hiclimr)

## Installation

There are many ways to install an R package from precompiled binaries or source code. For more details, you may search for how to install an R package, but here are the most convenient ways to install [**`HiClimR`**](https://cran.r-project.org/package=HiClimR): 

#### From CRAN

This is the easiest way to install an R package on **Windows**, **Mac**, or **Linux**. You just fire up an [**R**](https://www.r-project.org) shell and type:

```R
install.packages("HiClimR")
```

In theory the package should just install, however, you may be asked to select your local mirror (i.e. which server should you use to download the package). If you are using **R-GUI** or **R-Studio**, you can find a menu for package installation where you can just search for [**`HiClimR`**](https://cran.r-project.org/package=HiClimR) and install it.

[⇪](#hiclimr)

#### From GitHub

This is intended for developers and requires a development environment (compilers, libraries, ... etc) to install the latest development release of [**`HiClimR`**](https://cran.r-project.org/package=HiClimR). On **Linux** and **Mac**, you can download the source code and use `R CMD INSTALL` to install it. In a convenient way, you may use [`remotes`](https://github.com/r-lib/remotes) as follows:

* Install the release version of `remotes` from [**CRAN**](https://cran.r-project.org):

```R
install.packages("remotes")
```

* Make sure you have a working development environment:

    * **Windows**: Install [`Rtools`](https://cran.r-project.org/bin/windows/Rtools/).
    * **Mac**: Install Xcode from the Mac App Store.
    * **Linux**: Install a compiler and various development libraries (details vary across different flavors of **Linux**).

* Install [**`HiClimR`**](https://cran.r-project.org/package=HiClimR) from [GitHub source](https://github.com/hsbadr/HiClimR):

```R
remotes::install_github("hsbadr/HiClimR")
```

[⇪](#hiclimr)

## Source

The source code repository can be found on GitHub at [hsbadr/HiClimR](https://github.com/hsbadr/HiClimR).

[⇪](#hiclimr)

## License

[**`HiClimR`**](https://cran.r-project.org/package=HiClimR) is licensed under [`GPL v3`](https://www.gnu.org/licenses/gpl-3.0). The code is modified by [Hamada S. Badr](https://hsbadr.github.io) from `src/library/stats/R/hclust.R` part of [**R** package](https://www.R-project.org) Copyright © 1995-2021 The [**R**](https://www.r-project.org) Core Team.

* This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

A copy of the GNU General Public License is available at https://www.r-project.org/Licenses.

Copyright © 2013-2021 Earth and Planetary Sciences (EPS), Johns Hopkins University (JHU).

[⇪](#hiclimr)

## Citation

To cite HiClimR in publications, please use:

```R
citation("HiClimR")
```
> Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015):
A Tool for Hierarchical Climate Regionalization, _Earth Science Informatics_,
**8**(4), 949-958, https://doi.org/10.1007/s12145-015-0221-7.

> Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
HiClimR: Hierarchical Climate Regionalization, _Comprehensive R Archive Network (CRAN)_,
https://cran.r-project.org/package=HiClimR.

[⇪](#hiclimr)

## History

|    Version    |     Date     |  Comment      |  Author          |  Email         |
|:-------------:|:------------:|:-------------:|:----------------:|:--------------:|
|               |   May 1992   |  **Original** |  F. Murtagh      |                |
|               |   Dec 1996   |  Modified     |  Ross Ihaka      |                |
|               |   Apr 1998   |  Modified     |  F. Leisch       |                |
|               |   Jun 2000   |  Modified     |  F. Leisch       |                |
|   **1.0.0**   |   03/07/14   |  **HiClimR**  |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.1**   |   03/08/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.2**   |   03/09/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.3**   |   03/12/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.4**   |   03/14/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.5**   |   03/18/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.6**   |   03/25/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.7**   |   03/30/14   |  **Hybrid**   |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.8**   |   05/06/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.9**   |   05/07/14   |  **CRAN**     |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.0**   |   05/15/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.1**   |   07/14/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.2**   |   07/26/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.3**   |   08/28/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.4**   |   09/01/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.5**   |   11/12/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.6**   |   03/01/15   |  **GitHub**   |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.2.0**   |   03/27/15   |  **MVC**      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.2.1**   |   05/24/15   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.2.2**   |   07/21/15   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.2.3**   |   08/05/15   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.0.0**   |   12/22/18   |  **NOTE**     |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.0**   |   01/01/19   |  **NetCDF**   |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.1**   |   01/02/19   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.2**   |   01/04/19   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.3**   |   01/10/19   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.4**   |   01/20/19   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.5**   |   12/10/19   |  **inherits** |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.6**   |   02/22/20   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.7**   |   11/05/20   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.8**   |   01/04/21   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |

[⇪](#hiclimr)

## Examples

#### Single-Variate Clustering

```R
library(HiClimR)
```
```R
#----------------------------------------------------------------------------------#
# Typical use of HiClimR for single-variate clustering:                            #
#----------------------------------------------------------------------------------#

## Load the test data included/loaded in the package (1 degree resolution)
x <- TestCase$x
lon <- TestCase$lon
lat <- TestCase$lat

## Generate/check longitude and latitude mesh vectors for gridded data
xGrid <- grid2D(lon = unique(TestCase$lon), lat = unique(TestCase$lat))
lon <- c(xGrid$lon)
lat <- c(xGrid$lat)

## Single-Variate Hierarchical Climate Regionalization
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
```
```R
#----------------------------------------------------------------------------------#
# Additional Examples:                                                             #
#----------------------------------------------------------------------------------#

## Use Ward's method
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 5, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Use data splitting for big data
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = TRUE, kH = NULL,
    members = NULL, nSplit = 10, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Use hybrid Ward-Regional method
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = TRUE, kH = NULL,
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
## Check senitivity to kH for the hybrid method above
```
[⇪](#hiclimr)

#### Multivariate Clustering

```R
#----------------------------------------------------------------------------------#
# Typical use of HiClimR for multivariate clustering:                              #
#----------------------------------------------------------------------------------#

## Load the test data included/loaded in the package (1 degree resolution)
x1 <- TestCase$x
lon <- TestCase$lon
lat <- TestCase$lat

 ## Generate/check longitude and latitude mesh vectors for gridded data
 xGrid <- grid2D(lon = unique(TestCase$lon), lat = unique(TestCase$lat))
 lon <- c(xGrid$lon)
 lat <- c(xGrid$lat)

## Test if we can replicate single-variate region map with repeated variable
y <- HiClimR(x=list(x1, x1), lon = lon, lat = lat, lonStep = 1, latStep = 1,
    geogMask = FALSE, continent = "Africa", meanThresh = list(10, 10),
    varThresh = list(0, 0), detrend = list(TRUE, TRUE), standardize = list(TRUE, TRUE),
    nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Generate a random matrix with the same number of rows
x2 <- matrix(rnorm(nrow(x1) * 100, mean=0, sd=1), nrow(x1), 100)

## Multivariate Hierarchical Climate Regionalization
y <- HiClimR(x=list(x1, x2), lon = lon, lat = lat, lonStep = 1, latStep = 1,
    geogMask = FALSE, continent = "Africa", meanThresh = list(10, NULL),
    varThresh = list(0, 0), detrend = list(TRUE, FALSE), standardize = list(TRUE, TRUE),
    weightMVC = list(1, 1), nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
## You can apply all clustering methods and options
```

[⇪](#hiclimr)

#### Miscellaneous Examples

```R
#----------------------------------------------------------------------------------#
# Miscellaneous examples to provide more information about functionality and usage #
# of the helper functions that can be used separately or for other applications.   #
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
t0 <- proc.time(); xcor <- fastCor(t(x)); proc.time() - t0
## compare with cor function
t0 <- proc.time(); xcor0 <- cor(t(x)); proc.time() - t0

## Check the valid options for geographic masking
geogMask()

## geographic mask for Africa
gMask <- geogMask(continent = "Africa", lon = lon, lat = lat, plot = TRUE,
    colPalette = NULL)

## Hierarchical Climate Regionalization Without geographic masking
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL, 
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01, 
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## With geographic masking (you may specify the mask produced above to save time)
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = TRUE, 
    continent = "Africa", meanThresh = 10, varThresh = 0, detrend = TRUE, 
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL, 
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01, 
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## With geographic masking and contiguity constraint
## Change contigConst as appropriate
y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = TRUE,
    continent = "Africa", contigConst = 1, meanThresh = 10, varThresh = 0, detrend = TRUE,
    standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
    members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
    validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
    plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)

## Find minimum significant correlation at 95% confidence level
rMin <- minSigCor(n = nrow(x), alpha = 0.05, r = seq(0, 1, by = 1e-06))

## Validtion of Hierarchical Climate Regionalization
z <- validClimR(y, k = 12, minSize = 1, alpha = 0.01, plot = TRUE, colPalette = NULL)

## Apply minimum cluster size (minSize = 25)
z <- validClimR(y, k = 12, minSize = 25, alpha = 0.01, plot = TRUE, colPalette = NULL)

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
RegionsMap <- matrix(y$region, nrow = length(unique(y$coords[, 1])), byrow = TRUE)
colPalette <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
    "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
image(unique(y$coords[, 1]), unique(y$coords[, 2]), RegionsMap, col = colPalette(ks))

## Visualization for gridded or ungridded data
plot(y$coords[, 1], y$coords[, 2], col = colPalette(max(y$region, na.rm = TRUE))[y$region], pch = 15, cex = 1)
## Change pch and cex as appropriate!

## Export region map and mean timeseries into NetCDF-4 file
library(ncdf4)
y.nc <- HiClimR2nc(y=y, ncfile="HiClimR.nc", timeunit="years", dataunit="mm")
## The NetCDF-4 file is still open to add other variables or close it
nc_close(y.nc)

```

[⇪](#hiclimr)
