# HiClimR
###A tool for **Hi**erarchical **Clim**ate **R**egionalization
`HiClimR` is a tool for **Hi**erarchical **Clim**ate **R**egionalization applicable to any correlation-based clustering. It adds several features and a new clustering method (called, `regional` linkage) to hierarchical clustering in R (`hclust` function in `stats` library) including...

* regridding,
* coarsening spatial resolution,
* geographic masking,
* data filtering by thresholds,
* data preprocessing (detrending, standardization, and PCA),
* faster correlation function,
* hybrid hierarchical clustering, and
* cluster validation.
