# HiClimR 2.1.9

* Updated citation in package DESCRIPTION
* Updated NAMESPACE and documentation
* Fixed spelling errors
* Updated lifecycle URL in the README

# HiClimR 2.1.8

* Code cleanup and formatting
* Removed HISTORY comments from source code
* Replaced `1:n` expressions with `seq_len(n)`
* Updated citation, manual, and user information
* Updated documents after code formatting
* Updated package DESCRIPTION and added reference DOI
* Updated package URL: https://hsbadr.github.io/HiClimR/
* README: Updated README.md and added NEWS.md

# HiClimR 2.1.7

* Updated package DESCRIPTION and author information
* Updated copyright year to 2021
* README: Added Markdown badges
* README: Added Digital Object Identifier (DOI) badge
* README: Linked version and download badges to CRAN
* README: Updated URLs

# HiClimR 2.1.6

* README: Added CRAN downloads badge
* R: Fix non-informative failure for unsupported input of a vector

# HiClimR 2.1.5

* R: Use `inherits()` to check class inheritance

# HiClimR 2.1.4

* Added vignette for HiClimR Bug Reporting
* `HiClimR2nc`: Updated documentation and examples
* man: Use `\code{}` instead of `\bold{}` for classes

# HiClimR 2.1.3

* Fixed spelling errors and allowed custom words
* `HiClimR2nc`: Fixed timeseries variable definition
* `README`: Link `HiClimR` to `CRAN` package page

# HiClimR 2.1.2

* Fixed example ERROR in CRAN checks
* Added example to export NetCDF-4 file
* Updated dependencies and suggested packages

# HiClimR 2.1.1

* `fastCor`: Fixed row/col names of the correlation matrix
* `fastCor`: Cleaned up zero-variance data check
* Examples: Minor comment update

# HiClimR 2.1.0

* Supported contiguity constraint based on geographic distance
* Exporting region map and mean timeseries into NetCDF-4 file
* Replaced `multi-variate` with `multivariate`
* Renamed `weightedVar` to `weightMVC`
* Updated citation information
* Updated and cleaned up package `DESCRIPTION`
* Updated and cleaned up `README`

# HiClimR 2.0.0

* Fixed NOTE: Registering native routines
* `fastCor`: Removed zero-variance data
* `fastCor`: Introduced `optBLAS`
* `fastCor`: Code cleanup
* Reformatted R source code
* Updated and fixed the examples
* Updated CRU TS dataset citation
* Updated `README` and all URLs

# HiClimR 1.2.3

* Fixed `geogMask` confusing country codes/names
* Fixed `geogMask` filtering `InDispute` areas
* Corrected data construction in the user manual
   * `x` should be created using `as.vector(t(x0))`
   * `x0` is the `n by m` original data matrix
   * `n = length(unique(lon))` and `m = length(unique(lat))`
* `coarseR` now returns the original row numbers
* Minor `README` corrections and updates

# HiClimR 1.2.2

* Changes for `Undefined global functions`
* Checking geographic masking output
* Minor `README` corrections and updates

# HiClimR 1.2.1

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

# HiClimR 1.2.0

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
* Backward compatibility with previous versions
* The user manual is updated and revised

# HiClimR 1.1.6

* Setting minimum `k = 2`, for objective tree cutting
   * this addresses an issue caused by undefined `k = NULL` in `validClimR` function
   * when all inter-cluster correlations are significant at the user-specified significance level
