#' @keywords internal
#' @noRd
verbatim_popup_deps <- function() {
  htmltools::htmlDependency(
    name = "teal-widgets-verbatim-popup",
    version = utils::packageVersion("teal.widgets"),
    package = "teal.widgets",
    src = "verbatim-popup",
    stylesheet = "verbatim-popup.css",
    script = "verbatim-popup.js"
  )
}

#' A `shiny` module that pops up verbatim text.
#' @name verbatim_popup
#' @description
#' This module consists of a button that once clicked pops up a
#' modal window with verbatim-styled text.
#'
#' @param id (`character(1)`) the `shiny` id
#' @param button_label (`character(1)`) the text printed on the button
#' @param type (`character(1)`) specifying whether to use `[shiny::actionButton()]` or `[shiny::actionLink()]`.
#' @param ... additional arguments to `[shiny::actionButton()]`(or `[shiny::actionLink()]`).
#'
#' @return the UI function returns a `shiny.tag.list` object
#' @export
#'
#' @examples
#' library(shiny)
#'
#' ui <- bslib::page_fluid(verbatim_popup_ui("my_id", button_label = "Open popup"))
#' srv <- function(input, output) {
#'   verbatim_popup_srv(
#'     "my_id",
#'     "if (TRUE) { print('Popups are the best') }",
#'     title = "My custom title",
#'     style = TRUE
#'   )
#' }
#' if (interactive()) shinyApp(ui, srv)
#'
verbatim_popup_ui <- function(id, button_label, type = c("button", "link"), ...) {
  checkmate::assert_string(id)
  checkmate::assert_string(button_label)

  ns <- shiny::NS(id)

  shiny::tagList(
    verbatim_popup_deps(),
    shinyjs::useShinyjs(),
    shiny::actionButton(
      inputId = ns("button"),
      label = button_label,
      class = c("teal-widgets-busy-disable", match.arg(type)),
      ...
    )
  )
}

#' @name verbatim_popup
#' @export
#'
#' @param verbatim_content (`character`, `expression`, `condition` or `reactive(1)`
#' holding any of the above) the content to show in the popup modal window
#' @param title (`character(1)`) the title of the modal window
#' @param style (`logical(1)`) whether to style the `verbatim_content` using `styler::style_text`.
#' If `verbatim_content` is a `condition` or `reactive` holding `condition` then this argument is ignored
#' @param disabled (`reactive(1)`) the `shiny` reactive value holding a `logical`. The popup button is disabled
#' when the flag is `TRUE` and enabled otherwise.
#'
verbatim_popup_srv <- function(id, verbatim_content, title, style = FALSE, disabled = shiny::reactiveVal(FALSE)) {
  checkmate::assert_string(id)
  checkmate::assert_string(title)
  checkmate::assert_flag(style)
  checkmate::assert_class(disabled, classes = "reactive")
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    button_click_observer(
      click_event = shiny::reactive(input$button),
      copy_button_id = ns("copy_button"),
      copied_area_id = ns("verbatim_content"),
      modal_title = title,
      modal_content = format_content(verbatim_content, style),
      disabled = disabled
    )
  })
}

#' Creates a `shiny` observer handling button clicks.
#'
#' @description
#' When the button is clicked it pop up a modal window with the text.
#'
#' @keywords internal
#' @param click_event `reactive` the click event
#' @param copy_button_id (`character(1)`) the id of the button to copy the modal content.
#' Automatically appended with a 1 and 2 suffix for top and bottom buttons respectively.
#' @param copied_area_id (`character(1)`) the id of the element which contents are copied
#' @param modal_title (`character(1)`) the title of the modal window
#' @param modal_content (`reactive`) the content of the modal window
#' @param disabled (`reactive(1)`) the `shiny` reactive value holding a `logical`. The popup button is disabled
#' when the flag is `TRUE` and enabled otherwise.
button_click_observer <- function(click_event,
                                  copy_button_id,
                                  copied_area_id,
                                  modal_title,
                                  modal_content,
                                  disabled) {
  shiny::observeEvent(
    disabled(),
    handlerExpr = {
      if (disabled()) {
        shinyjs::disable("button")
      } else {
        shinyjs::enable("button")
      }
    }
  )

  shiny::observeEvent(
    click_event(),
    handlerExpr = {
      modal_content <- req(modal_content())
      shiny::showModal(
        div(
          class = "teal-widgets button-click-observer",
          shiny::modalDialog(
            tags$div(
              tags$div(
                shiny::modalButton("Dismiss"),
                shiny::actionButton(
                  paste0(copy_button_id, 1),
                  "Copy to Clipboard",
                  class = "btn-primary",
                  onclick = paste0("copyToClipboard('", copied_area_id, "')")
                )
              ),
              tags$pre(id = copied_area_id, modal_content),
            ),
            title = modal_title,
            footer = shiny::tagList(
              shiny::modalButton("Dismiss"),
              shiny::actionButton(
                paste0(copy_button_id, 2),
                "Copy to Clipboard",
                class = "btn-primary",
                onclick = paste0("copyToClipboard('", copied_area_id, "')")
              )
            ),
            size = "l",
            easyClose = TRUE
          )
        )
      )
    }
  )
}

#' Formats the content of the modal popup window.
#'
#' @details
#' Formats the content:
#' * concatenates if needed
#' * styles if `style` is TRUE
#'
#' @keywords internal
#' @inheritParams verbatim_popup
#' @return `reactive` with the formatted content
format_content <- function(verbatim_content, style = FALSE) {
  shiny::reactive({
    content <- if (inherits(verbatim_content, "reactive")) {
      tryCatch(
        verbatim_content(),
        error = function(e) {
          e
        }
      )
    } else {
      verbatim_content
    }
    shiny::validate(shiny::need(
      checkmate::test_multi_class(content, classes = c("expression", "character", "condition")),
      "verbatim_content should be an expression, character or condition"
    ))

    is_condition <- checkmate::test_class(content, "condition")
    content <- paste(as.character(content), collapse = "\n")

    if (style && !is_condition) {
      content <- paste(styler::style_text(content), collapse = "\n")
    }
    content
  })
}
