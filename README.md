# HiClimR
###A tool for **Hi**erarchical **Clim**ate **R**egionalization
[`HiClimR`](http://cran.r-project.org/package=HiClimR) is a tool for **Hi**erarchical **Clim**ate **R**egionalization applicable to any correlation-based clustering. It adds several features and a new clustering method (called, `regional` linkage) to hierarchical clustering in R (`hclust` function in `stats` library) including...

* regridding,
* coarsening spatial resolution,
* geographic masking,
* data filtering by thresholds,
* data preprocessing (detrending, standardization, and PCA),
* faster correlation function,
* hybrid hierarchical clustering, and
* cluster validation.

## Design and Implementation
[Badr et. al (2015)](http://blaustein.eps.jhu.edu/~hbadr1/#Publications) describes the regionalization algorithms and data processing tools included in the package and presents a demonstration application in which the package is used to regionalize Africa on the basis of interannual precipitation variability. The figure below shows a detailed flowchart for the package. `Cyan` blocks represent helper functions, `green` is input data or parameters, `yellow` indicates agglomeration Fortran code, and `purple` shows graphics options.

![blank-container](http://blaustein.eps.jhu.edu/~hbadr1/images/HiClimR.png)
*[`HiClimR`](http://cran.r-project.org/package=HiClimR) is applicable to any correlation-based clustering.*

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


**Test Data:** [HiClimR-test.RData](http://blaustein.eps.jhu.edu/~hbadr1/files/HiClimR-test.RData)

**User Manual:** [HiClimR-manual.pdf](http://blaustein.eps.jhu.edu/~hbadr1/files/HiClimR-manual.pdf)

**Source Code:** [https://github.com/hsbadr/HiClimR](https://github.com/hsbadr/HiClimR)
