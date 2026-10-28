#' @keywords internal
#' @noRd
table_with_settings_deps <- function() {
  htmltools::htmlDependency(
    name = "teal-widgets-table-with-settings",
    version = utils::packageVersion("teal.widgets"),
    package = "teal.widgets",
    src = "table-with-settings",
    stylesheet = "table-with-settings.css"
  )
}

render_table_to_html_rtables <- function(x, ...) {
  rtables::as_html(x)
}

file_download_format <- function(x, filename) {
  UseMethod("file_download_format", x)
}

#' @method file_download_format default
#' @keywords internal
#' @exportS3Method
file_download_format.default <- function(x, filename) {
  filename
}

#' @method file_download_format tbl_split
#' @keywords internal
#' @exportS3Method
file_download_format.tbl_split <- function(x, filename) {
  new_filename <- tools::file_path_sans_ext(filename)
  paste0(new_filename, ".zip")
}

#' Render table object to HTML
#'
#' @param x The table object to render
#' @param ... Additional arguments (currently unused)
#' @return HTML representation of the table
#' @keywords internal
#' @noRd
render_table_to_html <- function(x, ...) {
  UseMethod("render_table_to_html", x)
}

#' @method render_table_to_html default
#' @keywords internal
#' @exportS3Method
render_table_to_html.default <- function(x, ...) {
  stop(
    "Unsupported table type. ",
    "table_with_settings supports rtables (ElementaryTable, TableTree), ",
    "gtsummary, or gt (gt_tbl) objects."
  )
}

#' @method render_table_to_html ElementaryTable
#' @keywords internal
#' @exportS3Method
render_table_to_html.ElementaryTable <- render_table_to_html_rtables

#' @method render_table_to_html TableTree
#' @keywords internal
#' @exportS3Method
render_table_to_html.TableTree <- render_table_to_html_rtables

#' @method render_table_to_html gtsummary
#' @keywords internal
#' @exportS3Method
render_table_to_html.gtsummary <- function(x, ...) {
  gt_obj <- gtsummary::as_gt(x)
  render_table_to_html(gt_obj)
}

#' @method render_table_to_html gt_tbl
#' @keywords internal
#' @exportS3Method
render_table_to_html.gt_tbl <- function(x, ...) {
  htmltools::HTML(gt::as_raw_html(x))
}

#' @method render_table_to_html tbl_split
#' @keywords internal
#' @exportS3Method
render_table_to_html.tbl_split <- function(x, ...) {
  tables <- lapply(seq_along(x), function(tbl) {
    label <- attr(x[[tbl]], "variable_level", exact = TRUE)
    htmltools::tags$div(
      if (checkmate::test_string(label)) htmltools::tags$h4("Variable level:", label),
      render_table_to_html(x[[tbl]])
    )
  })
  htmltools::tags$div(tables)
}

#' Export table object to file
#'
#' @param x The table object to export
#' @param file The file path to write to
#' @param format The file format (".txt", ".csv", or ".pdf")
#' @param paginate Logical indicating whether to paginate (for rtables)
#' @param lpp Lines per page for pagination (for rtables)
#' @param ... Additional arguments (currently unused)
#' @keywords internal
#' @noRd
export_table <- function(x, file, format, paginate = FALSE, lpp = NULL, ...) {
  UseMethod("export_table", x)
}

#' @method export_table default
#' @keywords internal
#' @exportS3Method
export_table.default <- function(x, file, format, paginate = FALSE, lpp = NULL, ...) {
  stop("Unsupported table type for download")
}

export_table_rtables <- function(x, file, format, paginate = FALSE, lpp = NULL, ...) {
  if (format == ".txt") {
    rtables::export_as_txt(
      x = x,
      file = file,
      paginate = paginate,
      lpp = if (paginate) as.numeric(lpp)
    )
  } else if (format == ".csv") {
    result <- rtables::matrix_form(x)$strings
    utils::write.table(
      x = result,
      file = file,
      sep = ",",
      col.names = FALSE,
      row.names = TRUE,
      append = FALSE
    )
  } else {
    rtables::export_as_pdf(
      x = x,
      file = file,
      paginate = paginate,
      lpp = if (paginate) as.numeric(lpp)
    )
  }
}

#' @method export_table ElementaryTable
#' @keywords internal
#' @exportS3Method
export_table.ElementaryTable <- export_table_rtables

#' @method export_table TableTree
#' @keywords internal
#' @exportS3Method
export_table.TableTree <- export_table_rtables

#' @method export_table gtsummary
#' @keywords internal
#' @exportS3Method
export_table.gtsummary <- function(x, file, format, paginate = FALSE, lpp = NULL, ...) {
  gt_obj <- gtsummary::as_gt(x)
  export_table(gt_obj, file, format, paginate, lpp, ...)
}

