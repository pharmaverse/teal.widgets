#' @keywords internal
#' @noRd
plot_with_settings_deps <- function() {
  htmltools::htmlDependency(
    name = "teal-widgets-plot-with-settings",
    version = utils::packageVersion("teal.widgets"),
    package = "teal.widgets",
    src = "plot-with-settings",
    stylesheet = "plot-with-settings.css",
    script = "plot-with-settings.js"
  )
}

#' @name plot_with_settings
#' @rdname plot_with_settings
#' @export
plot_with_settings_ui <- function(id) {
  checkmate::assert_string(id)

  ns <- NS(id)

  tags$div(
    plot_with_settings_deps(),
    shinyjs::useShinyjs(),
    bslib::card(
      id = ns("plot-with-settings"),
      full_screen = TRUE,
      tags$div(
        tags$div(
          class = "teal-widgets settings-buttons",
          bslib::tooltip(
            trigger = tags$div(
              bslib::popover(
                id = ns("expbut"),
                trigger = icon("maximize"),
                # This should be removed once https://github.com/rstudio/bslib/issues/1326 is fixed
                tags$span(HTML("&nbsp;"), style = "visibility: hidden; height: 0px; display: block;"),
                uiOutput(ns("slider_ui")),
                uiOutput(ns("width_warning"))
              )
            ),
            options = list(trigger = "hover"),
            class = "resize-button",
            "Resize"
          ),
          bslib::tooltip(
            trigger = tags$div(type_download_ui(ns("downbutton"))),
            options = list(trigger = "hover"),
            class = "download-button",
            "Download"
          )
        ),
        tags$div(
          id = ns("plot-out-main"),
          class = "teal-widgets plot-content",
          uiOutput(ns("plot_out_main"))
        )
      )
    )
  )
}

