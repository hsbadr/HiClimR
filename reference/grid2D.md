# Generate longitude and latitude grid matrices

`grid2D` is a helper function that generates longitude and latitude
rectangular mesh from short longitude and latitude vectors in gridded
data.

## Usage

``` r
grid2D(lon = lon, lat = lat)
```

## Arguments

- lon:

  a vector of longitudes with length `N`. Longitudes takes values from
  `-180` to `180` (not `0` to `360`). For gridded data, the length may
  have the value (`n`) provided that `n * m = N` where
  `n = length(unique(lon))` and `m = length(unique(lat))`.

- lat:

  a vector of latitudes with length `N` or `m`. See `lon`.

## Value

A list with the following components:

- lon:

  an (`n` rows by `m` columns) matrix of 'double' values for longitude
  mesh grid, or a vector with length `n * m`.

- lat:

  an (`n` rows by `m` columns) matrix of 'double' values for latitude
  mesh grid, or a vector with length `n * m`.

## Details

`grid2D` function convert the long latitude and longitude vectors to a
rectangular two-dimensional grid for visualization and geographic
masking purposes for gridded data in `HiClimR` package.

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
[`HiClimR2nc`](https://hsbadr.github.io/HiClimR/reference/HiClimR2nc.md),
[`validClimR`](https://hsbadr.github.io/HiClimR/reference/validClimR.md),
[`geogMask`](https://hsbadr.github.io/HiClimR/reference/geogMask.md),
[`coarseR`](https://hsbadr.github.io/HiClimR/reference/coarseR.md),
[`fastCor`](https://hsbadr.github.io/HiClimR/reference/fastCor.md),
`grid2D` and
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
```
