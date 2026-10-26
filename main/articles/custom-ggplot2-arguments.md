# Custom \`ggplot2\` arguments module

This vignette will guide you through implementation of custom
[`ggplot2::labs`](https://ggplot2.tidyverse.org/reference/labs.html) and
[`ggplot2::theme`](https://ggplot2.tidyverse.org/reference/theme.html)
for `ggplot2` graphics based modules. We will enable 2 ways of updating
[`ggplot2::labs`](https://ggplot2.tidyverse.org/reference/labs.html) and
[`ggplot2::theme`](https://ggplot2.tidyverse.org/reference/theme.html)
by the end users. The `ggplot2` specification could be updated with the
`teal.ggplot2_args` `options` variable or a `ggplot2_args` argument in a
`tm_g_*` module. We still take into account default specification set up
by the module creator in the server function, which has the lowest
priority.

The implementation should consist of 5 steps:

1.  Adding a `ggplot2_args` argument to the `tm_g_*` function and then
    its server function. The default should be set to the
    `ggplot2_args(labs = list(), theme = list())` function for single
    plot. and
    `list(default = ggplot2_args(labs = list(), theme = list()))`
    multi-plot modules.
2.  Adding a validation (e.g. `stopifnot` or `checkmate`) of the
    `ggplot2_args` argument to the `tm_*` function. The validation is
    more complex for multi-plot modules, where the `ggplot2_args` could
    be a `list`. The module creator has to provide a list of plots
    names, which should be validated at this step and added to the
    `param` field in `roxygen2`. For multi-plot modules the step
    `if (is_ggplot2_args) ggplot2_args <- list(default = ggplot2_args)`
    is recommended.
3.  Aggregating and reducing all `ggplot2_args` sources with
    [`resolve_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_ggplot2_args.md).
4.  Usage of the
    [`parse_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_ggplot2_args.md)
    function which will parse inputs to list of expressions.
5.  Adding the created expression to the last chunk of a plot.
    `Reduce(function(x, y) call("+", x, y), list(...)` function could be
    helpful at this step.

The
[`resolve_ggplot2_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_ggplot2_args.md)
function picks the first non NULL value for each argument, checking in
order:

1.  `ggplot2_args` argument provided by the end user. For multi-plot
    case, per plot (`user_plot`) and then default (`user_default`)
    setup.
2.  Global R variable (`options`), `teal.ggplot2_args`.
3.  `module_plot` which is a developer setup.

### Additional topics

When a more complex `ggplot2` object has to be used inside the
`ggplot2_args` function, then a
[`base::quote`](https://rdrr.io/r/base/substitute.html) function would
prevent an object expansion in Show R Code. For example the
[`ggplot2::element_text`](https://ggplot2.tidyverse.org/reference/element.html)
function returns a complex object, then we should use code like
`ggplot2_args(theme = list(plot.title = quote(ggplot2::element_text(size = 20))))`
to prevent Show R Code expansion.

If you get a
`promise already under evaluation: recursive default argument reference or earlier problems?`
error, then probably your function argument has the same name as a
function which is an input for it. To solve the problem please use `::`
to prefix it directly to a specific package, like
`new_fun <- function(ggplot2_args = ggplot2_args())`.

## Loading libraries and data

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`shiny`](https://shiny.posit.co/)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`ggplot2`](https://ggplot2.tidyverse.org)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`teal.widgets`](https://pharmaverse.github.io/teal.widgets/)`)`\
\
[`options`](https://rdrr.io/r/base/options.html)`(``"teal.ggplot2_args"`` ``=`` `[`ggplot2_args`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)`(``labs ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``caption ``=`` ``"Caption from options"``)``)``)`\
\
`user_ggplot2_args`` ``<-`` `[`list`](https://rdrr.io/r/base/list.html)`(`\
`  default ``=`` `[`ggplot2_args`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)`(`\
`    labs ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``title ``=`` ``"User default title"``)``,`\
`    theme ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``legend.position ``=`` ``"right"``, legend.direction ``=`` ``"vertical"``)`\
`  ``)``,`\
`  plot1 ``=`` `[`ggplot2_args`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)`(`\
`    labs ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``title ``=`` ``"User title"``)``,`\
`    theme ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``legend.position ``=`` ``"right"``, legend.direction ``=`` ``"vertical"``)`\
`  ``)`\
`)`\
\
`ui`` ``<-`` `[`fluidPage`](https://rdrr.io/pkg/shiny/man/fluidPage.html)`(`\
`  ``shinyjs``::`[`useShinyjs`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html)`(``)``,`\
`  ``tags``$``div``(`[`plotOutput`](https://rdrr.io/pkg/shiny/man/plotOutput.html)`(``"plot1"``)``)`\
`)`\
\
`server`` ``<-`` ``function``(``input``, ``output``, ``session``)`` ``{`\
`  ``dev_ggplot2_args`` ``<-`` `[`ggplot2_args`](https://pharmaverse.github.io/teal.widgets/reference/ggplot2_args.md)`(`\
`    labs ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``subtitle ``=`` ``"Dev substitle"``)``,`\
`    theme ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``legend.position ``=`` ``"none"``)`\
`  ``)`\
\
`  ``f_ggplot2_expr`` ``<-`` `[`parse_ggplot2_args`](https://pharmaverse.github.io/teal.widgets/reference/parse_ggplot2_args.md)`(`\
`    `[`resolve_ggplot2_args`](https://pharmaverse.github.io/teal.widgets/reference/resolve_ggplot2_args.md)`(`\
`      user_plot ``=`` ``user_ggplot2_args``$``plot1``,`\
`      user_default ``=`` ``user_ggplot2_args``$``default``,`\
`      module_plot ``=`` ``dev_ggplot2_args`\
`    ``)`\
`  ``)`\
\
`  ``plot_expr`` ``<-`` `[`substitute`](https://rdrr.io/r/base/substitute.html)`(`\
`    expr ``=`` ``{`\
`      ``gg`` ``<-`` `[`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html)`(``iris``, `[`aes`](https://ggplot2.tidyverse.org/reference/aes.html)`(``x ``=`` ``Sepal.Length``, y ``=`` ``Petal.Length``, color ``=`` ``Species``)``)`` ``+`\
`        `[`geom_point`](https://ggplot2.tidyverse.org/reference/geom_point.html)`(``)`` ``+`\
`        ``ggplot_expr_labs`` ``+`\
`        ``ggplot_expr_theme`\
`      `[`print`](https://rdrr.io/r/base/print.html)`(``gg``)`\
`    ``}``,`\
`    env ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``ggplot_expr_labs ``=`` ``f_ggplot2_expr``$``labs``, ggplot_expr_theme ``=`` ``f_ggplot2_expr``$``theme``)`\
`  ``)`\
`  `[`print`](https://rdrr.io/r/base/print.html)`(``plot_expr``)`\
`  ``output``$``plot1`` ``<-`` `[`renderPlot`](https://rdrr.io/pkg/shiny/man/renderPlot.html)`(`[`eval`](https://rdrr.io/r/base/eval.html)`(``plot_expr``)``)`\
`}`\
\
`if`` ``(`[`interactive`](https://rdrr.io/r/base/interactive.html)`(``)``)`` ``{`\
`  `[`shinyApp`](https://rdrr.io/pkg/shiny/man/shinyApp.html)`(``ui``, ``server``)`\
`}`