* Code reformatting using [`formatR`](https://cran.r-project.org/package=formatR)
* Package description and URLs have been revised
* Source code is now maintained on GitHub by authors

# HiClimR 1.1.5

* Updating description, URL, and citation info

# HiClimR 1.1.4

* Addresses an issue for zero-length mask vector: `Error in -mask : invalid argument to unary operator`
   * this error was introduced in v1.1.2+ after fixing the data-mean bug

# HiClimR 1.1.3

* The user manual is revised
* `lonSkip` and `latSkip` renamed to `lonStep` and `latStep`, respectively
* Minor bug fixes

# HiClimR 1.1.2

* A bug has been fixed where data mean is added to centered data if `standardize = FALSE`
   * objective tree cut and `data` component are now corrected 
     * to match input parameters especially when clustering of raw data
     * centered data was used in previous versions

# HiClimR 1.1.1

* Minor bug fixes and memory optimizations especially for the geographic masking function `geogMask`
* The limit for data size has been removed (use with caution)
* A logical parameter `InDispute` is added to `geogMask` function to optionally consider areas in dispute for geographic masking by country

# HiClimR 1.1.0

* Code cleanup and bug fixes
* An issue with `fastCor` function that degrades its performance on 32-bit machines has been fixed
   * A significant performance improvement can only be achieved when building R on 64-bit machines with an optimized `BLAS` library, such as `ATLAS`, `OpenBLAS`, or the commercial `Intel MKL`
* The citation info has been updated to reflect the current status of the technical paper

# HiClimR 1.0.9

* Minor changes and fixes for CRAN
* For memory considerations,
   * smaller test case with 1 degree resolution instead of 0.5 degree
   * the resolution option (`res` parameter) in geographic masking is removed
   * Mask data is only available in 0.1 degree (~10 km) resolution
* `LazyLoad` and `LazyData` are enabled in the description file
* The `worldMask` and `TestCase` data are converted to lists to avoid conflicts of variable names (`lon`, `lat`, `info`, and `mask`) with lazy loading

# HiClimR 1.0.8

* Code cleanup and bug fixes
* Region maps are unified for both gridded and ungridded data

# HiClimR 1.0.7

* Hybrid hierarchical clustering feature that utilizes the pros of the available methods
   * especially the better overall homogeneity in Ward's method and the separation and objective tree cut of the regional linkage method.
   * The logical parameter `hybrid` is added to enable a second clustering step
     * using `regional` linkage for reconstructing the upper part of the tree at a cut
     * defined by `kH` (number of clusters to restart with using the `regional` linkage method)
     * If `kH = NULL`, the tree will be reconstructed for the upper part with the first merging cost larger than the mean merging cost for the entire tree
       * merging cost is the loss of overall homogeneity at each merging step
* If hybrid clustering is requested, the updated upper-part of the tree will be used for cluster validation.

# HiClimR 1.0.6

* Code cleanup and bug fixes

# HiClimR 1.0.5

* Code cleanup and bug fixes
* Adds support to generate region maps for ungridded data

# HiClimR 1.0.4

* Code cleanup and bug fixes
* The `coarseR` function is  called inside the core `HiClimR` function
* Adds `coords` component to the output tree for the longitude and latitude coordinates
   * they may be changed by coarsening
* `validClimR` function does not require `lon` and `lat` arguments
   * they are now available in the output tree (`coords` component)

# HiClimR 1.0.3

* Code cleanup and bug fixes
* One main/wrapper function `HiClimR` internally calls all other functions
* Unified component names for all functions
* Objective tree cut is supported only for the `regional` linkage method
   * Otherwise, the number of clusters `k` should be specified
* The new clustering method has been renamed from `HiClimR` to `regional` linkage method

# HiClimR 1.0.2

* Code cleanup and bug fixes.
* adds a new feature that to return the preprocessed data used for clustering, by a logical argument `retData`.
   * the data will be returned in a component`data` of the output tree
   * this can be used to utilize `HiCLimR` preprocessing options for further analysis
* Ordered regions vector for the selected number of clusters are now returned in the `region` component
     * length equals the number of spatial elements `N`

# HiClimR 1.0.1

* Code cleanup and bug fixes
* Adds a new feature in `validCLimR` that enables users to exclude very small clusters from validation indices `interCor`, `intraCor`, `diffCor`, and `statSum`, by setting a value for the minimum cluster size (`minSize > 1`)
   * the excluded clusters can be identified from the output of `validClimR` in `clustFlag` component, which takes a value of `1` for valid clusters or `0` for excluded clusters
   * in `HiClimR` (currently, `regional` linkage) method, noisy spatial elements (or stations) are isolated in very small-size clusters or individuals since they do not correlate well with any other elements
   * this should be followed by a quality control step
* Adds `coarseR` function for coarsening spatial resolution of the input matrix `x`

# HiClimR 1.0.0

* Initial version of `HiClimR` package that modifies `hclust` function in `stats` library
* Adds a new clustering method to the set of available methods
* The new method is explained in the context of a spatiotemporal problem, in which `N` spatial elements (e.g., stations) are divided into `k` regions, given that each element has observations (or timeseries) of length `M`
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
