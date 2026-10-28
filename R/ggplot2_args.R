#' Creates `ggplot2_args` object
#'
#' @description
#' Constructor of `ggplot2_args` class of objects.
#' The `ggplot2_args` argument should be a part of every module which contains any `ggplot2` graphics.
#' The function arguments are validated to match their `ggplot2` equivalents.
#'
#' For more details see the vignette: `vignette("custom-ggplot2-arguments", package = "teal.widgets")`.
#'
#' @seealso
#' * [resolve_ggplot2_args()] to resolve multiple objects into one using pre-defined priorities.
#' * [parse_ggplot2_args()] to parse resolved list into list of calls.
#'
#' @param labs (named `list`)\cr
#'  where all fields have to match [ggplot2::labs()] arguments.
#' @param theme (named `list`)\cr
#'  where all fields have to match [ggplot2::theme()] arguments.
#'
#' @return (`ggplot2_args`) object.
#' @export
#' @examples
#' ggplot2_args(
#'   labs = list(title = "TITLE"),
#'   theme = list(title = ggplot2::element_text(size = 20))
#' )
ggplot2_args <- function(labs = list(), theme = list()) {
  checkmate::assert_list(labs)
  checkmate::assert_list(theme)
  checkmate::assert_character(names(labs), unique = TRUE, null.ok = TRUE)
  checkmate::assert_character(names(theme), unique = TRUE, null.ok = TRUE)

  ggplot2_theme <- methods::formalArgs(ggplot2::theme)
  # utils::getFromNamespace is not recommended nevertheless needed as it is replacing `:::`.
  # usage of static values will be vulnerable to any changes in ggplot2 aesthetics.
  ggplot2_labs <- c(
    utils::getFromNamespace(".all_aesthetics", "ggplot2"),
    methods::formalArgs(ggplot2::labs)
  )
  checkmate::assert_subset(names(labs), choices = ggplot2_labs, empty.ok = TRUE)
  checkmate::assert_subset(names(theme), choices = ggplot2_theme, empty.ok = TRUE)

  structure(list(labs = labs, theme = theme), class = "ggplot2_args")
}

#' Resolving and reducing multiple `ggplot2_args` objects
#'
#' @description
#' Resolving and reducing multiple `ggplot2_args` objects.
#' This function is intended to utilize user provided settings, defaults provided by the module creator and
#' also `teal` option. See `Details`, below, to understand the logic.
#'
#' @seealso [parse_ggplot2_args()] to parse resolved list into list of calls.
#'
#' @param user_plot (`ggplot2_args`)\cr
#'  end user setup for theme and labs in the specific plot.
#'  Created with the [ggplot2_args()] function. The `NULL` value is supported.
#' @param user_default (`ggplot2_args`)\cr
#'  end user setup for module default theme and labs.
#'  Created with the [ggplot2_args()] function. The `NULL` value is supported.
#' @param module_plot (`ggplot2_args`)\cr
#'  module creator setup for theme and labs in the specific plot.
#'  Created with the [ggplot2_args()] function. The `NULL` value is supported.
#' @param app_default (`ggplot2_args`)\cr
#'  Application level setting. Can be `NULL`.
#'
#' @return `ggplot2_args` object.
#'
#' @details
#' The function picks the first non `NULL` value for each argument, checking in the following order:
#' 1. `ggplot2_args` argument provided by the end user.
#' Per plot (`user_plot`) and then default (`user_default`) setup.
#' 2. `app_default` global R variable, `teal.ggplot2_args`.
#' 3. `module_plot` which is a module creator setup.
#' @export
#' @examples
#' resolve_ggplot2_args(
#'   user_plot = ggplot2_args(
#'     labs = list(title = "TITLE"),
#'     theme = list(title = ggplot2::element_text(size = 20))
#'   ),
#'   user_default = ggplot2_args(
#'     labs = list(x = "XLAB")
#'   )
#' )
resolve_ggplot2_args <- function(user_plot = ggplot2_args(),
                                 user_default = ggplot2_args(),
                                 module_plot = ggplot2_args(),
                                 app_default = getOption("teal.ggplot2_args", ggplot2_args())) {
  checkmate::assert_class(user_plot, "ggplot2_args", null.ok = TRUE)
  checkmate::assert_class(user_default, "ggplot2_args", null.ok = TRUE)
  checkmate::assert_class(module_plot, "ggplot2_args", null.ok = TRUE)
  checkmate::assert_class(app_default, "ggplot2_args", null.ok = TRUE)

  ggplot2_args_all <- list(
    "plot" = user_plot,
    "default" = user_default,
    "teal" = app_default,
    "module" = module_plot
  )

  labs_args <- Reduce(`c`, lapply(ggplot2_args_all, function(x) x$labs))
  labs_args <- if (is.null(labs_args)) list() else labs_args[!duplicated(names(labs_args))]

  theme_args <- Reduce(`c`, lapply(ggplot2_args_all, function(x) x$theme))
  theme_args <- if (is.null(theme_args)) list() else theme_args[!duplicated(names(theme_args))]

  ggplot2_args(labs = labs_args, theme = theme_args)
}

