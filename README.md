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

**Package Source:** [HiClimR_1.1.6.tar.gz](http://blaustein.eps.jhu.edu/~hbadr1/files/HiClimR_1.1.6.tar.gz)
**User Manual:** [HiClimR-manual.pdf](http://blaustein.eps.jhu.edu/~hbadr1/files/HiClimR-manual.pdf)
**Test Data:** [HiClimR-test.RData](http://blaustein.eps.jhu.edu/~hbadr1/files/HiClimR-test.RData)
