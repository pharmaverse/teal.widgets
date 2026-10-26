# Parse `ggplot2_args` object into the `ggplot2` expression

A function to parse expression from the `ggplot2_args` object.

## Usage

``` r
parse_ggplot2_args(
  ggplot2_args = teal.widgets::ggplot2_args(),
  ggtheme = c("default", "gray", "bw", "linedraw", "light", "dark", "minimal", "classic",
    "void", "test")
)
```

## Arguments

- ggplot2_args:

  (`ggplot2_args`)\
  This argument could be a result of the
  [`resolve_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_ggplot2_args.md).

- ggtheme:

  (`character(1)`)\
  name of the `ggplot2` theme to be applied, e.g. `"dark"`.

## Value

(`list`) of up to three elements of class `languange`: `"labs"`,
`"ggtheme"` and `"theme"`.

## Examples

``` r
parse_ggplot2_args(
  resolve_ggplot2_args(ggplot2_args(
    labs = list(title = "TITLE"),
    theme = list(title = ggplot2::element_text(size = 20))
  ))
)
#> $labs
#> ggplot2::labs(title = "TITLE")
#> 
#> $theme
#> ggplot2::theme(title = <object>)
#> 

parse_ggplot2_args(
  resolve_ggplot2_args(
    ggplot2_args(
      labs = list(title = "TITLE"),
      theme = list(title = ggplot2::element_text(size = 20))
    )
  ),
  ggtheme = "gray"
)
#> $labs
#> ggplot2::labs(title = "TITLE")
#> 
#> $ggtheme
#> ggplot2::theme_gray()
#> 
#> $theme
#> ggplot2::theme(title = <object>)
#> 
```
