# Creates `ggplot2_args` object

Constructor of `ggplot2_args` class of objects. The `ggplot2_args`
argument should be a part of every module which contains any `ggplot2`
graphics. The function arguments are validated to match their `ggplot2`
equivalents.

For more details see the vignette:
[`vignette("custom-ggplot2-arguments", package = "teal.widgets")`](https://pharmaverse.github.io/teal.widgets/articles/custom-ggplot2-arguments.md).

## Usage

``` r
ggplot2_args(labs = list(), theme = list())
```

## Arguments

- labs:

  (named `list`)\
  where all fields have to match
  [`ggplot2::labs()`](https://ggplot2.tidyverse.org/reference/labs.html)
  arguments.

- theme:

  (named `list`)\
  where all fields have to match
  [`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
  arguments.

## Value

(`ggplot2_args`) object.

## See also

- [`resolve_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_ggplot2_args.md)
  to resolve multiple objects into one using pre-defined priorities.

- [`parse_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_ggplot2_args.md)
  to parse resolved list into list of calls.

## Examples

``` r
ggplot2_args(
  labs = list(title = "TITLE"),
  theme = list(title = ggplot2::element_text(size = 20))
)
#> $labs
#> $labs$title
#> [1] "TITLE"
#> 
#> 
#> $theme
#> $theme$title
#> <ggplot2::element_text>
#>  @ family       : NULL
#>  @ face         : NULL
#>  @ italic       : chr NA
#>  @ fontweight   : num NA
#>  @ fontwidth    : num NA
#>  @ colour       : NULL
#>  @ size         : num 20
#>  @ hjust        : NULL
#>  @ vjust        : NULL
#>  @ angle        : NULL
#>  @ lineheight   : NULL
#>  @ margin       : NULL
#>  @ debug        : NULL
#>  @ inherit.blank: logi FALSE
#> 
#> 
#> attr(,"class")
#> [1] "ggplot2_args"
```
