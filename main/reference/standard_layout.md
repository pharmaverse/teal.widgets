# Standard UI layout

Create a standard UI layout with output on the right and an encoding
panel on the left. This is the layout used by the `teal` modules.

## Usage

``` r
standard_layout(
  output,
  encoding = NULL,
  forms = NULL,
  pre_output = NULL,
  post_output = NULL
)
```

## Arguments

- output:

  (`shiny.tag`)\
  object with the output element (table, plot, listing) such as for
  example returned by
  [`shiny::plotOutput()`](https://rdrr.io/pkg/shiny/man/plotOutput.html).

- encoding:

  (`shiny.tag`)\
  object containing the encoding elements. If this element is `NULL`
  then no encoding side panel on the right is created.

- forms:

  (`tagList`)\
  for example
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  that are placed below the encodings panel

- pre_output:

  (`shiny.tag`) optional,\
  with text placed before the output to put the output into context. For
  example a title.

- post_output:

  (`shiny.tag`) optional, with text placed after the output to put the
  output into context. For example the
  [`shiny::helpText()`](https://rdrr.io/pkg/shiny/man/helpText.html)
  elements are useful.

## Value

an object of class `shiny.tag` with the UI code.

## Examples

``` r
library(shiny)
standard_layout(
  output = white_small_well(tags$h3("Tests")),
  encoding = tags$div(
    tags$label("Encodings", class = "text-primary"),
    panel_item(
      "Tests",
      optionalSelectInput(
        "tests",
        "Tests:",
        choices = c(
          "Shapiro-Wilk",
          "Kolmogorov-Smirnov (one-sample)"
        ),
        selected = "Shapiro-Wilk"
      )
    )
  ),
  forms = tagList(
    verbatim_popup_ui("warning", "Show Warnings"),
    verbatim_popup_ui("rcode", "Show R code")
  )
)
#> <div class="container-fluid teal-widgets standard-layout-wrapper">
#>   <div class="teal-widgets standard-layout has-encodings">
#>     <div class="bslib-sidebar-layout bslib-mb-spacing html-fill-item" data-bslib-sidebar-init="TRUE" data-collapsible-desktop="true" data-collapsible-mobile="true" data-open-desktop="open" data-open-mobile="closed" data-require-bs-caller="layout_sidebar()" data-require-bs-version="5" style="--_sidebar-width:250px;">
#>       <div class="main bslib-gap-spacing html-fill-container">
#>         <div class="teal-widgets standard-layout">
#>           <div class="standard-layout-pre-output"></div>
#>           <div class="standard-layout-output">
#>             <div class="well well-sm" style="background-color: white;">
#>               <h3>Tests</h3>
#>             </div>
#>           </div>
#>           <div class="standard-layout-post-output"></div>
#>         </div>
#>       </div>
#>       <aside id="bslib-sidebar-3816" class="sidebar" hidden data-resizable>
#>         <div class="sidebar-content bslib-gap-spacing">
#>           <div>
#>             <div>
#>               <label class="text-primary">Encodings</label>
#>               <div class="accordion-item" data-value="Tests">
#>                 <div class="accordion-header">
#>                   <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#bslib-accordion-panel-6959" aria-expanded="false" aria-controls="bslib-accordion-panel-6959">
#>                     <div class="accordion-icon"></div>
#>                     <div class="accordion-title">Tests</div>
#>                   </button>
#>                 </div>
#>                 <div id="bslib-accordion-panel-6959" class="accordion-collapse collapse">
#>                   <div class="accordion-body" open="FALSE">
#>                     <div>
#>                       <script>
#>         $(function() {
#>           $('#tests').on('change', function(e) {
#>             var select_concat = $(this).val().length ? $(this).val().join(', ') : 'NULL';
#>             $('#tests_selected_text').html(select_concat);
#>           })
#>         })</script>
#>                       <div>
#>                         <div id="tests_input" style="display: block;">
#>                           <div class="form-group shiny-input-container">
#>                             <label class="control-label" id="tests-label" for="tests">Tests:</label>
#>                             <select data-actions-box="false" data-none-selected-text="- Nothing selected -" data-allow-clear="true" data-max-options="1" data-show-subtext="true" data-live-search="false" data-container="body" data-state-input="true" id="tests" class="selectpicker form-control" autocomplete="off" multiple="multiple"><option value="Shapiro-Wilk" selected>Shapiro-Wilk</option>
#> <option value="Kolmogorov-Smirnov (one-sample)">Kolmogorov-Smirnov (one-sample)</option></select>
#>                           </div>
#>                         </div>
#>                         <div id="tests_fixed" style="display: none;">
#>                           <label class="control-label">Tests:</label>
#>                           <code id="tests_selected_text">Shapiro-Wilk</code>
#>                         </div>
#>                       </div>
#>                     </div>
#>                   </div>
#>                 </div>
#>               </div>
#>             </div>
#>             <div>
#>               <br/>
#>               <button class="btn btn-default action-button teal-widgets-busy-disable button" id="warning-button" type="button"><span class="action-label">Show Warnings</span></button>
#>               <button class="btn btn-default action-button teal-widgets-busy-disable button" id="rcode-button" type="button"><span class="action-label">Show R code</span></button>
#>             </div>
#>           </div>
#>         </div>
#>       </aside>
#>       <button class="collapse-toggle" type="button" title="Toggle sidebar" aria-expanded="true" aria-controls="bslib-sidebar-3816"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-chevron-left collapse-icon" style="height:;width:;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"></path></svg></button>
#>       <script data-bslib-sidebar-init>bslib.Sidebar.initCollapsibleAll()</script>
#>     </div>
#>   </div>
#> </div>
```
