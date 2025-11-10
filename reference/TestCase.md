# Test Data for Functionality Demonstration of `HiClimR` Package

This data is a subset of University of East Anglia Climatic Research
Unit (CRU) TS (timeseries) precipitation dataset version 3.2.

## Usage

``` r
data(TestCase)
```

## Format

`TestCase` is a list of three components: `x`, `lon`, and `lat`. `x` is
an (`6400` rows by `41` columns) matrix as required for
[`HiClimR`](https://hsbadr.github.io/HiClimR/reference/HiClimR.md)
function. The rows represent spatial points (or stations), while the
columns represent observations (temporal points or years). `lon` and
`lat` are vectors of length `80` for unique longitudes and latitudes
coordinates, where `80 * 80 = 6400` for this gridded data.

## Details

CRU TS 3.21 data (1901-2012) is monthly gridded precipitation with `0.5`
degree resolution. This test data is a subset with 1 degree resolution
for African precipitation in January, 1949-1989.

## Source

Climatic Research Unit (CRU) time-series datasets of variations in
climate with variations in other phenomena.

## References

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015): A Tool for
Hierarchical Climate Regionalization, *Earth Science Informatics*,
**8**(4), 949-958,
[doi:10.1007/s12145-015-0221-7](https://doi.org/10.1007/s12145-015-0221-7)
.

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014): Hierarchical
Climate Regionalization, *Comprehensive R Archive Network (CRAN)*,
<https://cran.r-project.org/package=HiClimR>.

Harris, I., Jones, P. D., Osborn, T. J., and Lister, D. H. (2014):
Updated high-resolution grids of monthly climatic observations - the CRU
TS3.10 Dataset, *International journal of climatology*, **34**, 623-642,
[doi:10.1002/joc.3711](https://doi.org/10.1002/joc.3711) .

## Examples

``` r
require(HiClimR)

x <- TestCase$x
dim(x)
#> [1] 6400   41
colnames(x)
#>  [1] "1949" "1950" "1951" "1952" "1953" "1954" "1955" "1956" "1957" "1958"
#> [11] "1959" "1960" "1961" "1962" "1963" "1964" "1965" "1966" "1967" "1968"
#> [21] "1969" "1970" "1971" "1972" "1973" "1974" "1975" "1976" "1977" "1978"
#> [31] "1979" "1980" "1981" "1982" "1983" "1984" "1985" "1986" "1987" "1988"
#> [41] "1989"
```
