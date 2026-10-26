#' This function checks the plot type and applies specific modifications
#' to the plot object based on the provided parameters.
#'
#' @param plot_obj The original plot object.
#' @param plot_type The type of the plot, either `gg` (`ggplot2`) or `grob` (`grid`, `graphics`).
#' @param dblclicking A logical value indicating whether double-clicking on data points on
#' the main plot is enabled or disabled.
#' @param ranges A list containing x and y values of ranges.
#'
#' @keywords internal
apply_plot_modifications <- function(plot_obj, plot_type, dblclicking, ranges) {
  if (plot_type == "gg" && dblclicking) {
    plot_obj +
      ggplot2::coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  } else if (plot_type == "grob") {
    grid::grid.newpage()
    grid::grid.draw(plot_obj)
  } else {
    plot_obj
  }
}

.warning_gt_webshot2 <- function(table, #
                                 webshot_installed = requireNamespace("webshot2", quietly = TRUE)) {
  if (
    checkmate::test_multi_class(table, c("gt_tbl", "tbl_split", "tbl_summary")) &&
      !webshot_installed &&
      !identical(Sys.getenv("DISABLE_GT_WEBSHOT2_WARNING"), "true") &&
      is.null(.warnings_env$gt_webshot2_warning)
  ) {
    .warnings_env$gt_webshot2_warning <- warningCondition(
      paste0(
        "The `webshot2` package is required to donwload gt tables as PDF. Please install it to use this feature.",
        " This warning will only be shown once per session."
      ),
      class = "gt_webshot2_warning"
    )
    warning(.warnings_env$gt_webshot2_warning)
  }
}

.warnings_env <- new.env(parent = emptyenv())

#' Validate the download file name
#'
#' Hides the `data_download` button and renders `output$file_name_warning` when `input$file_name`
#' does not contain any letter or number, e.g. it is empty or only whitespace or special characters.
#'
#' @param input,output Shiny module `input` and `output` objects.
#'
#' @return `reactive` returning `TRUE` when the file name is valid.
#'
#' @noRd
file_name_validation_srv <- function(input, output) {
  file_name_valid <- reactive({
    isTRUE(grepl("[[:alnum:]]", input$file_name))
  })

  observeEvent(file_name_valid(), {
    shinyjs::toggle("data_download", condition = file_name_valid())
  })

  output$file_name_warning <- renderUI({
    if (!file_name_valid()) {
      helpText(
        class = "error",
        icon("triangle-exclamation"),
        "Please provide a meaningful file name: it must contain at least one letter or number."
      )
    }
  })

  file_name_valid
}
