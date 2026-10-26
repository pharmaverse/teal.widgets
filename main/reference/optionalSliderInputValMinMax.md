# Optional Slider Input with minimal and maximal values

The
[`optionalSliderInput()`](https://pharmaverse.github.io/teal.widgets/reference/optionalSliderInput.md)
function needs three arguments to determine whether to hide the
`sliderInput` widget or not. For `teal` modules we specify an optional
slider input with one argument here called `value_min_max`.

## Usage

``` r
optionalSliderInputValMinMax(
  inputId,
  label,
  value_min_max,
  label_help = NULL,
  ...
)
```

## Arguments

- inputId:

  The `input` slot that will be used to access the value.

- label:

  Display label for the control, or `NULL` for no label.

- value_min_max:

  (`numeric(1)` or `numeric(3)`)\
  If of length 1 then the value gets set to that number and the
  `sliderInput` will be hidden. Otherwise, if it is of length three the
  three elements will map to `value`, `min` and `max` of the
  [`optionalSliderInput()`](https://pharmaverse.github.io/teal.widgets/reference/optionalSliderInput.md)
  function.

- label_help:

  (`shiny.tag`) optional\
  object of class `shiny.tag`, e.g. an object returned by
  [`shiny::helpText()`](https://rdrr.io/pkg/shiny/man/helpText.html)

- ...:

  optional arguments to `sliderInput`

## Value

(`shiny.tag`) HTML tag with range `sliderInput` widget.

## Details

For `teal` modules we parameterize an `optionalSliderInput` with one
argument `value_min_max`

## Examples

``` r

ui <- bslib::page_fluid(
  shinyjs::useShinyjs(),
  optionalSliderInputValMinMax("a1", "b1", 1), # Hidden
  optionalSliderInputValMinMax("a2", "b2", c(3, 1, 5)) # Shown
)
if (interactive()) {
  shiny::shinyApp(ui, function(input, output) {})
}
```