#' Parse `ggplot2_args` object into the `ggplot2` expression
#'
#' @description
#' A function to parse expression from the `ggplot2_args` object.
#' @param ggplot2_args (`ggplot2_args`)\cr
#'  This argument could be a result of the [resolve_ggplot2_args()].
#' @param ggtheme (`character(1)`)\cr
#'  name of the `ggplot2` theme to be applied, e.g. `"dark"`.
#'
#' @return (`list`) of up to three elements of class `languange`: `"labs"`, `"ggtheme"` and `"theme"`.
#' @export
#' @examples
#' parse_ggplot2_args(
#'   resolve_ggplot2_args(ggplot2_args(
#'     labs = list(title = "TITLE"),
#'     theme = list(title = ggplot2::element_text(size = 20))
#'   ))
#' )
#'
#' parse_ggplot2_args(
#'   resolve_ggplot2_args(
#'     ggplot2_args(
#'       labs = list(title = "TITLE"),
#'       theme = list(title = ggplot2::element_text(size = 20))
#'     )
#'   ),
#'   ggtheme = "gray"
#' )
parse_ggplot2_args <- function(ggplot2_args = teal.widgets::ggplot2_args(),
                               ggtheme = c(
                                 "default",
                                 "gray",
                                 "bw",
                                 "linedraw",
                                 "light",
                                 "dark",
                                 "minimal",
                                 "classic",
                                 "void",
                                 "test"
                               )) {
  checkmate::assert_class(ggplot2_args, "ggplot2_args")
  ggtheme <- match.arg(ggtheme)

  res_list <- list()

  labs_args <- ggplot2_args$labs

  labs_f <- if (length(labs_args)) {
    as.call(c(list(quote(ggplot2::labs)), labs_args))
  } else {
    NULL
  }

  default_theme <- if (ggtheme != "default") {
    as.call(list(str2lang(paste0("ggplot2::theme_", ggtheme))))
  } else {
    NULL
  }

  theme_args <- lapply(ggplot2_args$theme, theme_value_as_call)

  theme_f <- if (length(theme_args)) {
    as.call(c(list(quote(ggplot2::theme)), theme_args))
  } else {
    NULL
  }

  final_list <- Filter(Negate(is.null), list(labs = labs_f, ggtheme = default_theme, theme = theme_f))
  # For empty final_list we want to return empty list, not empty named list
  `if`(length(final_list) == 0, list(), final_list)
}

#' @noRd
theme_value_as_call <- function(value) {
  if (!inherits(value, "S7_object")) {
    return(value)
  }
  if (inherits(value, "ggplot2::margin")) {
    return(as.call(c(
      list(quote(ggplot2::margin)),
      as.list(as.numeric(value)),
      list(unit = grid::unitType(value)[1])
    )))
  }
  constructor <- str2lang(class(value)[1])
  constructor_args <- names(formals(eval(constructor)))
  properties <- getExportedValue("S7", "props")(value)
  properties <- properties[intersect(names(properties), constructor_args)]
  properties <- Filter(Negate(is.null), lapply(properties, theme_value_as_call))
  as.call(c(list(constructor), properties))
}
