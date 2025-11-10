# Coarsening spatial resolution for gridded data

`coarseR` is a helper function that helps coarsening spatial resolution
of the input matrix for the
[`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md)
function.

## Usage

``` r
coarseR(x = x, lon = lon, lat = lat, lonStep = 1, latStep = 1, verbose = TRUE)
```

## Arguments

- x:

  an (`N` rows by `M` columns) matrix of 'double' values: `N` objects
  (spatial points or stations) to be clustered by `M` observations
  (temporal points or years). For gridded data, the `N` objects should
  be created from the original matrix `x0` using `as.vector(t(x0))`,
  where `x0` is an (`n` rows by `m` columns) matrix,
  `n = length(unique(lon))` and `m = length(unique(lat))`.

- lon:

  a vector of longitudes with length `N`. For gridded data, the length
  may have the value (`n`) provided that `n * m = N` where
  `n = length(unique(lon))` and `m = length(unique(lat))`.

- lat:

  a vector of latitudes with length `N` or `m`. See `lon`.

- lonStep:

  an integer greater than or equal to `1` for longitude step to coarsen
  gridded data in the longitudinal direction. If `lonStep = 1`, gridded
  data will not be coarsened in the longitudinal direction (the
  default). If `lonStep = 2`, every other grid in longitudinal direction
  will be retained.

- latStep:

  an integer greater than or equal to `1` for latitude step to coarsen
  gridded data in the latitudinal direction. If `latStep = 1`, gridded
  data will not be coarsened in the latitudinal direction (the default).
  If `latStep = 2`, every other grid in latitudinal direction will be
  retained. `lonStep` and `latStep` are independent so that user can
  optionally apply different coarsening level to each dimension.

- verbose:

  logical to print processing information if `verbose = TRUE`.

## Value

A list with the following components:

- lon:

  longitude mesh vector for the coarsened data.

- lat:

  latitude mesh vector for the coarsened data.

- rownum:

  original row numbers for the coarsened data.

- x:

  coarsened data of the input data matrix `x`.

## Details

For high-resolution data, the computational and memory requirements may
not be met on old machines. This function enables the user to use
coarser data in any spatial dimension:longitude, latitude, or both. It
is available for testing or running `HiClimR` package on old computers
or machines with small memory resources. The rows of output matrix (`x`
component) will be also named by longitude and latitude coordinates. If
`lonStep = 1` and `latStep = 1`, `coarseR` function will just rename
rows of matrix `x`.

## References

Hamada S. Badr, Zaitchik, B. F., and Dezfuli, A. K. (2015): A Tool for
Hierarchical Climate Regionalization, *Earth Science Informatics*,
**8**(4), 949-958,
[doi:10.1007/s12145-015-0221-7](https://doi.org/10.1007/s12145-015-0221-7)
.

Hamada S. Badr, Zaitchik, B. F., and Dezfuli, A. K. (2014): Hierarchical
Climate Regionalization, *Comprehensive R Archive Network (CRAN)*,
<https://cran.r-project.org/package=HiClimR>.

## Author

Hamada S. Badr \<badr@jhu.edu\>, Benjamin F. Zaitchik
\<zaitchik@jhu.edu\>, and Amin K. Dezfuli \<amin.dezfuli@nasa.gov\>.

## See also

[`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md),
[`HiClimR2nc`](https://hsbadr.github.io/HiClimR/reference/HiClimR2nc.md),
[`validClimR`](https://hsbadr.github.io/HiClimR/reference/validClimR.md),
[`geogMask`](https://hsbadr.github.io/HiClimR/reference/geogMask.md),
`coarseR`,
[`fastCor`](https://hsbadr.github.io/HiClimR/reference/fastCor.md),
[`grid2D`](https://hsbadr.github.io/HiClimR/reference/grid2D.md) and
[`minSigCor`](https://hsbadr.github.io/HiClimR/reference/minSigCor.md).

## Examples

``` r
require(HiClimR)

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
```
