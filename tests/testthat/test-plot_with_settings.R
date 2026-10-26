testthat::test_that("if teal.plot_dpi is not set then get_plot_dpi returns 72 ", {
  withr::with_options(
    list(teal.plot_dpi = NULL),
    testthat::expect_equal(get_plot_dpi(), 72)
  )
})

testthat::test_that("if teal.plot_dpi is an integer value at least 24 then get_plot_dpi returns its value", {
  withr::with_options(
    list(teal.plot_dpi = 24),
    testthat::expect_equal(get_plot_dpi(), 24)
  )
  withr::with_options(
    list(teal.plot_dpi = 48),
    testthat::expect_equal(get_plot_dpi(), 48)
  )
  withr::with_options(
    list(teal.plot_dpi = 72),
    testthat::expect_equal(get_plot_dpi(), 72)
  )
  withr::with_options(
    list(teal.plot_dpi = 96),
    testthat::expect_equal(get_plot_dpi(), 96)
  )
})

testthat::test_that("if teal.plot_dpi is an integer value less 24 then get_plot_dpi returns 72", {
  testthat::expect_warning(
    withr::with_options(
      list(teal.plot_dpi = 23),
      testthat::expect_equal(get_plot_dpi(), 72)
    ),
    "teal.plot_dpi"
  )
  testthat::expect_warning(
    withr::with_options(
      list(teal.plot_dpi = 0),
      testthat::expect_equal(get_plot_dpi(), 72)
    ),
    "teal.plot_dpi"
  )
})

testthat::test_that("if teal.plot_dpi is not an integer value then get_plot_dpi returns 72", {
  testthat::expect_warning(
    withr::with_options(
      list(teal.plot_dpi = c(72, 96)),
      testthat::expect_equal(get_plot_dpi(), 72)
    ),
    "teal.plot_dpi"
  )

  testthat::expect_warning(
    withr::with_options(
      list(teal.plot_dpi = "foo"),
      testthat::expect_equal(get_plot_dpi(), 72)
    ),
    "teal.plot_dpi"
  )
})

plot_funs <- list(
  function() {
    print(ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_point())
  },
  function() {
    testthat::skip_if_not_installed("lattice")
    lattice::densityplot(1)
  },
  function() {
    ggplot2::ggplotGrob(
      ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_point()
    )
  },
  function() plot(1),
  function() boxplot(2),
  function() 2
)
plot_types <- list(
  function() "gg",
  function() "trel",
  function() "grob",
  function() "base",
  function() "base",
  function() "other"
)

testthat::test_that("print_plot is able to plot different types of graphics", {
  for (p in seq_along(plot_funs)) {
    testthat::expect_true(
      is_draw(function() print_plot(plot_funs[[p]], plot_types[[p]]))
    )
  }
})

data <- structure(
  list(
    STUDYID = structure(c(
      "AB12345", "AB12345", "AB12345",
      "AB12345", "AB12345", "AB12345", "AB12345", "AB12345", "AB12345",
      "AB12345", "AB12345", "AB12345", "AB12345", "AB12345", "AB12345",
      "AB12345", "AB12345", "AB12345", "AB12345", "AB12345"
    ), label = "Study Identifier"),
    USUBJID = structure(c(
      "AB12345-CHN-3-id-128", "AB12345-CHN-15-id-262",
      "AB12345-RUS-3-id-378", "AB12345-CHN-11-id-220", "AB12345-CHN-7-id-267",
      "AB12345-CHN-15-id-201", "AB12345-USA-1-id-45", "AB12345-USA-1-id-261",
      "AB12345-NGA-11-id-173", "AB12345-CHN-1-id-307", "AB12345-CHN-7-id-28",
      "AB12345-CHN-4-id-73", "AB12345-RUS-1-id-52", "AB12345-PAK-11-id-268",
      "AB12345-CHN-13-id-102", "AB12345-CHN-17-id-84", "AB12345-BRA-11-id-9",
      "AB12345-CHN-4-id-115", "AB12345-CHN-15-id-245", "AB12345-CHN-4-id-370"
    ), label = "Unique Subject Identifier"),
    AGE = structure(c(
      40L, 24L, 40L, 28L, 37L,
      40L, 40L, 38L, 34L, 45L, 40L, 24L, 40L, 28L, 37L,
      40L, 40L, 38L, 34L, 45L
    ), label = "Age"),
    BMRKR1 = structure(c(
      14.424933692778,
      4.05546277230382, 2.80323956920649, 10.2627340069523, 6.2067627167943,
      6.9067988141075, 0.463560441314472, 2.85516419937308, 4.99722573047567,
      4.57499101339464, 11.1444469908374, 2.86312402599659, 7.20634823208459,
      2.82014082273392, 6.04894627754598, 6.61366727233138, 7.01629609277248,
      9.00518541690504, 3.68284941334409, 7.09845214575852
    ), label = "Continuous Level Biomarker 1")
  ),
  row.names = c(NA, -20L),
  label = "Subject Level Analysis Dataset",
  "`creation date`" = structure(19307, class = "Date"),
  class = c("tbl_df", "tbl", "data.frame")
)


