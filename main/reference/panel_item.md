# Panel item widget

**\[deprecated\]**\
Designed to be grouped using
[`panel_group`](https://pharmaverse.github.io/teal.widgets/reference/panel_group.md)
element. Used to handle `shiny` inputs in the encoding panel.

## Usage

``` r
panel_item(title, ..., collapsed = TRUE, input_id = NULL)
```

## Arguments

- title:

  (`character`)\
  title of panel

- ...:

  content of panel

- collapsed:

  (`logical`) optional,\
  whether to initially collapse panel

- input_id:

  (`character`) optional\
  name of the panel item element. If supplied, this will register a
  shiny input variable that indicates whether the panel item is open or
  collapsed and is accessed with `input$input_id`.

## Value

(`shiny.tag`)

## Examples

``` r

library(shiny)
panel_item(
  title = "Display",
  collapsed = FALSE,
  checkboxGroupInput(
    "check",
    "Tables display",
    choices = LETTERS[1:3],
    selected = LETTERS[1]
  ),
  radioButtons(
    "radio",
    label = "Plot type",
    choices = letters[1:2],
    selected = letters[1]
  )
)
#> <div class="accordion-item" data-value="Display">
#>   <div class="accordion-header">
#>     <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#bslib-accordion-panel-8338" aria-expanded="false" aria-controls="bslib-accordion-panel-8338">
#>       <div class="accordion-icon"></div>
#>       <div class="accordion-title">Display</div>
#>     </button>
#>   </div>
#>   <div id="bslib-accordion-panel-8338" class="accordion-collapse collapse">
#>     <div class="accordion-body" open="TRUE">
#>       <div id="check" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="check-label">
#>         <label class="control-label" id="check-label" for="check">Tables display</label>
#>         <div class="shiny-options-group">
#>           <div class="checkbox">
#>             <label>
#>               <input type="checkbox" name="check" value="A" checked="checked"/>
#>               <span>A</span>
#>             </label>
#>           </div>
#>           <div class="checkbox">
#>             <label>
#>               <input type="checkbox" name="check" value="B"/>
#>               <span>B</span>
#>             </label>
#>           </div>
#>           <div class="checkbox">
#>             <label>
#>               <input type="checkbox" name="check" value="C"/>
#>               <span>C</span>
#>             </label>
#>           </div>
#>         </div>
#>       </div>
#>       <div id="radio" class="form-group shiny-input-radiogroup shiny-input-container" role="radiogroup" aria-labelledby="radio-label">
#>         <label class="control-label" id="radio-label" for="radio">Plot type</label>
#>         <div class="shiny-options-group">
#>           <div class="radio">
#>             <label>
#>               <input type="radio" name="radio" value="a" checked="checked"/>
#>               <span>a</span>
#>             </label>
#>           </div>
#>           <div class="radio">
#>             <label>
#>               <input type="radio" name="radio" value="b"/>
#>               <span>b</span>
#>             </label>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
