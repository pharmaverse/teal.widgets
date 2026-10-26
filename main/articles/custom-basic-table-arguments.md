# Custom basic_table arguments module

This vignette will guide you through implementation of custom
[`rtables::basic_table`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
arguments for `rtables` tables based modules. We will enable 2 ways of
updating
[`rtables::basic_table`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
by the end users. The
[`rtables::basic_table`](https://insightsengineering.github.io/rtables/latest-tag/reference/basic_table.html)
specification could be updated with the `teal.basic_table_args`
`options` variable or a `ggplot2_args` argument in a `tm_g_*` module. We
still take into account default specification set up by the module
creator in the server function, which has the lowest priority.

The implementation should consist of 5 steps:

1.  Add the `basic_table_args` arguments to the `tm_t_*` function and
    then its server function. The default should be set to the
    [`basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)
    function for a single plot. and `list(default = basic_table_args())`
    multi-table modules.
2.  Add validation (e.g. `stopifnot` or `checkmate`) for the
    `basic_table_args` arguments to the `tm_*` function. The validation
    is more complex for multi-table modules, where the `ggplot2_args`
    could be a `list`. The module creator has to provide a list of plots
    names, which should be validated at this step and added to the
    `param` field in `roxygen2`. For multi-table modules the step
    `if (is_basic_table_args) basic_table_args <- list(default = basic_table_args)`
    is recommended.
3.  Aggregate and reduce all `basic_table_args` sources with
    [`resolve_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/resolve_basic_table_args.md).
4.  Use the
    [`parse_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_basic_table_args.md)
    function which will aggregate and reduce all inputs to one
    expression.
5.  Add the created expression to the chunk with a table.

The
[`parse_basic_table_args()`](https://pharmaverse.github.io/teal.widgets/reference/parse_basic_table_args.md)
function picks the first non NULL value for each argument, checking in
order:

1.  `basic_table_args` arguments provided by the end user. For
    multi-table case, per table (`basic_table_args_table`) and then
    default (`basic_table_args_default`) setup.
2.  Global R variable (`options`), `teal.basic_table_args`.
3.  `basic_table_args_developer` which is a developer setup, lowest
    priority.

## Example - Single-Table Module

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`shiny`](https://shiny.posit.co/)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`teal.widgets`](https://pharmaverse.github.io/teal.widgets/)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`magrittr`](https://magrittr.tidyverse.org)`)`\
\
[`options`](https://rdrr.io/r/base/options.html)`(``"teal.basic_table_args"`` ``=`` `[`basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)`(``title ``=`` ``"ENV_TITLE"``)``)`\
\
`basic_table_args`` ``<-`` `[`list`](https://rdrr.io/r/base/list.html)`(`\
`  default ``=`` `[`basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)`(``prov_footer ``=`` ``"USER_FOOTER"``)``,`\
`  table1 ``=`` `[`basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)`(``subtitles ``=`` ``"USER_SUBTITLES_TABLE1"``)``,`\
`  table2 ``=`` `[`basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)`(``subtitles ``=`` ``"USER_SUBTITLES_TABLE2"``)`\
`)`\
\
\
`ui`` ``<-`` `[`fluidPage`](https://rdrr.io/pkg/shiny/man/fluidPage.html)`(`\
`  ``shinyjs``::`[`useShinyjs`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html)`(``)``,`\
`  ``tags``$``div``(`[`verbatimTextOutput`](https://rdrr.io/pkg/shiny/man/textOutput.html)`(``"table1"``)``)`\
`)`\
\
`server`` ``<-`` ``function``(``input``, ``output``, ``session``)`` ``{`\
`  ``dev_table_args`` ``<-`` `[`basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/basic_table_args.md)`(``show_colcounts ``=`` ``TRUE``)`\
\
`  ``table_expr`` ``<-`` `[`substitute`](https://rdrr.io/r/base/substitute.html)`(`\
`    expr ``=`` ``{`\
`      ``tt`` ``<-`` ``f_table_expr`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)\
`        ``rtables``::`[`split_cols_by`](https://insightsengineering.github.io/rtables/latest-tag/reference/split_cols_by.html)`(``"Species"``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)\
`        ``rtables``::`[`analyze`](https://insightsengineering.github.io/rtables/latest-tag/reference/analyze.html)`(``vars ``=`` ``"Sepal.Length"``, afun ``=`` ``function``(``x``)`` ``{`\
`          ``rtables``::`[`in_rows`](https://insightsengineering.github.io/rtables/latest-tag/reference/in_rows.html)`(`\
`            ``"Mean"`` ``=`` ``rtables``::`[`rcell`](https://insightsengineering.github.io/rtables/latest-tag/reference/rcell.html)`(`[`mean`](https://rdrr.io/r/base/mean.html)`(``x``)``, format ``=`` ``"xx.xx"``)``,`\
`            ``"Range"`` ``=`` ``rtables``::`[`rcell`](https://insightsengineering.github.io/rtables/latest-tag/reference/rcell.html)`(`[`range`](https://rdrr.io/r/base/range.html)`(``x``)``, format ``=`` ``"xx.xx - xx.xx"``)`\
`          ``)`\
`        ``}``)`\
`      ``table2`` ``<-`` ``rtables``::`[`build_table`](https://insightsengineering.github.io/rtables/latest-tag/reference/build_table.html)`(``tt``, ``iris``)`\
`      ``table2`\
`    ``}``,`\
`    env ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``f_table_expr ``=`` `[`parse_basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/parse_basic_table_args.md)`(`\
`      `[`resolve_basic_table_args`](https://pharmaverse.github.io/teal.widgets/reference/resolve_basic_table_args.md)`(`\
`        user_table ``=`` ``basic_table_args``$``table2``,`\
`        user_default ``=`` ``basic_table_args``$``default``,`\
`        module_table ``=`` ``dev_table_args`\
`      ``)`\
`    ``)``)`\
`  ``)`\
`  ``output``$``table1`` ``<-`` `[`renderPrint`](https://rdrr.io/pkg/shiny/man/renderPrint.html)`(`[`eval`](https://rdrr.io/r/base/eval.html)`(``table_expr``)``)`\
`}`\
\
`if`` ``(`[`interactive`](https://rdrr.io/r/base/interactive.html)`(``)``)`` ``{`\
`  `[`shinyApp`](https://rdrr.io/pkg/shiny/man/shinyApp.html)`(``ui``, ``server``)`\
`}`