#' @method export_table gt_tbl
#' @keywords internal
#' @exportS3Method
export_table.gt_tbl <- function(x, file, format, paginate = FALSE, lpp = NULL, ...) {
  if (format == ".csv") {
    utils::write.csv(export_table_raw(x), file = file, row.names = FALSE)
  } else if (format == ".pdf") {
    gt::gtsave(x, filename = file)
  } else {
    utils::write.table(
      x = export_table_raw(x),
      file = file,
      sep = "\t",
      quote = FALSE,
      row.names = FALSE,
      col.names = TRUE
    )
  }
}

#' @method export_table tbl_split
#' @keywords internal
#' @exportS3Method
export_table.tbl_split <- function(x, file, format, paginate = FALSE, lpp = NULL, file_name = file, ...) {
  ext <- format # ".pdf" or ".txt"
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  base_name <- tools::file_path_sans_ext(basename(file_name))

  tmp_files <- lapply(seq_along(x), function(i) {
    label <- as.vector(attr(x[[i]], "variable_level", exact = TRUE))
    if (checkmate::test_string(label)) {
      base_name <- paste0(base_name, "_", gsub("[^[:alnum:]]", "_", label), "_", i)
    } else {
      base_name <- paste0(base_name, "_", i)
    }
    tmp_file <- file.path(tmp_dir, paste0(base_name, ext))
    export_table(x[[i]], file = tmp_file, format = format, paginate = paginate, lpp = lpp, ...)
    tmp_file
  })

  utils::zip(zipfile = file, files = unlist(tmp_files), flags = "-j") # -j: junk paths
}

export_table_raw <- function(x) {
  html_content <- gt::as_raw_html(x)
  html_parsed <- rvest::read_html(html_content)

  # xml_remove modifies the object so no need to ovewrite
  xml2::xml_remove(rvest::html_nodes(html_parsed, "caption, .gt_heading"))

  tbl <- rvest::html_table(html_parsed)[[1]]
  names(tbl) <- gsub("[\n\r\t]", " ", names(tbl))
  tbl
}

#' @name table_with_settings
#'
#' @title `table_with_settings` module
#'
#' @description
#' Module designed to create a `shiny` table output based on table objects.
#' Supports `rtables` objects (`ElementaryTable` or `TableTree`), `gtsummary` objects, or `gt` objects.
#' @inheritParams shiny::moduleServer
#' @param ... (`character`)\cr
#'  Useful for providing additional HTML classes for the output tag.
#'
#' @note The download of [gt::gt()] and [gtsummary::tbl_summary()] tables as PDF requires the `webshot2` package
#' to be installed.
#' A once a session warning is displayed if the package is not installed when calling `table_with_settings` with
#' a reactive table in one of those formats.
#'
#' @rdname table_with_settings
#' @export
#'
table_with_settings_ui <- function(id, ...) {
  checkmate::assert_string(id)

  ns <- NS(id)

  tags$div(
    table_with_settings_deps(),
    shinyjs::useShinyjs(),
    bslib::card(
      id = ns("table-with-settings"),
      full_screen = TRUE,
      tags$div(
        class = "teal-widgets settings-buttons",
        bslib::tooltip(
          trigger = tags$div(type_download_ui_table(ns("downbutton"))),
          options = list(trigger = "hover"),
          class = "download-button",
          "Download"
        )
      ),
      tags$div(
        class = "teal-widgets table-content",
        uiOutput(ns("table_out_main"), width = "100%", ...)
      )
    )
  )
}

#' @inheritParams shiny::moduleServer
#' @param table_r (`reactive`)\cr
#'  reactive expression that yields a table object. Supported types:
#'  - `rtables` objects (`ElementaryTable` or `TableTree`)
#'  - `gtsummary` objects
#'  - `gt` objects (`gt_tbl`)
#' @param show_hide_signal (`reactive logical`) optional\cr
#'  mechanism to allow modules which call this module to show/hide the table_with_settings UI.
#'
#' @rdname table_with_settings
#'
#' @return A `shiny` module.
#'
#' @export
#'
#' @examples
#' library(shiny)
#' library(rtables)
#' library(gtsummary)
#' library(gt)
#' library(magrittr)
#'
#' ui <- bslib::page_fluid(
#'   table_with_settings_ui(id = "rtables_table"),
#'   table_with_settings_ui(id = "gtsummary_table"),
#'   table_with_settings_ui(id = "gt_table")
#' )
#'
#' server <- function(input, output, session) {
#'   table_r_rtables <- reactive({
#'     l <- basic_table() %>%
#'       split_cols_by("ARM") %>%
#'       analyze(c("SEX", "AGE"))
#'     build_table(l, DM)
#'   })
#'
#'   table_r_gtsummary <- reactive({
#'     gtsummary::tbl_summary(mtcars)
#'   })
#'
#'   table_r_gt <- reactive({
#'     mtcars %>%
#'       gt::gt() %>%
#'       gt::tab_header(title = "Motor Trend Car Road Tests")
#'   })
#'
#'   table_with_settings_srv(id = "rtables_table", table_r = table_r_rtables)
#'   table_with_settings_srv(id = "gtsummary_table", table_r = table_r_gtsummary)
#'   table_with_settings_srv(id = "gt_table", table_r = table_r_gt)
#' }
#'
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#'
table_with_settings_srv <- function(id, table_r, show_hide_signal = reactive(TRUE)) {
  checkmate::assert_class(table_r, c("reactive", "function"))
  checkmate::assert_class(show_hide_signal, c("reactive", "function"))

  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    # Turn on and off the UI
    observeEvent(show_hide_signal(), {
      if (show_hide_signal()) {
        shinyjs::show("table-with-settings")
      } else {
        shinyjs::hide("table-with-settings")
      }
    })

    output$table_out_main <- output$table_out_modal <- renderUI({
      .warning_gt_webshot2(table_r())
      render_table_to_html(table_r())
    })

    type_download_srv_table(
      id = "downbutton",
      table_reactive = table_r
    )
  })
}

