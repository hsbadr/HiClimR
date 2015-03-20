# HiClimR
###A tool for **Hi**erarchical **Clim**ate **R**egionalization
[**`HiClimR`**](http://cran.r-project.org/package=HiClimR) is a tool for **Hi**erarchical **Clim**ate **R**egionalization applicable to any correlation-based clustering. It adds several features and a new clustering method (called, `regional` linkage) to hierarchical clustering in R (`hclust` function in `stats` library) including:

* data regridding
* coarsening spatial resolution
* geographic masking
   * by continents
   * by regions
   * by countries
* data filtering by thresholds:
    * `meanThresh` for mean
    * `varThresh` for variance
* data preprocessing:
    * detrending
    * standardization
    * PCA
* faster correlation function
   * splitting big data matrix
   * computing upper-triangular matrix
   * using BLAS library on 64-Bit machines
* preliminary big data support
   * considering memory-efficient algorithms
* multi-variate clustering (MVC)
* hybrid hierarchical clustering
* cluster validation
   * summary statistics
   * objective tree cut
* visualization

## Design and Implementation
[Badr et. al (2015)](http://blaustein.eps.jhu.edu/~hbadr1/#Publications) describes the regionalization algorithms and data processing tools included in the package and presents a demonstration application in which the package is used to regionalize Africa on the basis of interannual precipitation variability. The figure below shows a detailed flowchart for the package. `Cyan` blocks represent helper functions, `green` is input data or parameters, `yellow` indicates agglomeration Fortran code, and `purple` shows graphics options.

![blank-container](http://blaustein.eps.jhu.edu/~hbadr1/images/HiClimR.png)
*[`HiClimR`](http://cran.r-project.org/package=HiClimR) is applicable to any correlation-based clustering.*

## License

[**`HiClimR`**](http://cran.r-project.org/package=HiClimR) is licensed under `GPL-2 | GPL-3`. The code is modified by [Hamada S. Badr](http://blaustein.eps.jhu.edu/~hbadr1) from `src/library/stats/R/hclust.R` part of [R package](http://www.R-project.org) Copyright © 1995-2015 The R Core Team.

Copyright © 2013-2015 Earth and Planetary Sciences (EPS), Johns Hopkins University (JHU).

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

A copy of the GNU General Public License is available at http://www.r-project.org/Licenses.

## Documentation

For information on how to use [**`HiClimR`**](http://cran.r-project.org/package=HiClimR), check out [user manual](http://cran.r-project.org/web/packages/HiClimR/HiClimR.pdf) and the examples bellow.

## Source Code

The source code repository can be found on GitHub at [https://github.com/hsbadr/HiClimR](https://github.com/hsbadr/HiClimR).

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
|   **1.0.7**   |   03/30/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.8**   |   05/06/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.0.9**   |   05/07/14   |  **CRAN**     |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.0**   |   05/15/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.1**   |   07/14/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.2**   |   07/26/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.3**   |   08/28/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.4**   |   09/01/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.5**   |   11/12/14   |  Updated      |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.1.6**   |   03/01/15   |  **GitHub**   |  Hamada S. Badr  |  badr@jhu.edu  |
|   **1.2.0**   |   03/20/15   |  **MVC**      |  Hamada S. Badr  |  badr@jhu.edu  |

## Change Log

#### 2015-03-20: version 1.2.0

* Multi-variate clustering (MVC): the input matrix `x` can now be a list of matrices (one matrix for each variable). Data preprocessing is specified by lists of `meanThresh`, `varThresh`, `detrend`, and `standardize` with the same length of `x`. Each variable is separately preprocessed to allow for all possible options. Check the update user manual for more details!
* Preliminary big data support: function `fastCor` can now split the data matrix into `nSplit` splits with a logical parameter `upperTri` to compute the upper-triangular matrix only, which includes all required info since the correlation/dissimilarity matrix is symmetric. This almost doubles the use of existing memory for big date.
* Fix "integer overflow" for big/large data.
* Added `verbose` parameter for all functions and a logical parameter `dendrogram` for plotting dendrogram.
* Backword compatibility with previous versions.

#### 2015-03-01: version 1.1.6

* Setting minimum `k = 2`, for objective tree cutting: this addresses an issue caused by undefined `k = NULL` in `validClimR` function when all inter-cluster correlations are significant at the user-specified significance level.
* Code reformatting using [`formatR`](http://cran.r-project.org/package=formatR).
* Package description and URLs have been revised.
* Source code is now maintained on GitHub by author(s).

#### 2014-11-12: version 1.1.5

* Updating description, URL, and citation info.

#### 2014-09-01: version 1.1.4

* An issue has been addressed for zero-length mask vector: `Error in -mask : invalid argument to unary operator`. This error has been intoduced in v1.1.2+ after fixing the data-mean bug.

#### 2014-08-28: version 1.1.3

* The user manual has been revised.
* `lonSkip` and `latSkip` have been renamed to `lonStep` and `latStep`, respectively.
* Minor bug fixes.

#### 2014-07-26: version 1.1.2

* A bug has been fixed where data mean is added to centered data if `standardize = FALSE`. In this case, the objective tree cut for `regional` linkage method and the output `data` component are now corrected to match input parameters especially when clustring of raw data (without standardization) is requested (centered data was used in previous versions).

#### 2014-07-14: version 1.1.1

* Minor bug fixes and memory optimizations especially for the geographic masking function `geogMask`.
* The limit for data size has been removed (use with caution).
* A logical parameter `InDispute` has been added to `geogMask` function to optionally consider areas in dispute for geographic masking by country.
* Changelog has been updated and reformatted.

#### 2014-05-15: version 1.1.0

* Code cleanup and bug fixes.
* An issue with the `fastCor` function that degrades its performance on 32-bit machines has been fixed. A significant performance improvement can only be achieved when building R on 64-bit machines with an optimized BLAS library, such as ATLAS, OpenBLAS, or the commercial Intel MKL.
* The citation info has been updated to reflect the current status of the technical paper, which will be cited and included as vignettes upon publication.

#### 2014-05-07: version 1.0.9

* Minor changes and fixes for CRAN.
* For memory considerations, smaller test case is provided (1 degree resolution instead of 0.5 degree) and the resolution option (`res` parameter) in geographic masking has been removed.
* Mask data is only available in 0.1 degree (~10 km) resolustion.
* `LazyLoad` and `LazyData` are enabled in the description file.
* The `worldMask` and `TestCase` data are converted to lists to avoid conflicts of variable names (`lon`, `lat`, `info`, and `mask`) with lazy loading of the data.

#### 2014-05-06: version 1.0.8

* Code cleanup and bug fixes
* Region maps are unified for both gridded and ungridded data

#### 2014-03-30: version 1.0.7

* Hybrid hierarchical clustering feature that utilizes the pros of the available methods, especially the better overall homogeneity in Ward's method and the separation and objective tree cut of the regional linkage method.
* The logical parameter `hybrid` is added to enable a second step of using regional linkage clustering method for reconstructing the upper part of the tree at a cut of defined by `kH` (number of clusters to restart with using the `regional` linkage method).
* If `kH = NULL`, the tree will be reconstructed for the upper part with the first merging cost larger than the mean merging cost for the entire tree (merging cost is the loss of overall homogeneity at each merging step).
* If hybrid clustering is requested, the updated upper part of the tree will be used for cluster validation.

#### 2014-03-25: version 1.0.6

* Code cleanup and bug fixes.

#### 2014-03-18: version 1.0.5

* Code cleanup and bug fixes.
* It adds support to generate region maps for ungridded data.

#### 2014-03-14: version 1.0.4

* Code cleanup and bug fixes.
* The `coarseR` function is  called inside the core `HiClimR` function.
* The `coords` component has been added to the output tree for the longitude and latitude coordinates since they may be changed by coarsening. The `lon` and `lat` vectors are more flexible for gridded data, as they will be automatically converted to a rectangular grid if necessary.
* The `validClimR` function does not require `lon` and `lat` arguments where they are now available in the output tree (`coords` component).

#### 2014-03-12: version 1.0.3

* Code cleanup and bug fixes.
* The package has one main function `HiClimR`, which internally calls all other functions including `validClimR` function.
* It has unified component names for all functions.
* Objective tree cut is supported only for the `regional` linkage method. Otherwise, the number of clusters `k` should be specified.
* The new clustering method has been renamed from `HiClimR` to `regional` linkage method.

#### 2014-03-09: version 1.0.2

* Code cleanup and bug fixes.
* It adds a new feature in `HiCLimR` that enables users to return the preprocessed data used for clustering, by a logical argument `retData`.
* The data will be returned in a component`data` of the output tree. This can be used to utilize the `HiCLimR` preprocessing for further analysis.
* Ordered regions vector for the selected number of clusters are now returned in the `region` component of `validCLimR` output with a length equals to the number of spatial elements `N`.

#### 2014-03-08: version 1.0.1

* Code cleanup and bug fixes.
* It adds a new feature in `validCLimR` that enables users to exclude very small clusters from validation indices `interCor`, `intraCor`, `diffCor`, and `statSum`, by setting a value for the minimum cluster size (`minSize` parameter) greater than one.
* The excluded clusters can be identified from the output of `validClimR` in `clustFlag` component, which takes a value of `1` for valid clusters or `0` for excluded clusters. In `HiClimR` method, noisy spatial elements (or stations) are isolated in very small-size clusters or individuals since they do not correlate well with any other elements. This should be followed by a quality control step.
* The function `coarseR` has been added for coarsening spatial resolution of the input matrix `x`.

#### 2014-03-07: version 1.0.0
* Initial version of `HiClimR` package that modifies the very efficient code of `hclust` function in the `stats` library.
* It adds an improved clustering method (called, `HiClimR`) to the set of available methods.
* The method is explained in the context of a spatio-temporal problem, in which `N` spatial elements (e.g., weather stations) are divided into `k` regions, given that each element has a time series of length `M`.
* It is based on inter-regional correlation distance between the temporal means of different regions (or elements at the first merging step).
* The dissimilarity/similarity between any two regions, in both `HiClimR` and `average` linkage methods, is based on their means (timeseries).
* The new `HiClimR` method modifies `average` update formulae by incorporating the standard deviation of the timeseries of the the merged region,  which is a function of the correlation between the individual regions, and their standard deviations before merging. It is equal to the average of their standard deviations if and only if the correlation between the two merged regions is `100%`. In this special case, the `HiClimR` method is reduced to the classic `average` linkage clustering method.
* Several features have been implemented to facilitate spatiotemporal analysis applications as well as cluster validation function `validClimR`, which implements an objective tree cutting to find the optimal number of clusters for a user-specified confidence level. These include options for preprocessing and postprocessing as well as efficient code execution for large datasets.
* It is also applicable to any correlation-based clustering.

## Examples:

```R
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
```
