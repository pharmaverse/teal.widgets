# Builds a `basic_table_args` object

This function has to be used to build an input for a `basic_table_args`
argument. The `basic_table_args` argument should be a part of every
module which contains any `rtables` object. Arguments are validated to
match their `rtables` equivalents.

For more details see the vignette:
[`vignette("custom-basic-table-arguments", package = "teal.widgets")`](https://pharmaverse.github.io/teal.widgets/articles/custom-basic-table-arguments.md).

## Usage

``` r
basic_table_args(...)
```

## Arguments

- ...:

  arguments compatible with
  [`rtables::basic_table()`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html).

## Value

(`basic_table_args`) object.

## See also

- [`resolve_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_basic_table_args.md)
  to resolve multiple objects into one using pre-defined priorities.

- [`parse_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_basic_table_args.md)
  to parse resolved list into list of calls.

## Examples

``` r
basic_table_args(subtitles = "SUBTITLE")
#> $subtitles
#> [1] "SUBTITLE"
#> 
#> attr(,"class")
#> [1] "basic_table_args"
```