brush <- list(
  xmin = 30.461738950382, xmax = 41.763695852997, ymin = 0.73077938561424, ymax = 10.23846022551,
  coords_css = list(
    xmin = 511.458312988281,
    xmax = 1231.45831298828, ymin = 195.642349243164, ymax = 535.642349243164
  ),
  coords_img = list(
    xmin = 460.312444477212, xmax = 1108.31239209208,
    ymin = 176.078114318848, ymax = 482.078114318848
  ),
  img_css_ratio = list(
    x = 0.899999927242866, y = 0.9
  ),
  mapping = list(
    x = "AGE",
    y = "BMRKR1"
  ),
  domain = list(
    left = 22.95, right = 46.05,
    bottom = -0.234508221258705, top = 15.1230023553512
  ),
  range = list(
    left = 29.6253972440434, right = 1354.06849315068,
    bottom = 513.145417973348, top = 18.8715445043173
  ),
  log = list(
    x = NULL, y = NULL
  ),
  direction = "xy",
  brushId = "teal-main_ui-root-scatterplot_choices-scatter_plot-plot_brush",
  outputId = "teal-main_ui-root-scatterplot_choices-scatter_plot-plot_main"
)

testthat::test_that("clean_brushedPoints returns error with wrong input", {
  testthat::expect_error(clean_brushedPoints())
  testthat::expect_error(clean_brushedPoints(2, list()))
  testthat::expect_error(clean_brushedPoints(data.frame(), list()))
})

testthat::test_that("clean_brushedPoints returns a data frame with minimal correct input", {
  testthat::expect_no_error(
    clean_brushedPoints(
      data.frame(AGE = 1, BMRKR1 = 4),
      brush[c("direction", "range", "xmin", "xmax", "ymin", "ymax", "mapping")]
    )
  )
})

testthat::test_that("clean_brushedPoints removal of NA points", {
  testthat::expect_identical(nrow(data), 20L)
  testthat::expect_identical(nrow(clean_brushedPoints(data, brush)), 11L)
  data$AGE[1:10] <- NA
  testthat::expect_identical(nrow(clean_brushedPoints(data, brush)), 6L)
})

download_srv_args <- list(
  id = "STH",
  plot_reactive = function() plot(1),
  plot_type = function() "base",
  plot_w = function() 250,
  default_w = function() 300,
  plot_h = function() 200,
  default_h = function() 300
)

testthat::test_that("type_download_srv download all types of files with default name", {
  shiny::testServer(
    teal.widgets:::type_download_srv,
    args = download_srv_args,
    expr = {
      for (type in c("png", "pdf", "svg")) {
        session$setInputs(`file_format` = type)
        session$setInputs(`data_download` = 1)
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_identical(
          basename(output$data_download),
          paste0(".", type)
        )
      }
    }
  )
})

