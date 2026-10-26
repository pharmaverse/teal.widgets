# Resolving and reducing multiple `ggplot2_args` objects

Resolving and reducing multiple `ggplot2_args` objects. This function is
intended to utilize user provided settings, defaults provided by the
module creator and also `teal` option. See `Details`, below, to
understand the logic.

## Usage

``` r
resolve_ggplot2_args(
  user_plot = ggplot2_args(),
  user_default = ggplot2_args(),
  module_plot = ggplot2_args(),
  app_default = getOption("teal.ggplot2_args", ggplot2_args())
)
```

## Arguments

- user_plot:

  (`ggplot2_args`)\
  end user setup for theme and labs in the specific plot. Created with
  the
  [`ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)
  function. The `NULL` value is supported.

- user_default:

  (`ggplot2_args`)\
  end user setup for module default theme and labs. Created with the
  [`ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)
  function. The `NULL` value is supported.

- module_plot:

  (`ggplot2_args`)\
  module creator setup for theme and labs in the specific plot. Created
  with the
  [`ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)
  function. The `NULL` value is supported.

- app_default:

  (`ggplot2_args`)\
  Application level setting. Can be `NULL`.

## Value

`ggplot2_args` object.

## Details

The function picks the first non `NULL` value for each argument,
checking in the following order:

1.  `ggplot2_args` argument provided by the end user. Per plot
    (`user_plot`) and then default (`user_default`) setup.

2.  `app_default` global R variable, `teal.ggplot2_args`.

3.  `module_plot` which is a module creator setup.

## See also

[`parse_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_ggplot2_args.md)
to parse resolved list into list of calls.

## Examples

``` r
resolve_ggplot2_args(
  user_plot = ggplot2_args(
    labs = list(title = "TITLE"),
    theme = list(title = ggplot2::element_text(size = 20))
  ),
  user_default = ggplot2_args(
    labs = list(x = "XLAB")
  )
)
#> $labs
#> $labs$title
#> [1] "TITLE"
#> 
#> $labs$x
#> [1] "XLAB"
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
