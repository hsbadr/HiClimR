# World Mask for Geographic Masking in HiClimR

This data is used for geographic masking by
[`geogMask`](https://hsbadr.github.io/HiClimR/reference/geogMask.md)
function in `HiClimR` package.

## Usage

``` r
data(WorldMask)
```

## Format

`WorldMask` is a list with two components: `info` and `mask`. `info` is
an (`284` rows by `10` columns) matrix. The rows are for areas or
countries while the columns are for codes required by
[`geogMask`](https://hsbadr.github.io/HiClimR/reference/geogMask.md).
`mask` is an (`3601` rows by `1801` columns) matrix with integer values
from `1` to `284` for the areas defined in `info`.

## Details

This data is used internally by
[`geogMask`](https://hsbadr.github.io/HiClimR/reference/geogMask.md)
function for geographic masking in `HiClimR` package. The user is
advised to refer to the function manual for more details. The world mask
is available in `0.1` degree (`10` km) resolution. The `info` data
provides information for continents, regions, and country codes).

## Source

The data are based on the Humanitarian Information Unit (HIU) Large
Scale International Boundaries (LSIB) dataset.

## References

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2015): A Tool for
Hierarchical Climate Regionalization, *Earth Science Informatics*,
**8**(4), 949-958,
[doi:10.1007/s12145-015-0221-7](https://doi.org/10.1007/s12145-015-0221-7)
.

Hamada S. Badr, Zaitchik, B. F. and Dezfuli, A. K. (2014): Hierarchical
Climate Regionalization, *Comprehensive R Archive Network (CRAN)*,
<https://cran.r-project.org/package=HiClimR>.

LSIB Data: <https://hiu.state.gov/data/>.

## Examples

``` r
require(HiClimR)

geogMask()
#> ---> Checking geographic masking options...
#> $continent
#> [1] "Africa"     "Americas"   "Antarctica" "Asia"       "Europe"    
#> [6] "Oceania"   
#> 
#> $region
#>  [1] "Antarctica"                "Australia and New Zealand"
#>  [3] "Caribbean"                 "Central America"          
#>  [5] "Central Asia"              "Eastern Africa"           
#>  [7] "Eastern Asia"              "Eastern Europe"           
#>  [9] "Melanesia"                 "Micronesia"               
#> [11] "Middle Africa"             "Northern Africa"          
#> [13] "Northern America "         "Northern Europe"          
#> [15] "Polynesia"                 "South America"            
#> [17] "South-Eastern Asia"        "Southern Africa"          
#> [19] "Southern Asia"             "Southern Europe"          
#> [21] "Western Africa"            "Western Asia"             
#> [23] "Western Europe"           
#> 
#> $country
#>   [1] "ABW" "AFG" "AGO" "AIA" "ALB" "AND" "ANT" "ARE" "ARG" "ARM" "ASM" "ATA"
#>  [13] "ATF" "ATG" "AUS" "AUT" "AZE" "BDI" "BEL" "BEN" "BFA" "BGD" "BGR" "BHR"
#>  [25] "BHS" "BIH" "BLM" "BLR" "BLZ" "BMU" "BOL" "BRA" "BRB" "BRN" "BTN" "BVT"
#>  [37] "BWA" "CAF" "CAN" "CCK" "CHE" "CHL" "CHN" "CIV" "CMR" "COD" "COG" "COK"
#>  [49] "COL" "COM" "CPV" "CRI" "CUB" "CUW" "CXR" "CYM" "CYP" "CZE" "DEU" "DJI"
#>  [61] "DMA" "DNK" "DOM" "DZA" "ECU" "EGY" "ERI" "ESH" "ESP" "EST" "ETH" "FIN"
#>  [73] "FJI" "FLK" "FRA" "FRO" "FSM" "GAB" "GBR" "GEO" "GGY" "GHA" "GIN" "GLP"
#>  [85] "GMB" "GNB" "GNQ" "GRC" "GRD" "GRL" "GTM" "GUF" "GUM" "GUY" "HKG" "HMD"
#>  [97] "HND" "HRV" "HTI" "HUN" "IDN" "IMN" "IND" "IOT" "IRL" "IRN" "IRQ" "ISL"
#> [109] "ISR" "ITA" "JAM" "JEY" "JOR" "JPN" "KAZ" "KEN" "KGZ" "KHM" "KIR" "KNA"
#> [121] "KOR" "KWT" "LAO" "LBN" "LBR" "LBY" "LCA" "LIE" "LKA" "LSO" "LTU" "LUX"
#> [133] "LVA" "MAC" "MAF" "MAR" "MCO" "MDA" "MDG" "MDV" "MEX" "MHL" "MKD" "MLI"
#> [145] "MLT" "MMR" "MNE" "MNG" "MNP" "MOZ" "MRT" "MSR" "MTQ" "MUS" "MWI" "MYS"
#> [157] "MYT" "NAM" "NCL" "NER" "NFK" "NGA" "NIC" "NIU" "NLD" "NOR" "NPL" "NRU"
#> [169] "NZL" "OMN" "PAK" "PAN" "PCN" "PER" "PHL" "PLW" "PNG" "POL" "PRI" "PRK"
#> [181] "PRT" "PRY" "PSE" "PYF" "QAT" "REU" "ROU" "RUS" "RWA" "SAU" "SDN" "SEN"
#> [193] "SGP" "SGS" "SHN" "SJM" "SLB" "SLE" "SLV" "SMR" "SOM" "SPM" "SSD" "STP"
#> [205] "SUR" "SVK" "SVN" "SWE" "SWZ" "SXM" "SYC" "SYR" "TCA" "TCD" "TGO" "THA"
#> [217] "TJK" "TKL" "TKM" "TLS" "TON" "TTO" "TUN" "TUR" "TUV" "TWN" "TZA" "UGA"
#> [229] "UKR" "UMI" "URY" "USA" "UZB" "VAT" "VCT" "VEN" "VGB" "VIR" "VNM" "VUT"
#> [241] "WLF" "WSM" "YEM" "ZAF" "ZMB" "ZWE"
#> 
```