testthat::test_that("type_download_srv download all types of files and change the name", {
  shiny::testServer(
    teal.widgets:::type_download_srv,
    args = download_srv_args,
    expr = {
      for (type in c("png", "pdf", "svg")) {
        session$setInputs(`file_format` = type)
        session$setInputs(`data_download` = 1)
        session$setInputs(`file_name` = "RANDOM_NAME")
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_identical(
          basename(output$data_download),
          paste0("RANDOM_NAME.", type)
        )
      }
    }
  )
})

testthat::test_that("type_download_srv downloads a png file with different dimensions", {
  testthat::skip_if_not_installed("png")

  shiny::testServer(
    teal.widgets:::type_download_srv,
    args = download_srv_args,
    expr = {
      session$setInputs(`file_name` = "testplot")
      session$setInputs(`file_format` = "png")
      session$setInputs(`data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$data_download, info = TRUE), "info")$dim,
        c(250L, 200L)
      )
    }
  )
})

testthat::test_that("type_download_srv downloads a png file using default dimensions input dimensions are NULL", {
  testthat::skip_if_not_installed("png")

  shiny::testServer(
    teal.widgets:::type_download_srv,
    args = list(
      id = "STH",
      plot_reactive = function() plot(1),
      plot_type = function() "base",
      plot_w = function() NULL,
      default_w = function() 350,
      plot_h = function() NULL,
      default_h = function() 300
    ),
    expr = {
      session$setInputs(`file_name` = "testplot")
      session$setInputs(`file_format` = "png")
      session$setInputs(`data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$data_download, info = TRUE), "info")$dim,
        c(350L, 300L)
      )
    }
  )
})

testthat::test_that("type_download_srv: warns about non-meaningful file names", {
  shiny::testServer(
    teal.widgets:::type_download_srv,
    args = download_srv_args,
    expr = {
      for (bad in c("        ", "_-!@#$%^&", "....", "")) {
        session$setInputs(file_name = bad)
        testthat::expect_false(file_name_valid())
        testthat::expect_match(as.character(output$file_name_warning$html), "meaningful file name")
      }
      for (good in c("df", "testplot")) {
        session$setInputs(file_name = good)
        testthat::expect_true(file_name_valid())
        testthat::expect_null(output$file_name_warning)
      }
    }
  )
})

testthat::test_that("plot_with_settings_srv assert error", {
  args <- list(
    list(id = "STH", plot_r = function() plot(1), height = "20"),
    list(id = "STH", plot_r = function() plot(1), width = c(20, 100, 200)),
    list(id = "STH", plot_r = NULL),
    list(id = "STH", plot_r = function() plot(1), hovering = 20),
    list(id = "STH", plot_r = function() plot(1), clicking = 20),
    list(id = "STH", plot_r = function() plot(1), dblclicking = 20),
    list(id = "STH", plot_r = function() plot(1), brushing = 20),
    list(id = "STH", plot_r = function() plot(1), show_hide_signal = TRUE),
    list(id = "STH", plot_r = function() plot(1), graph_align = "centery")
  )

  for (arg in args) {
    testthat::expect_error(
      shiny::testServer(
        teal.widgets:::plot_with_settings_srv,
        args = arg
      ),
      "Assertion"
    )
  }
})

plot_with_settings_args <- list(
  id = "STH",
  plot_r = NULL,
  height = c(450, 200, 2000),
  width = c(450, 200, 2000),
  show_hide_signal = reactive(TRUE),
  brushing = FALSE,
  clicking = FALSE,
  dblclicking = FALSE,
  hovering = FALSE,
  graph_align = "left"
)

