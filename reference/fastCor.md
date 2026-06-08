# Fast correlation for large matrices

`fastCor` is a helper function that compute Pearson correlation matrix
for [`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md)
and
[`validClimR`](https://hsbadr.github.io/HiClimR/reference/validClimR.md)
functions. It is similar to [`cor`](https://rdrr.io/r/stats/cor.html)
function in R but uses a faster implementation on 64-bit machines (an
optimized `BLAS` library is highly recommended). `fastCor` also uses a
memory-efficient algorithm that allows for splitting the data matrix and
only compute the upper-triangular part of the correlation matrix. It can
be used to compute correlation matrix for the columns of any data
matrix.

## Usage

``` r
fastCor(xt, nSplit = 1, upperTri = FALSE, optBLAS = FALSE, verbose = TRUE)
```

## Arguments

- xt:

  an (`M` rows by `N` columns) matrix of 'double' values: `N` objects
  (spatial points or stations) to be clustered by `M` observations
  (temporal points or years). It is the transpose of the input matrix
  `x` required for
  [`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md) and
  [`validClimR`](https://hsbadr.github.io/HiClimR/reference/validClimR.md)
  functions.

- nSplit:

  integer number greater than or equal to one, to split the data matrix
  into `nSplit` splits of the total number of columns `ncol(xt)`. If
  `nSplit = 1`, the default method will be used to compute correlation
  matrix for the full data matrix (no splits). If `nSplit > 1`, the
  correlation matrix (or the upper-triangular part if `upperTri = TRUE`)
  will be allocated and filled with the computed correlation sub-matrix
  for each split. the first `n-1` splits have equal size while the last
  split may include any remaining columns. This is used with
  `upperTri = TRUE` to compute only the upper-triangular part of the
  correlation matrix. The maximum number of splits
  `nSplitMax = floor(N / 2)` makes splits with 2 columns; if
  `nSplit > nSplitMax`, `nSplitMax` will be used. Very large number of
  splits `nSplit` makes computation slower but it could handle big data
  or if the available memory is not enough to allocate the correlation
  matrix, which helps in solving the “Error: cannot allocate vector of
  size...” memory limitation problem. It is recommended to start with a
  small number of splits. If the data is very large compared to the
  physical memory, it is highly recommended to use a 64-Bit machine with
  enough memory resources and/or use coarsening feature for gridded data
  by setting `lonStep > 1` and `latStep > 1`.

- upperTri:

  logical to compute only the upper-triangular half of the correlation
  matrix if `upperTri = TRUE` and `nSplit > 1`., which includes all
  required info since the correlation/dissimilarity matrix is symmetric.
  This almost halves memory use, which can be very important for big
  data.

- optBLAS:

  logical to use optimized BLAS library if installed and
  `optBLAS = TRUE` only on 64-bit machines.

- verbose:

  logical to print processing information if `verbose = TRUE`.

## Value

An (`N` rows by `N` columns) correlation matrix.

## Details

The `fastCor` function computes the correlation matrix by calling the
cross product function in the Basic Linear Algebra Subroutines (BLAS)
library used by R. A significant performance improvement can be achieved
when building R on 64-bit machines with an optimized BLAS library, such
as *ATLAS*, *OpenBLAS*, or the commercial *Intel MKL*. For big data, the
memory required to allocate the square matrix of correlations may exceed
the total amount of physical memory available resulting in “Error:
cannot allocate vector of size...”. `fastCor` allows for splitting the
data matrix into `nSplit` splits and only computes the upper-triangular
part of the correlation matrix with `upperTri = TRUE`. This almost
halves memory use, which can be very important for big data. If
`nSplit > 1`, the correlation matrix (or the upper-triangular part if
`upperTri = TRUE`) will be allocated and filled with computed
correlation sub-matrix for each split. the first `n-1` splits have equal
size while the last split may include any remaining columns.

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
`fastCor`,
[`grid2D`](https://hsbadr.github.io/HiClimR/reference/grid2D.md) and
[`minSigCor`](https://hsbadr.github.io/HiClimR/reference/minSigCor.md).

## Examples

``` r
require(HiClimR)

## Load test case data
x <- TestCase$x

## Use fastCor function to compute the correlation matrix
t0 <- proc.time() ; xcor <- fastCor(t(x)) ; proc.time() - t0
#> ---> Checking zero-variance data...
#> --->   Total number of variables:  6400
#> --->   WARNING: 3951 variables found with zero variance
#>    user  system elapsed 
#>   0.670   0.035   0.706 
## compare with cor function
t0 <- proc.time() ; xcor0 <- cor(t(x)) ; proc.time() - t0
#> Warning: the standard deviation is zero
#>    user  system elapsed 
#>   0.583   0.022   0.605 

if (FALSE) { # \dontrun{

## Split the data into 10 splits and return upper-triangular half only
xcor10 <- fastCor(t(x), nSplit = 10, upperTri = TRUE)

} # }
```
