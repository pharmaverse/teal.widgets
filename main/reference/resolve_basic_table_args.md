# Resolves and reduces multiple `basic_table_args` objects

Resolving and reducing multiple `basic_table_args` objects. This
function is intended to utilize user provided settings, defaults
provided by the module creator and also `teal` option. See `Details`,
below, to understand the logic.

## Usage

``` r
resolve_basic_table_args(
  user_table = basic_table_args(),
  user_default = basic_table_args(),
  module_table = basic_table_args(),
  app_default = getOption("teal.basic_table_args", basic_table_args())
)
```

## Arguments

- user_table:

  (`basic_table_args`)\
  end user setup for
  [`rtables::basic_table()`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
  of a specific table. Created with the
  [`basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)
  function. The `NULL` value is supported.

- user_default:

  (`basic_table_args`)\
  end user default setup for
  [`rtables::basic_table()`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
  of a specific table. Created with the
  [`basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)
  function. The `NULL` value is supported.

- module_table:

  (`ggplot2_args`)\
  module creator setup for
  [`rtables::basic_table()`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
  of a specific table. Created with the
  [`basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)
  function. The `NULL` value is supported.

- app_default:

  (`basic_table_args`)\
  Application level setting. Can be `NULL`.

## Value

`basic_table_args` object.

## Details

The function picks the first non `NULL` value for each argument,
checking in the following order:

1.  `basic_table_args` argument provided by the end user. Per table
    (`user_table`) and then default (`user_default`) setup.

2.  `app_default` global R variable, `teal.basic_table_args`.

3.  `module_table` which is a module creator setup.

## See also

[`parse_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_basic_table_args.md)
to parse resolved list into list of calls.

## Examples

``` r
resolve_basic_table_args(
  user_table = basic_table_args(title = "TITLE"),
  user_default = basic_table_args(title = "DEFAULT_TITLE", subtitles = "SUBTITLE")
)
#> $title
#> [1] "TITLE"
#> 
#> $subtitles
#> [1] "SUBTITLE"
#> 
#> attr(,"class")
#> [1] "basic_table_args"
```