testthat::test_that("plot_with_settings_srv set dimensions and download a png file - base", {
  testthat::skip_if_not_installed("png")

  plot_with_settings_args$plot_r <- function() plot(1)
  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      session$setInputs(`width` = 300L)
      session$setInputs(`height` = 350L)
      testthat::expect_identical(
        c(output$plot_main$width, output$plot_main$height),
        c(300L, 350L)
      )
      session$setInputs(`downbutton-file_format` = "png")
      session$setInputs(`downbutton-data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$`downbutton-data_download`, info = TRUE), "info")$dim,
        c(300L, 350L)
      )
    }
  )
})

testthat::test_that("plot_with_settings_srv set dimensions and download a png file - ggplot2", {
  testthat::skip_if_not_installed("png")

  plot_with_settings_args$plot_r <- function() {
    ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
      ggplot2::geom_line()
  }
  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      session$setInputs(`width` = 300L)
      session$setInputs(`height` = 350L)
      testthat::expect_identical(
        c(output$plot_main$width, output$plot_main$height),
        c(300L, 350L)
      )
      session$setInputs(`downbutton-file_format` = "png")
      session$setInputs(`downbutton-data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$`downbutton-data_download`, info = TRUE), "info")$dim,
        c(300L, 350L)
      )
    }
  )
})

testthat::test_that("plot_with_settings_srv set dimensions and download a png file - grob", {
  testthat::skip_if_not_installed("png")

  plot_with_settings_args$plot_r <- function() {
    ggplot2::ggplotGrob(
      ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
        ggplot2::geom_line()
    )
  }
  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      session$setInputs(`width` = 300L)
      session$setInputs(`height` = 350L)
      testthat::expect_identical(
        c(output$plot_main$width, output$plot_main$height),
        c(300L, 350L)
      )
      session$setInputs(`downbutton-file_format` = "png")
      session$setInputs(`downbutton-data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$`downbutton-data_download`, info = TRUE), "info")$dim,
        c(300L, 350L)
      )
    }
  )
})

testthat::test_that("plot_with_settings_srv set dimensions and download a png file - trellis", {
  testthat::skip_if_not_installed("png")
  testthat::skip_if_not_installed("lattice")

  plot_with_settings_args$plot_r <- function() {
    lattice::densityplot(1)
  }
  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      session$setInputs(`width` = 300L)
      session$setInputs(`height` = 350L)
      testthat::expect_identical(
        c(output$plot_main$width, output$plot_main$height),
        c(300L, 350L)
      )
      session$setInputs(`downbutton-file_format` = "png")
      session$setInputs(`downbutton-data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$`downbutton-data_download`, info = TRUE), "info")$dim,
        c(300L, 350L)
      )
    }
  )
})

testthat::test_that("plot_with_settings_srv set dimensions and download a png file - WRONG type", {
  testthat::skip_if_not_installed("png")

  plot_with_settings_args$plot_r <- function() 2

  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      session$setInputs(`width` = 300L)
      session$setInputs(`height` = 350L)
      testthat::expect_identical(
        c(output$plot_main$width, output$plot_main$height),
        c(300L, 350L)
      )
      session$setInputs(`downbutton-file_format` = "png")
      session$setInputs(`downbutton-data_download` = 1)
      testthat::expect_identical(
        attr(png::readPNG(output$`downbutton-data_download`, info = TRUE), "info")$dim,
        c(300L, 350L)
      )
    }
  )
})

testthat::test_that("plot_with_settings_srv expand no error", {
  plot_with_settings_args[["plot_r"]] <- function() plot(1)
  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      session$setInputs(`expand` = TRUE)
      testthat::expect_silent(output$plot_main)
    }
  )
})


testthat::test_that("plot_with_settings_srv returns the click ggplot2 functionalities metadata", {
  plot_with_settings_args$plot_r <- function() plot(1)
  shiny::testServer(
    teal.widgets:::plot_with_settings_srv,
    args = plot_with_settings_args,
    expr = {
      # they are turned off but setInputs is still working
      session$setInputs(`plot_hover` = "SOMETHING")
      session$setInputs(`plot_dblclick` = "SOMETHING")
      session$setInputs(`plot_click` = "SOMETHING")
      session$setInputs(`plot_brush` = "SOMETHING")
      testthat::expect_identical(session$returned$brush(), "SOMETHING")
      testthat::expect_identical(session$returned$hover(), "SOMETHING")
      testthat::expect_identical(session$returned$click(), "SOMETHING")
      testthat::expect_identical(session$returned$dblclick(), "SOMETHING")
    }
  )
})
