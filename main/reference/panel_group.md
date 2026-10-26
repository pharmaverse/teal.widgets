# Panel group widget

**\[deprecated\]**\
Designed to group
[`panel_item`](https://pharmaverse.github.io/teal.widgets/reference/panel_item.md)
elements. Used to handle `shiny` inputs in the encoding panel.

## Usage

``` r
panel_group(..., id = NULL)
```

## Arguments

- ...:

  (`shiny.tag`)\
  panels created by `panel_group()`

- id:

  optional, (`character`)\

## Value

(`shiny.tag`)

## Examples

``` r

library(shiny)
panel_group(
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
  ),
  panel_item(
    title = "Pre-processing",
    radioButtons(
      "filtering",
      "What to filter",
      choices = LETTERS[1:4],
      selected = LETTERS[1]
    ),
    radioButtons(
      "na_action",
      "NA action",
      choices = letters[1:3],
      selected = letters[1]
    )
  )
)
#> Warning: `panel_group()` was deprecated in teal.widgets 0.4.3.
#> ℹ The `panel_group()` and `panel_item()` view can be achieved by using the
#>   `bslib` package. Please use the `bslib::accordion()` and
#>   `bslib::accordion_panel()` functions instead. This function will be removed
#>   in the next release.
#> Warning: `panel_item()` was deprecated in teal.widgets 0.4.3.
#> ℹ The `panel_group()` and `panel_item()` view can be achieved by using the
#>   `bslib` package. Please use the `bslib::accordion()` and
#>   `bslib::accordion_panel()` functions instead. This function will be removed
#>   in the next release.
#> <div class="container-fluid">
#>   <div id="bslib-accordion-4211" class="accordion" data-require-bs-version="5" data-require-bs-caller="accordion()">
#>     <div class="accordion-item" data-value="Display">
#>       <div class="accordion-header">
#>         <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#bslib-accordion-panel-2830" aria-controls="bslib-accordion-panel-2830" aria-expanded="true">
#>           <div class="accordion-icon"></div>
#>           <div class="accordion-title">Display</div>
#>         </button>
#>       </div>
#>       <div id="bslib-accordion-panel-2830" class="accordion-collapse collapse show">
#>         <div class="accordion-body" open="TRUE">
#>           <div id="check" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="check-label">
#>             <label class="control-label" id="check-label" for="check">Tables display</label>
#>             <div class="shiny-options-group">
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="check" value="A" checked="checked"/>
#>                   <span>A</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="check" value="B"/>
#>                   <span>B</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="check" value="C"/>
#>                   <span>C</span>
#>                 </label>
#>               </div>
#>             </div>
#>           </div>
#>           <div id="radio" class="form-group shiny-input-radiogroup shiny-input-container" role="radiogroup" aria-labelledby="radio-label">
#>             <label class="control-label" id="radio-label" for="radio">Plot type</label>
#>             <div class="shiny-options-group">
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="radio" value="a" checked="checked"/>
#>                   <span>a</span>
#>                 </label>
#>               </div>
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="radio" value="b"/>
#>                   <span>b</span>
#>                 </label>
#>               </div>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="accordion-item" data-value="Pre-processing">
#>       <div class="accordion-header">
#>         <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#bslib-accordion-panel-5936" aria-expanded="false" aria-controls="bslib-accordion-panel-5936">
#>           <div class="accordion-icon"></div>
#>           <div class="accordion-title">Pre-processing</div>
#>         </button>
#>       </div>
#>       <div id="bslib-accordion-panel-5936" class="accordion-collapse collapse">
#>         <div class="accordion-body" open="FALSE">
#>           <div id="filtering" class="form-group shiny-input-radiogroup shiny-input-container" role="radiogroup" aria-labelledby="filtering-label">
#>             <label class="control-label" id="filtering-label" for="filtering">What to filter</label>
#>             <div class="shiny-options-group">
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="filtering" value="A" checked="checked"/>
#>                   <span>A</span>
#>                 </label>
#>               </div>
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="filtering" value="B"/>
#>                   <span>B</span>
#>                 </label>
#>               </div>
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="filtering" value="C"/>
#>                   <span>C</span>
#>                 </label>
#>               </div>
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="filtering" value="D"/>
#>                   <span>D</span>
#>                 </label>
#>               </div>
#>             </div>
#>           </div>
#>           <div id="na_action" class="form-group shiny-input-radiogroup shiny-input-container" role="radiogroup" aria-labelledby="na_action-label">
#>             <label class="control-label" id="na_action-label" for="na_action">NA action</label>
#>             <div class="shiny-options-group">
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="na_action" value="a" checked="checked"/>
#>                   <span>a</span>
#>                 </label>
#>               </div>
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="na_action" value="b"/>
#>                   <span>b</span>
#>                 </label>
#>               </div>
#>               <div class="radio">
#>                 <label>
#>                   <input type="radio" name="na_action" value="c"/>
#>                   <span>c</span>
#>                 </label>
#>               </div>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
