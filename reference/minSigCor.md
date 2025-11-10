# Minimum significant correlation for a sample size

`minSigCor` is a helper function that estimates the minimum significant
correlation for a sample size `n` at a confidence level defined by the
argument `alpha`.

## Usage

``` r
minSigCor(n = 41, alpha = 0.05, r = seq(0, 1, by = 1e-6))
```

## Arguments

- n:

  sample size or the length of a timeseries vector.

- alpha:

  confidence level: the default is `alpha = 0.05` for 95% confidence
  level.

- r:

  a vector of values from `0` to `1` to search for the minimum
  significant correlation for the user-specified sample size `n` at
  confidence level `alpha`. This should be a subset of the valid
  positive correlation range `0-1`. The default is to search for the
  minimum significant correlation in the complete range `0-1` with a
  very fine step of `1e-6`. For faster computations, the user may set a
  shorter range with larger step (e.g., seq(0.1, 0.5, by=1e-3)).

## Value

A positive value between `0` and `1` for the estimated the minimum
significant correlation.

## Details

`minSigCor` function estimates the minimum significant correlation for a
sample size (number of observations or temporal points in a timeseries)
at a certain confidence level selected by the argument `alpha` and an
optional search range `r`. It is called by
[`validClimR`](https://hsbadr.github.io/HiClimR/reference/validClimR.md)
function objective tree cut based on the specified confidence level.

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
[`grid2D`](https://hsbadr.github.io/HiClimR/reference/grid2D.md) and
`minSigCor`.

## Examples

``` r
require(HiClimR)

## Find minimum significant correlation at 95% confidence level
rMin <- minSigCor(n = 41, alpha = 0.05, r = seq(0, 1, by = 1e-06))
```
