
# ratewidget

<!-- badges: start -->
<!-- badges: end -->

A `ratewidget` displays a single statistic derived from a linked table, where the numerator and denominator columns are specific. This is best used with the `crosstalk` package, to allow dynamic filtering of the underlying data.

An example of a `ratewidget` is available on this page: <https://pli9.github.io/ratewidget/>


## Installation

You can install the development version of ratewidget from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("pli9/ratewidget")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ratewidget)
## basic example code
ratewidget(mtcars, numerator = "hp", denominator = "wt", multiplier=0.001, digits=3)
```

