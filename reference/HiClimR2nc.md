# Export NetCDF-4 file for Hierarchical Climate Regionalization

`HiClimR2nc` is a helper function that exports region map and mean
timeseries into NetCDF-4 file, using the `ncdf4` package.

## Usage

``` r
HiClimR2nc(y = NULL, ncfile = "HiClimR.nc", timeunit = "", dataunit = "")
```

## Arguments

- y:

  a dendrogram tree produced by
  [`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md).

- ncfile:

  Path and name of the NetCDF-4 file to be created.

- timeunit:

  an optional character string for the time units, A zero-length string
  (default: `timeunit=""`) removes units attribute.

- dataunit:

  an optional character string for the data units, A zero-length string
  (default: `timeunit=""`) removes units attribute.

## Value

An object of class `ncdf4`, which has the fields described in
[`nc_open`](https://rdrr.io/pkg/ncdf4/man/nc_open.html).

## Details

`HiClimR2nc` function exports region map and mean timeseries from
`HiClimR` tree into NetCDF-4 file, using the `ncdf4` package. The
NetCDF-4 file will be open to add other variables, if needed. It is
important to close the created file using
[`nc_close`](https://rdrr.io/pkg/ncdf4/man/nc_close.html), which flushes
any unwritten data to disk.

## References

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015): A Tool for
Hierarchical Climate Regionalization, *Earth Science Informatics*,
**8**(4), 949-958,
[doi:10.1007/s12145-015-0221-7](https://doi.org/10.1007/s12145-015-0221-7)
.

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014): Hierarchical
Climate Regionalization, *Comprehensive R Archive Network (CRAN)*,
<https://cran.r-project.org/package=HiClimR>.

## Author

Hamada S. Badr \<badr@jhu.edu\>, Benjamin F. Zaitchik
\<zaitchik@jhu.edu\>, and Amin K. Dezfuli \<amin.dezfuli@nasa.gov\>.

## See also

[`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md),
`HiClimR2nc`,
[`validClimR`](https://hsbadr.github.io/HiClimR/reference/validClimR.md),
[`geogMask`](https://hsbadr.github.io/HiClimR/reference/geogMask.md),
[`coarseR`](https://hsbadr.github.io/HiClimR/reference/coarseR.md),
[`fastCor`](https://hsbadr.github.io/HiClimR/reference/fastCor.md),
[`grid2D`](https://hsbadr.github.io/HiClimR/reference/grid2D.md) and
[`minSigCor`](https://hsbadr.github.io/HiClimR/reference/minSigCor.md).

## Examples

``` r
require(HiClimR)
require(ncdf4)
#> Loading required package: ncdf4

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
#> 
#> PROCESSING STARTED
#> 
#> Checking Multivariate Clustering (MVC)...
#> ---> x is a matrix
#> ---> single-variate clustering: 1 variable
#> Checking data...
#> ---> Checking dimensions...
#> ---> Checking row names...
#> ---> Checking column names...
#> Data filtering...
#> ---> Computing mean for each row...
#> ---> Checking rows with mean bellow meanThresh...
#> ---> 4678 rows found, mean ≤  10
#> ---> Computing variance for each row...
#> ---> Checking rows with near-zero-variance...
#> ---> 3951 rows found, variance ≤  0
#> Data preprocessing...
#> ---> Applying mask...
#> ---> Checking columns with missing values...
#> ---> Removing linear trend...
#> ---> Standardizing data...
#> Agglomerative Hierarchical Clustering...
#> ---> Computing correlation/dissimilarity matrix...
#> ---> Starting clustering process...
#> ---> Constructing dendrogram tree...
#> Calling cluster validation...
#> ---> Computing cluster means...
#> ---> Computing inter-cluster correlations...
#> ---> Computing intra-cluster correlations...
#> ---> Computing summary statistics...
#> Generating region map...
#> 
#> PROCESSING COMPLETED
#> 
#> Running Time:
#>    user  system elapsed 
#>   0.468   0.014   0.485 
#> Time difference of 0.4846995 secs

if (FALSE) { # \dontrun{

## Export region map and mean timeseries into NetCDF-4 file
y.nc <- HiClimR2nc(y=y, ncfile="HiClimR.nc", timeunit="years", dataunit="mm")
## The NetCDF-4 file is still open to add other variables or close it
nc_close(y.nc)

} # }
```