type_download_ui_table <- function(id) {
  ns <- NS(id)
  bslib::popover(
    icon("download"),
    tags$div(
      radioButtons(
        ns("file_format"),
        label = tags$span("File type", shinyjs::hidden(
          tags$div(
            id = ns("pdf_warning"),
            style = c(
              "cursor: help;", "color: var(--bs-gray-600);", "margin-bottom: 0.5rem;",
              "font-size: 0.875rem;", "padding-left: 0.1rem;"
            ),
            icon("circle-info"),
            title = "Contact app support to enable PDF download by installing the `webshot2` package.",
            "PDF download is disabled."
          )
        )),
        choices = c("formatted txt" = ".txt", "csv" = ".csv", "pdf" = ".pdf")
      ),
      textInput(ns("file_name"),
        label = "File name (without extension)",
        value = paste0("table_", strftime(Sys.time(), format = "%Y%m%d_%H%M%S"))
      ),
      uiOutput(ns("file_name_warning")),
      conditionalPanel(
        condition = paste0("input['", ns("file_format"), "'] != '.csv'"),
        tags$div(
          class = "lock-btn",
          title = "on / off",
          shinyWidgets::prettyToggle(
            ns("pagination_switch"),
            value = FALSE,
            label_on = NULL,
            label_off = NULL,
            status_on = "default",
            status_off = "default",
            outline = FALSE,
            plain = TRUE,
            icon_on = icon("fas fa-toggle-off"),
            icon_off = icon("fas fa-toggle-on"),
            animation = "pulse"
          )
        ),
        tags$div(
          class = "paginate-ui",
          shinyWidgets::numericInputIcon(
            inputId = ns("lpp"),
            label = "Paginate table:",
            value = 70,
            icon = list("lines / page")
          ),
          uiOutput(ns("lpp_warning"))
        )
      ),
      conditionalPanel(
        condition = paste0("input['", ns("file_name"), "'] != ''"),
        downloadButton(ns("data_download"), label = character(0), class = "btn-sm w-full")
      )
    )
  )
}

type_download_srv_table <- function(id, table_reactive) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(table_reactive(), {
        if (
          checkmate::test_multi_class(table_reactive(), c("gt_tbl", "tbl_split", "tbl_summary")) &&
            !requireNamespace("webshot2", quietly = TRUE)
        ) {
          updateRadioButtons(
            inputId = "file_format",
            choices = list("formatted txt" = ".txt", "csv" = ".csv")
          )
          shinyjs::show("pdf_warning")
        }
      })
      observeEvent(input$pagination_switch, {
        if (input$pagination_switch) {
          shinyjs::enable("lpp")
        } else {
          shinyjs::disable("lpp")
        }
      })

      file_name_valid <- file_name_validation_srv(input, output)

      output$lpp_warning <- renderUI({
        table_obj <- table_reactive()
        # Pagination warning only applies to rtables
        if (
          inherits(table_obj, c("ElementaryTable", "TableTree")) &&
            input$file_format != ".csv" &&
            input$pagination_switch
        ) {
          catch_warning <- try(rtables::paginate_table(
            tt = table_obj,
            lpp = as.numeric(input$lpp)
          ), silent = TRUE)

          if (inherits(catch_warning, "try-error")) {
            helpText(
              class = "error",
              icon("triangle-exclamation"),
              paste0(
                "Maximum lines per page includes the reprinted header.",
                "Please enter a numeric value or increase the value."
              )
            )
          }
        }
      })

      output$data_download <- downloadHandler(
        filename = function() {
          file_download_format(table_reactive(), paste0(input$file_name, input$file_format))
        },
        content = function(file) {
          export_table(
            x = table_reactive(),
            file = file,
            format = input$file_format,
            paginate = input$pagination_switch,
            lpp = if (input$pagination_switch) as.numeric(input$lpp),
            file_name = input$file_name
          )
        }
      )
    }
  )
}