#' Plot-with-settings module
#'
#' @rdname plot_with_settings
#' @description
#' Universal module for plots with settings for height, width, and download.
#'
#' @export
#'
#' @param id (`character(1)`) `shiny` module id.
#'
#' @param plot_r (`reactive` or `function`)\cr
#'  `reactive` expression or a simple `function` to draw a plot.
#'  A simple `function` is needed e.g. for base plots like `plot(1)` as the output can not be caught when downloading.
#'  Take into account that simple functions are less efficient than reactive, as not catching the result.
#' @param height (`numeric`) optional\cr
#'  vector with three elements c(VAL, MIN, MAX), where VAL is the starting value of the slider in
#'  the main and expanded plot display.
#' @param width (`numeric`) optional\cr
#'  vector with three elements `c(VAL, MIN, MAX)`, where VAL is the starting value of the slider in
#'  the main and expanded plot display; `NULL` for default display.
#' @param show_hide_signal optional, (`reactive logical` a mechanism to allow modules which call this
#'     module to show/hide the plot_with_settings UI)
#' @param brushing (`logical`) optional\cr
#'  mechanism to enable / disable brushing on the main plot.
#' All the brushing data is stored as a reactive object in the `"brush"` element of
#'  returned list. See the example for details.
#' @param clicking (`logical`)\cr
#'  a mechanism to enable / disable clicking on data points on the main plot.
#' All the clicking data is stored as a reactive object in the `"click"`
#'  element of returned list. See the example for details.
#' @param dblclicking (`logical`) optional\cr
#'  mechanism to enable / disable double-clicking on data points on the main plot.
#' All the double clicking data is stored as a reactive object in the
#'  the `"dblclick"` element of returned list. See the example for details.
#' @param hovering (`logical(1)`) optional\cr
#'  mechanism to enable / disable hovering over data points on the main plot.
#' All the hovering data is stored as a reactive object in the
#' `"hover"` element of returned list. See the example for details.
#' @param graph_align (`character(1)`) optional,\cr
#'  one of `"left"` (default), `"center"`, `"right"` or `"justify"`. The alignment of the graph on
#'  the main page.
#'
#' @details By default the plot is rendered with `72 dpi`. In order to change this, to for example 96 set
#' `options(teal.plot_dpi = 96)`. The minimum allowed `dpi` value is `24` and it must be a whole number.
#' If an invalid value is set then the default value is used and a warning is outputted to the console.
#'
#' @return A `shiny` module.
#'
#' @examplesIf requireNamespace("lattice", quietly = TRUE)
#' # Example using a reactive as input to plot_r
#' library(shiny)
#' library(ggplot2)
#'
#' ui <- bslib::page_fluid(
#'   plot_with_settings_ui(
#'     id = "plot_with_settings"
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   plot_r <- reactive({
#'     ggplot(faithful, aes(x = .data$waiting, y = .data$eruptions)) +
#'       geom_point()
#'   })
#'
#'   plot_with_settings_srv(
#'     id = "plot_with_settings",
#'     plot_r = plot_r,
#'     height = c(400, 100, 1200),
#'     width = c(500, 250, 750)
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#'
#' # Example using a function as input to plot_r
#' library(lattice)
#'
#' ui <- bslib::page_fluid(
#'   radioButtons("download_option", "Select the Option", list("ggplot", "trellis", "grob", "base")),
#'   plot_with_settings_ui(
#'     id = "plot_with_settings"
#'   ),
#'   sliderInput("nums", "Value", 1, 10, 1)
#' )
#'
#' server <- function(input, output, session) {
#'   plot_r <- function() {
#'     numbers <- seq_len(input$nums)
#'     if (input$download_option == "ggplot") {
#'       ggplot(data.frame(n = numbers), aes(.data$n)) +
#'         geom_bar()
#'     } else if (input$download_option == "trellis") {
#'       densityplot(numbers)
#'     } else if (input$download_option == "grob") {
#'       tr_plot <- densityplot(numbers)
#'       ggplotGrob(
#'         ggplot(data.frame(n = numbers), aes(.data$n)) +
#'           geom_bar()
#'       )
#'     } else if (input$download_option == "base") {
#'       plot(numbers)
#'     }
#'   }
#'
#'   plot_with_settings_srv(
#'     id = "plot_with_settings",
#'     plot_r = plot_r,
#'     height = c(400, 100, 1200),
#'     width = c(500, 250, 750)
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#'
#' # Example with brushing/hovering/clicking/double-clicking
#' ui <- bslib::page_fluid(
#'   plot_with_settings_ui(
#'     id = "plot_with_settings"
#'   ),
#'   fluidRow(
#'     column(4, tags$h3("Brush"), verbatimTextOutput("brushing_data")),
#'     column(4, tags$h3("Click"), verbatimTextOutput("clicking_data")),
#'     column(4, tags$h3("DblClick"), verbatimTextOutput("dblclicking_data")),
#'     column(4, tags$h3("Hover"), verbatimTextOutput("hovering_data"))
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   plot_r <- reactive({
#'     ggplot(faithful, aes(x = .data$waiting, y = .data$eruptions)) +
#'       geom_point()
#'   })
#'
#'   plot_data <- plot_with_settings_srv(
#'     id = "plot_with_settings",
#'     plot_r = plot_r,
#'     height = c(400, 100, 1200),
#'     brushing = TRUE,
#'     clicking = TRUE,
#'     dblclicking = TRUE,
#'     hovering = TRUE
#'   )
#'
#'   output$brushing_data <- renderPrint(plot_data$brush())
#'   output$clicking_data <- renderPrint(plot_data$click())
#'   output$dblclicking_data <- renderPrint(plot_data$dblclick())
#'   output$hovering_data <- renderPrint(plot_data$hover())
#' }
#'
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#'
#' # Example which allows module to be hidden/shown
#' library("shinyjs")
#'
#' ui <- bslib::page_fluid(
#'   useShinyjs(),
#'   actionButton("button", "Show/Hide"),
#'   plot_with_settings_ui(
#'     id = "plot_with_settings"
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   plot_r <- plot_r <- reactive(
#'     ggplot(faithful, aes(x = .data$waiting, y = .data$eruptions)) +
#'       geom_point()
#'   )
#'
#'   show_hide_signal_rv <- reactiveVal(TRUE)
#'
#'   observeEvent(input$button, show_hide_signal_rv(!show_hide_signal_rv()))
#'
#'   plot_with_settings_srv(
#'     id = "plot_with_settings",
#'     plot_r = plot_r,
#'     height = c(400, 100, 1200),
#'     width = c(500, 250, 750),
#'     show_hide_signal = reactive(show_hide_signal_rv())
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#'
plot_with_settings_srv <- function(id,
                                   plot_r,
                                   height = c(600, 200, 2000),
                                   width = NULL,
                                   show_hide_signal = reactive(TRUE),
                                   brushing = FALSE,
                                   clicking = FALSE,
                                   dblclicking = FALSE,
                                   hovering = FALSE,
                                   graph_align = "left") {
  checkmate::assert_string(id)
  checkmate::assert(
    checkmate::check_class(plot_r, "function"),
    checkmate::check_class(plot_r, "reactive")
  )
  checkmate::assert_numeric(height, min.len = 1, any.missing = FALSE)
  checkmate::assert_numeric(height, len = 3, any.missing = FALSE, finite = TRUE)
  checkmate::assert_numeric(height[1], lower = height[2], upper = height[3], .var.name = "height")
  checkmate::assert_numeric(width, len = 3, any.missing = FALSE, null.ok = TRUE, finite = TRUE)
  checkmate::assert_numeric(width[1], lower = width[2], upper = width[3], null.ok = TRUE, .var.name = "width")

  checkmate::assert_class(show_hide_signal, c("reactive", "function"))
  checkmate::assert_flag(brushing)
  checkmate::assert_flag(clicking)
  checkmate::assert_flag(dblclicking)
  checkmate::assert_flag(hovering)
  checkmate::assert_string(graph_align)
  checkmate::assert_subset(graph_align, c("left", "right", "center", "justify"))

  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    shinyjs::runjs(
      sprintf(
        'establishPlotResizing("%s", "%s");',
        ns("plot-out-main"), # graph parent id
        ns("flex_width") # session input$ variable name
      )
    )
    default_w <- function() session$clientData[[paste0("output_", ns("plot_main_width"))]]
    default_h <- function() session$clientData[[paste0("output_", ns("plot_main_height"))]]

    default_slider_width <- reactiveVal(width)
    delayed_flex_width <- debounce(reactive(input$flex_width), millis = 100)

    if (is.null(width)) {
      # if width = NULL then set default_slider_width to be the value of the plot width on load
      observeEvent(session$clientData[[paste0("output_", ns("plot_main_width"))]],
        handlerExpr = {
          default_slider_width(default_w() * c(1, 0.5, 2.8))
        },
        once = TRUE,
        ignoreNULL = TRUE
      )
    }

    plot_type <- reactive({
      if (inherits(plot_r(), "ggplot")) {
        "gg"
      } else if (inherits(plot_r(), "trellis")) {
        "trel"
      } else if (inherits(plot_r(), "grob")) {
        "grob"
      } else if (inherits(plot_r(), c("NULL", "histogram", "list")) && !inherits(plot_r, "reactive")) {
        "base"
      } else {
        "other"
      }
    })

    # allow modules which use this module to turn on and off the UI
    observeEvent(show_hide_signal(), {
      if (show_hide_signal()) {
        shinyjs::show("plot-with-settings")
      } else {
        shinyjs::hide("plot-with-settings")
      }
    })

    output$slider_ui <- renderUI({
      req(default_slider_width())
      tags$div(
        optionalSliderInputValMinMax(
          inputId = ns("height"),
          label = "Plot height",
          value_min_max = round(height),
          ticks = FALSE,
          step = 1L,
          round = TRUE
        ),
        tags$b("Plot width"),
        bslib::input_switch(
          id = ns("width_resize_switch"),
          label = "Automatic",
          value = `if`(is.null(width), TRUE, FALSE)
        ),
        optionalSliderInputValMinMax(
          inputId = ns("width"),
          label = NULL,
          value_min_max = round(isolate(default_slider_width())),
          ticks = FALSE,
          step = 1L,
          round = TRUE
        )
      )
    })

    observeEvent(input$width_resize_switch | delayed_flex_width(), {
      if (!isFALSE(input$width_resize_switch)) {
        shinyjs::disable("width")
        updateSliderInput(session, inputId = "width", value = delayed_flex_width())
      } else {
        shinyjs::enable("width")
      }
    })

    ranges <- reactiveValues(x = NULL, y = NULL)

    observeEvent(input$plot_dblclick, {
      brush <- input$plot_brush
      if (!is.null(brush)) {
        ranges$x <- c(brush$xmin, brush$xmax)
        ranges$y <- c(brush$ymin, brush$ymax)
      } else {
        ranges$x <- NULL
        ranges$y <- NULL
      }
    })

    p_height <- reactive(if (!is.null(input$height)) input$height else height[1])
    p_width <- reactive(
      if (!is.null(input$width)) {
        input$width
      } else {
        if (!is.null(default_slider_width()[1])) {
          default_slider_width()[1]
        } else {
          # Fallback to "auto"
          "auto"
        }
      }
    )
    output$plot_main <- renderPlot(
      apply_plot_modifications(
        plot_obj = plot_r(),
        plot_type = plot_type(),
        dblclicking = dblclicking,
        ranges = ranges
      ),
      res = get_plot_dpi(),
      height = p_height,
      width = p_width
    )

    output$plot_out_main <- renderUI({
      req(plot_r())
      tags$div(
        align = graph_align,
        plotOutput(
          ns("plot_main"),
          height = "100%",
          width = p_width(),
          brush = `if`(brushing, brushOpts(ns("plot_brush"), resetOnNew = FALSE), NULL),
          click = `if`(clicking, clickOpts(ns("plot_click")), NULL),
          dblclick = `if`(dblclicking, dblclickOpts(ns("plot_dblclick")), NULL),
          hover = `if`(hovering, hoverOpts(ns("plot_hover")), NULL)
        )
      )
    })

    output$width_warning <- renderUI({
      grDevices::pdf(nullfile()) # reset Rplots.pdf for shiny server
      w <- grDevices::dev.size("px")[1]
      grDevices::dev.off()
      if (p_width() < w) {
        helpText(
          icon("triangle-exclamation"),
          "Plot might be cut off for small widths."
        )
      }
    })

    type_download_srv(
      id = "downbutton",
      plot_reactive = plot_r,
      plot_type = plot_type,
      plot_w = p_width,
      default_w = default_w,
      plot_h = p_height,
      default_h = default_h
    )

    list(
      brush = reactive({
        # refresh brush data on the main plot size change
        input$height
        input$width
        input$plot_brush
      }),
      click = reactive({
        # refresh click data on the main plot size change
        input$height
        input$width
        input$plot_click
      }),
      dblclick = reactive({
        # refresh double click data on the main plot size change
        input$height
        input$width
        input$plot_dblclick
      }),
      hover = reactive({
        # refresh hover data on the main plot size change
        input$height
        input$width
        input$plot_hover
      }),
      dim = reactive(c(p_width(), p_height()))
    )
  })
}

#' @keywords internal
type_download_ui <- function(id) {
  ns <- NS(id)
  bslib::popover(
    icon("download"),
    tags$div(
      radioButtons(ns("file_format"),
        label = "File type",
        choices = c("png" = "png", "pdf" = "pdf", "svg" = "svg"),
      ),
      textInput(ns("file_name"),
        label = "File name (without extension)",
        value = paste0("plot_", strftime(Sys.time(), format = "%Y%m%d_%H%M%S"))
      ),
      uiOutput(ns("file_name_warning")),
      conditionalPanel(
        condition = paste0("input['", ns("file_name"), "'] != ''"),
        downloadButton(ns("data_download"), label = character(0), class = "btn-sm w-full")
      )
    )
  )
}

#' @keywords internal
type_download_srv <- function(id, plot_reactive, plot_type, plot_w, default_w, plot_h, default_h) {
  moduleServer(
    id,
    function(input, output, session) {
      file_name_valid <- file_name_validation_srv(input, output)

      output$data_download <- downloadHandler(
        filename = function() {
          paste(input$file_name, input$file_format, sep = ".")
        },
        content = function(file) {
          width <- `if`(!is.null(plot_w()), plot_w(), default_w())
          height <- `if`(!is.null(plot_h()), plot_h(), default_h())

          # svg and pdf have width in inches and 1 inch = get_plot_dpi() pixels
          switch(input$file_format,
            png = grDevices::png(file, width, height),
            pdf = grDevices::pdf(file, width / get_plot_dpi(), height / get_plot_dpi()),
            svg = grDevices::svg(file, width / get_plot_dpi(), height / get_plot_dpi())
          )

          print_plot(plot_reactive, plot_type)

          grDevices::dev.off()
        }
      )
    }
  )
}

#' Clean brushed points
#'
#' @description
#' Cleans and organizes output to account for NAs and remove empty rows. Wrapper around `shiny::brushedPoints`.
#' @param data (`data.frame`)\cr
#'  A data.frame from which to select rows.
#' @param brush (`list`)\cr
#'  The data from a brush e.g. `input$plot_brush`.
#'
#' @return A `data.frame` of selected rows.
#'
#' @examples
#'
#' brush <- list(
#'   mapping = list(
#'     x = "AGE",
#'     y = "BMRKR1"
#'   ),
#'   xmin = 30, xmax = 40,
#'   ymin = 0.7, ymax = 10,
#'   direction = "xy"
#' )
#'
#' data <- data.frame(
#'   STUDYID = letters[1:20],
#'   USUBJID = LETTERS[1:20],
#'   AGE = sample(25:40, size = 20, replace = TRUE),
#'   BMRKR1 = runif(20, min = 0, max = 12)
#' )
#' nrow(clean_brushedPoints(data, brush))
#' data$AGE[1:10] <- NA
#' nrow(clean_brushedPoints(data, brush))
#'
#' @export
#'
clean_brushedPoints <- function(data, brush) { # nolint object_name_linter.
  checkmate::assert_data_frame(data)
  checkmate::assert_list(brush, null.ok = TRUE)

  # define original panelvar1 and panelvar2 before getting overwritten
  original_panelvar1 <- brush$mapping$panelvar1
  original_panelvar2 <- brush$mapping$panelvar2

  # Assign NULL to `mapping$panelvar1` and `mapping$panelvar1` if `brush$panelvar1` and `brush$panelvar1` are NULL
  # This will not evaluate the `panelMatch` step in `brushedPoints` and thus will return a non empty dataframe
  if (is.null(brush$panelvar1)) brush$mapping$panelvar1 <- NULL
  if (is.null(brush$panelvar2)) brush$mapping$panelvar2 <- NULL

  bp_df <- brushedPoints(data, brush)

  # Keep required rows only based on the value of `brush$panelvar1`
  df <- if (is.null(brush$panelvar1) && is.character(original_panelvar1) &&
    is.null(brush$panelvar2) && is.character(original_panelvar2)) {
    df_var1 <- bp_df[is.na(bp_df[[original_panelvar1]]), ]
    df_var1[is.na(df_var1[[original_panelvar2]]), ]
  } else if (is.null(brush$panelvar1) && is.character(original_panelvar1)) {
    bp_df[is.na(bp_df[[original_panelvar1]]), ]
  } else if (is.null(brush$panelvar2) && is.character(original_panelvar2)) {
    bp_df[is.na(bp_df[[original_panelvar2]]), ]
  } else {
    bp_df
  }

  # filter out rows that are only NAs
  df <- df[rowSums(is.na(df)) != ncol(df), ]
  df
}

#' @keywords internal
#'
get_plot_dpi <- function() {
  default_dpi <- 72
  dpi <- getOption("teal.plot_dpi", default_dpi)
  if (!checkmate::test_integerish(dpi, lower = 24, any.missing = FALSE, len = 1)) {
    warning(paste("Invalid value for option 'teal.plot_dpi', therefore defaulting to", default_dpi, "dpi"))
    dpi <- default_dpi
  }
  dpi
}

#' Print plot for download functionality
#'
#' @param plot (`reactive`)\cr
#'  reactive expression to draw a plot
#' @param plot_type (`reactive`)\cr
#'  reactive plot type (`gg`, `trel`, `grob`, `other`)
#'
#' @return Nothing returned, the plot is printed.
#' @keywords internal
#'
print_plot <- function(plot, plot_type) {
  switch(plot_type(),
    "grob" = grid::grid.draw(plot()),
    "other" = {
      graphics::plot.new()
      graphics::text(
        x = graphics::grconvertX(0.5, from = "npc"),
        y = graphics::grconvertY(0.5, from = "npc"),
        labels = "This plot graphic type is not yet supported to download"
      )
    },
    "base" = plot(),
    print(plot())
  )
}
