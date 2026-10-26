# Parses `basic_table_args` object into the `basic_table` expression

A function to parse expression from the `basic_table_args` object.

## Usage

``` r
parse_basic_table_args(basic_table_args = teal.widgets::basic_table_args())
```

## Arguments

- basic_table_args:

  (`basic_table_args`)\
  This argument could be a result of the
  [`resolve_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_basic_table_args.md).

## Value

(`language`) the
[`rtables::basic_table()`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
filled with additional arguments.

## Examples

``` r
parse_basic_table_args(
  resolve_basic_table_args(
    user_table = basic_table_args(title = "TITLE"),
    user_default = basic_table_args(title = "DEFAULT_TITLE", subtitles = "SUBTITLE")
  )
)
#> rtables::basic_table(title = "TITLE", subtitles = "SUBTITLE")
```
