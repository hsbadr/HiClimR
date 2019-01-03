HiClimR
=======

**``HiClimR``** — **Hi**erarchical **Clim**ate **R**egionalization

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
    * [Changes](#changes)
        * [2019-01-02: version 2.1.1](#2019-01-02-version-211)
        * [2019-01-01: version 2.1.0](#2019-01-01-version-210)
        * [2018-12-22: version 2.0.0](#2018-12-22-version-200)
        * [2015-08-05: version 1.2.3](#2015-08-05-version-123)
        * [2015-07-21: version 1.2.2](#2015-07-21-version-122)
        * [2015-05-24: version 1.2.1](#2015-05-24-version-121)
        * [2015-03-27: version 1.2.0](#2015-03-27-version-120)
        * [2015-03-01: version 1.1.6](#2015-03-01-version-116)
        * [2014-11-12: version 1.1.5](#2014-11-12-version-115)
        * [2014-09-01: version 1.1.4](#2014-09-01-version-114)
        * [2014-08-28: version 1.1.3](#2014-08-28-version-113)
        * [2014-07-26: version 1.1.2](#2014-07-26-version-112)
        * [2014-07-14: version 1.1.1](#2014-07-14-version-111)
        * [2014-05-15: version 1.1.0](#2014-05-15-version-110)
        * [2014-05-07: version 1.0.9](#2014-05-07-version-109)
        * [2014-05-06: version 1.0.8](#2014-05-06-version-108)
        * [2014-03-30: version 1.0.7](#2014-03-30-version-107)
        * [2014-03-25: version 1.0.6](#2014-03-25-version-106)
        * [2014-03-18: version 1.0.5](#2014-03-18-version-105)
        * [2014-03-14: version 1.0.4](#2014-03-14-version-104)
        * [2014-03-12: version 1.0.3](#2014-03-12-version-103)
        * [2014-03-09: version 1.0.2](#2014-03-09-version-102)
        * [2014-03-08: version 1.0.1](#2014-03-08-version-101)
        * [2014-03-07: version 1.0.0](#2014-03-07-version-100)
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
   * `regional` linakage or minimum inter-regional correlation
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
* visualization of regionaliztion results
* exporting region map and mean timeseries into NetCDF-4

The `regional` linkage method is explained in the context of a spatio-temporal problem, in which `N` spatial elements (e.g., weather stations) are divided into `k` regions, given that each element has a time series of length `M`. It is based on inter-regional correlation distance between the temporal means of different regions (or elements at the first merging step). It modifies the update formulae of `average` linkage method by incorporating the standard deviation of the merged region timeseries, which is a function of the correlation between the individual regions, and their standard deviations before merging. It is equal to the average of their standard deviations if and only if the correlation between the two merged regions is `100%`. In this special case, the `regional` linkage method is reduced to the classic `average` linkage clustering method.

[⇪](#hiclimr)

## Implementation

[Badr et. al (2015)](https://doi.org/10.1007/s12145-015-0221-7) describes the regionalization algorithms, features, and data processing tools included in the package and presents a demonstration application in which the package is used to regionalize Africa on the basis of interannual precipitation variability. The figure below shows a detailed flowchart for the package. `Cyan` blocks represent helper functions, `green` is input data or parameters, `yellow` indicates agglomeration Fortran code, and `purple` shows graphics options. For multivariate clustering (MVC), the input data is a list of matrices (one matrix for each variable with the same number of rows to be clustered; the number of columns may vary per variable). The blue dashed boxes involve a loop for all variables to apply mean and/or variance thresholds, detrending, and/or standardization per variable before weighing the preprocessed variables and binding them by columns in one matrix for clustering. `x` is the input `N x M` data matrix, `xc` is the coarsened `N0 x M` data matrix where `N0 ≤ N` (`N0 = N` only if `lonStep = 1` and `latStep = 1`), `xm` is the masked and filtered `N1 x M1` data matrix where `N1 ≤ N0` (`N1 = N0` only if the number of masked stations/points is zero) and `M1 ≤ M` (`M1 = M` only if no columns are removed due to missing values), and `x1` is the reconstructed `N1` x `M1` data matrix if PCA is performed.

<img src="https://github.com/hsbadr/HiClimR/raw/master/HiClimR.png" title="HiClimR Flowchart" alt="HiClimR Flowchart" style="display: block; margin: auto;" />

*[`HiClimR`](https://cran.r-project.org/package=HiClimR) is applicable to any correlation-based clustering.*

[⇪](#hiclimr)

## Installation

There are many ways to install an R package from precombiled binareies or source code. For more details, you may search for how to install an R package, but here are the most convenient ways to install [**`HiClimR`**](https://cran.r-project.org/package=HiClimR): 

#### From CRAN

This is the easiest way to install an R package on **Windows**, **Mac**, or **Linux**. You just fire up an [**R**](https://www.r-project.org) shell and type:

```R
        install.packages("HiClimR")
```

In theory the package should just install, however, you may be asked to select your local mirror (i.e. which server should you use to download the package). If you are using **R-GUI** or **R-Studio**, you can find a menu for package installation where you can just search for [**`HiClimR`**](https://cran.r-project.org/package=HiClimR) and install it.

[⇪](#hiclimr)

#### From GitHub

This is intended for developers and requires a development environment (compilers, libraries, ... etc) to install the latest development release of [**`HiClimR`**](https://cran.r-project.org/package=HiClimR). On **Linux** and **Mac**, you can download the source code and use `R CMD INSTALL` to install it. In a convenient way, you may use [`devtools`](https://github.com/hadley/devtools) as follows:

* Install the release version of `devtools` from [**CRAN**](https://cran.r-project.org):

```R
        install.packages("devtools")
```

* Make sure you have a working development environment:

    * **Windows**: Install [Rtools](https://cran.r-project.org/bin/windows/Rtools/).
    * **Mac**: Install Xcode from the Mac App Store.
    * **Linux**: Install a compiler and various development libraries (details vary across different flavors of **Linux**).

* Install [**`HiClimR`**](https://cran.r-project.org/package=HiClimR) from [GitHub source](https://github.com/hsbadr/HiClimR):

```R
        devtools::install_github("hsbadr/HiClimR")
```

[⇪](#hiclimr)

## Source

The source code repository can be found on GitHub at [https://github.com/hsbadr/HiClimR](https://github.com/hsbadr/HiClimR).

[⇪](#hiclimr)

## License

[**`HiClimR`**](https://cran.r-project.org/package=HiClimR) is licensed under `GPL-2 | GPL-3`. The code is modified by [Hamada S. Badr](http://pages.jh.edu/~hbadr1) from `src/library/stats/R/hclust.R` part of [**R** package](https://www.R-project.org) Copyright © 1995-2019 The [**R**](https://www.r-project.org) Core Team.

* This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

A copy of the GNU General Public License is available at https://www.r-project.org/Licenses.

Copyright © 2013-2019 Earth and Planetary Sciences (EPS), Johns Hopkins University (JHU).

[⇪](#hiclimr)

## Citation

To cite HiClimR in publications, please use:

```R
        citation("HiClimR")
```
Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015):
A Tool for Hierarchical Climate Regionalization, _Earth Science Informatics_,
**8**(4), 949-958, https://doi.org/10.1007/s12145-015-0221-7.

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014):
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
|   **2.0.0**   |   12/22/18   |  **Updated**  |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.0**   |   01/01/19   |  **Updated**  |  Hamada S. Badr  |  badr@jhu.edu  |
|   **2.1.1**   |   01/01/19   |  **Updated**  |  Hamada S. Badr  |  badr@jhu.edu  |

[⇪](#hiclimr)

## Changes

#### 2019-01-02: version 2.1.1

* `fastCor`: Fixed row/col names of the correlation matrix
* `fastCor`: Cleaned up zero-variance data check
* Examples: Minor comment update

#### 2019-01-01: version 2.1.0

* Added contiguity constraint based on geographic distance
* Exporting region map and mean timeseries into NetCDF-4 file
* Replaced `multi-variate` with `multivariate`
* Renamed `weightedVar` to `weightMVC`
* Updated citation information
* Updated and cleaned up package DESCRIPTION
* Updated and cleaned up README

#### 2018-12-22: version 2.0.0

* Fixed NOTE: Registering native routines
* `fastCor`: Removed zero-variance data
* `fastCor`: Introduced `optBLAS`
* `fastCor`: Code cleanup
* Reformatted R source code
* Updated and fixed the examples
* Updated CRU TS dataset citation
* Updated `README` and all URLs

#### 2015-08-05: version 1.2.3

* Fixed `geogMask` confusing country codes/names
* Fixed `geogMask` filtering InDispute areas
* Corrected data construction in the user manual
   * `x` should be created using `as.vector(t(x0))`
   * `x0` is the `n by m` original data matrix
   * `n = length(unique(lon))` and `m = length(unique(lat))`
* `coarseR` now returns the original row numbers
* Minor `README` corrections and updates

[⇪](#hiclimr)

#### 2015-07-21: version 1.2.2

* Changes for `Undefined global functions`
* Checking geographic masking output
* Minor `README` corrections and updates

[⇪](#hiclimr)

#### 2015-05-24: version 1.2.1

* Updating variance for multivariate clustering
* More plotting options (`pch` and `cex`)
* `geogMask` supports ungridded data
* Updated user manual with the following notes:
   * longitudes takes values from `-180` to `180` (not `0` to `360`)
   * for gridded data, the rows of input data matrix for each variable is ordered by longitudes
     * check `rownames(TestCase$x)` for example!
        * each row represents a station (grid point)
        * row name is in the form of `longitude,latitude`
* Minor `verbose` fixes and updates
* Minor `README` corrections and updates
* Citation updated: technical paper has been published

[⇪](#hiclimr)

#### 2015-03-27: version 1.2.0

* Multivariate clustering (MVC)
   * the input matrix `x` can now be a list of matrices (one matrix for each variable)
     * `length(x) = nvars` where `nvars` is the number of variables
     * number of rows `N` = number of objects (e.g., stations) to be clustered
     * number of columns `M` may vary for each variables
        * e.g., different temporal periods or record lengths 
   * Each variable is separately preprocessed to allow for all possible options
     * preprocessing is specified by lists with length of `nvars` (number of variables)
        * `length(meanThresh) = length(x) = nvars`
        * `length(varThresh) = length(x) = nvars`
        * `length(detrend) = length(x) = nvars`
        * `length(standardize) = length(x) = nvars`
        * `length(weightMVC) = length(x) = nvars`
     * filtering with `meanThresh` and `varThresh` thresholds
     * detrending with `detrend` option, if requested
     * standardization with `standardize` option, if requested
        * strongly recommended since variables may have different magnitudes  
     * weighting by the new `weightMVC` option (default is `1`)
     * combining variables by column (for each object: spatial points or stations)
     * applying PCA (if requested) and computing the correlation/dissimilarity matrix
* Preliminary big data support
   * function `fastCor` can now split the data matrix into `nSplit` splits
   * adds a logical parameter `upperTri` to `fastCor` function
     * computes only the upper-triangular half of the correlation/dissimilarity matrix
     * it includes all required information since the correlation/dissimilarity matrix is symmetric
     * this almost halves memory use, which can be very important for big data.
   * fixes "integer overflow" for very large number of objects to be clustered
* Adds a logical parameter `verbose` for printing processing information
* Adds a logical parameter `dendrogram` for plotting dendrogram
* Uses `\dontrun{}` to skip time-consuming examples
   * for more examples: https://github.com/hsbadr/HiClimR#examples
* Backword compatibility with previous versions
* The user manual is updated and revised

[⇪](#hiclimr)

#### 2015-03-01: version 1.1.6

* Setting minimum `k = 2`, for objective tree cutting
   * this addresses an issue caused by undefined `k = NULL` in `validClimR` function
   * when all inter-cluster correlations are significant at the user-specified significance level
* Code reformatting using [`formatR`](https://cran.r-project.org/package=formatR)
* Package description and URLs have been revised
* Source code is now maintained on GitHub by authors

[⇪](#hiclimr)

#### 2014-11-12: version 1.1.5

* Updating description, URL, and citation info


[⇪](#hiclimr)

#### 2014-09-01: version 1.1.4

* Addresses an issue for zero-length mask vector: `Error in -mask : invalid argument to unary operator`
   * this error was intoduced in v1.1.2+ after fixing the data-mean bug

[⇪](#hiclimr)

#### 2014-08-28: version 1.1.3

* The user manual is revised
* `lonSkip` and `latSkip` renamed to `lonStep` and `latStep`, respectively
* Minor bug fixes

[⇪](#hiclimr)

#### 2014-07-26: version 1.1.2

* A bug has been fixed where data mean is added to centered data if `standardize = FALSE`
   * objective tree cut and `data` component are now corrected 
     * to match input parameters especially when clustring of raw data
     * centered data was used in previous versions

[⇪](#hiclimr)

#### 2014-07-14: version 1.1.1

* Minor bug fixes and memory optimizations especially for the geographic masking function `geogMask`
* The limit for data size has been removed (use with caution)
* A logical parameter `InDispute` is added to `geogMask` function to optionally consider areas in dispute for geographic masking by country

[⇪](#hiclimr)

#### 2014-05-15: version 1.1.0

* Code cleanup and bug fixes
* An issue with `fastCor` function that degrades its performance on 32-bit machines has been fixed
   * A significant performance improvement can only be achieved when building R on 64-bit machines with an optimized `BLAS` library, such as `ATLAS`, `OpenBLAS`, or the commercial `Intel MKL`
* The citation info has been updated to reflect the current status of the technical paper

[⇪](#hiclimr)

#### 2014-05-07: version 1.0.9

* Minor changes and fixes for CRAN
* For memory considerations,
   * smaller test case with 1 degree resolution instead of 0.5 degree
   * the resolution option (`res` parameter) in geographic masking is removed
   * Mask data is only available in 0.1 degree (~10 km) resolustion
* `LazyLoad` and `LazyData` are enabled in the description file
* The `worldMask` and `TestCase` data are converted to lists to avoid conflicts of variable names (`lon`, `lat`, `info`, and `mask`) with lazy loading

[⇪](#hiclimr)

#### 2014-05-06: version 1.0.8

* Code cleanup and bug fixes
* Region maps are unified for both gridded and ungridded data

[⇪](#hiclimr)

#### 2014-03-30: version 1.0.7

* Hybrid hierarchical clustering feature that utilizes the pros of the available methods
   * especially the better overall homogeneity in Ward's method and the separation and objective tree cut of the regional linkage method.
   * The logical parameter `hybrid` is added to enable a second clustering step
     * using `regional` linkage for reconstructing the upper part of the tree at a cut
     * defined by `kH` (number of clusters to restart with using the `regional` linkage method)
     * If `kH = NULL`, the tree will be reconstructed for the upper part with the first merging cost larger than the mean merging cost for the entire tree
       * merging cost is the loss of overall homogeneity at each merging step
* If hybrid clustering is requested, the updated upper-part of the tree will be used for cluster validation.

[⇪](#hiclimr)

#### 2014-03-25: version 1.0.6

* Code cleanup and bug fixes

[⇪](#hiclimr)

#### 2014-03-18: version 1.0.5

* Code cleanup and bug fixes
* Adds support to generate region maps for ungridded data

[⇪](#hiclimr)

#### 2014-03-14: version 1.0.4

* Code cleanup and bug fixes
* The `coarseR` function is  called inside the core `HiClimR` function
* Adds `coords` component to the output tree for the longitude and latitude coordinates
   * they may be changed by coarsening
* `validClimR` function does not require `lon` and `lat` arguments
   * they are now available in the output tree (`coords` component)

[⇪](#hiclimr)

#### 2014-03-12: version 1.0.3

* Code cleanup and bug fixes
* One main/wrapper function `HiClimR` internally calls all other functions
* Unified component names for all functions
* Objective tree cut is supported only for the `regional` linkage method
   * Otherwise, the number of clusters `k` should be specified
* The new clustering method has been renamed from `HiClimR` to `regional` linkage method

[⇪](#hiclimr)

#### 2014-03-09: version 1.0.2

* Code cleanup and bug fixes.
* adds a new feature that to return the preprocessed data used for clustering, by a logical argument `retData`.
   * the data will be returned in a component`data` of the output tree
   * this can be used to utilize `HiCLimR` preprocessing options for further analysis
* Ordered regions vector for the selected number of clusters are now returned in the `region` component
     * length equals the number of spatial elements `N`

[⇪](#hiclimr)

#### 2014-03-08: version 1.0.1

* Code cleanup and bug fixes
* Adds a new feature in `validCLimR` that enables users to exclude very small clusters from validation indices `interCor`, `intraCor`, `diffCor`, and `statSum`, by setting a value for the minimum cluster size (`minSize > 1`)
   * the excluded clusters can be identified from the output of `validClimR` in `clustFlag` component, which takes a value of `1` for valid clusters or `0` for excluded clusters
   * in `HiClimR` (currently, `regional` linkage) method, noisy spatial elements (or stations) are isolated in very small-size clusters or individuals since they do not correlate well with any other elements
   * this should be followed by a quality control step
* Adds `coarseR` function for coarsening spatial resolution of the input matrix `x`

[⇪](#hiclimr)

#### 2014-03-07: version 1.0.0
* Initial version of `HiClimR` package that modifies `hclust` function in `stats` library
* Adds a new clustering method to the set of available methods
* The new method is explained in the context of a spatio-temporal problem, in which `N` spatial elements (e.g., stations) are divided into `k` regions, given that each element has observations (or timeseries) of length `M`
   *  minimizes the inter-regional correlation between region means
   *  modifies `average` update formulae by incorporating the standard deviation of the mean of the merged region
     *  a function of the correlation between the individual regions, and their standard deviations before merging
     *  equals the average of their standard deviations if and only if the correlation between the two merged regions is `100%`.
     *  in this special case, the new method is reduced to the classic `average` linkage clustering method
* Several features are included to facilitate spatiotemporal analysis applications:
   *  options for preprocessing and postprocessing
   *  efficient code execution for large datasets.
   *  cluster validation function `validClimR`
     *  implements an objective tree cut to find an optimal number of clusters
* Applicable to any correlation-based clustering

[⇪](#hiclimr)

## Examples

#### Single-Variate Clustering

```R
library(HiClimR)

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
require(HiClimR)

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
require(HiClimR)

#----------------------------------------------------------------------------------#
# Miscellaneous examples to provide more information about functionality and usage #
# of the helper functions that can be used separately or for other applications.   #                          #
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
HiClimR2nc(y=y, ncfile="HiClimR.nc", timeunit="years", dataunit="mm")

```

[⇪](#hiclimr)
