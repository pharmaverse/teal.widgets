table_r <- shiny::reactive({
  l <- rtables::basic_table() %>%
    rtables::split_cols_by("Species") %>%
    rtables::analyze("Sepal.Length")
  rtables::build_table(l, iris)
})

testthat::test_that("table_with_settings_srv: assertions", {
  args <- list(
    list(table_r = "er"),
    list(show_hide_signal = TRUE, table_r = table_r)
  )
  for (arg in args) {
    testthat::expect_error(
      shiny::testServer(
        teal.widgets::table_with_settings_srv,
        args = arg
      ),
      "Assertion"
    )
  }
})

# warning is expected to be thrown once per session, so we disable it for testing in this test file
withr::local_envvar(DISABLE_GT_WEBSHOT2_WARNING = "true")

testthat::test_that("table_with_settings_srv: hiding works", {
  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(table_r = table_r, show_hide_signal = reactive(FALSE)),
    expr = {
      testthat::expect_silent(output$table_out_modal$html)
    }
  )
})

testthat::test_that("table_with_settings_srv: return html table with content", {
  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(id = "tws", table_r = table_r),
    expr = {
      html_content <- as.character(output$table_out_main$html)
      testthat::expect_s3_class(output$table_out_main$html, "html")
      testthat::expect_true(grepl("Species|setosa|versicolor|virginica", html_content, ignore.case = TRUE))
      testthat::expect_true(grepl("Mean|5\\.0", html_content))
    }
  )
})

testthat::test_that("table_with_settings_srv: expand works", {
  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(id = "tws", table_r = table_r),
    expr = {
      session$setInputs(`expand` = TRUE)
      testthat::expect_silent(output$table_out_modal)
    }
  )
})

testthat::test_that("type_download_srv_table: downloading different output types, custom name", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = table_r),
    expr = {
      for (down_type in c(".txt", ".csv", ".pdf")) {
        session$setInputs(`pagination_switch` = FALSE)
        session$setInputs(`file_name` = "testtable")
        session$setInputs(`file_format` = down_type)
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_equal(
          basename(output$data_download),
          paste0("testtable", down_type)
        )
      }
    }
  )
})

testthat::test_that("type_download_srv_table: downloading different output types, no name", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = table_r),
    expr = {
      for (down_type in c(".txt", ".csv", ".pdf")) {
        session$setInputs(`pagination_switch` = FALSE)
        session$setInputs(`file_format` = down_type)
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_equal(
          basename(output$data_download), paste0(down_type)
        )
      }
    }
  )
})

testthat::test_that("type_download_srv_table: downloading different output types, pagination", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = table_r),
    expr = {
      for (down_type in c(".txt", ".csv", ".pdf")) {
        session$setInputs(`pagination_switch` = TRUE)
        session$setInputs(`lpp` = 10)
        session$setInputs(`file_name` = "testtable")
        session$setInputs(`file_format` = down_type)
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_equal(
          basename(output$data_download),
          paste0("testtable", down_type)
        )
      }
    }
  )
})

testthat::test_that("type_download_srv_table: pagination, lpp to small", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = table_r),
    expr = {
      for (down_type in c(".txt", ".pdf")) {
        session$setInputs(`pagination_switch` = TRUE)
        session$setInputs(`lpp` = 1)
        session$setInputs(`file_name` = "testtable")
        session$setInputs(`file_format` = down_type)
        testthat::expect_error(output$data_download, "Lines of repeated context")
      }
    }
  )
})

testthat::test_that("type_download_srv_table: content of the table, csv", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = table_r),
    expr = {
      session$setInputs(`pagination_switch` = TRUE)
      session$setInputs(`lpp` = 10)
      session$setInputs(`file_name` = "testtable")
      session$setInputs(`file_format` = ".csv")
      csv <- read.csv(output$data_download)
      testthat::expect_equal(
        csv,
        data.frame(
          "X1" = 2,
          "X" = "Mean",
          "setosa" = 5.01,
          "versicolor" = 5.94,
          "virginica" = 6.59
        )
      )
    }
  )
})

testthat::test_that("type_download_srv_table: content of the table, txt", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = table_r),
    expr = {
      session$setInputs(`pagination_switch` = TRUE)
      session$setInputs(`lpp` = 10)
      session$setInputs(`file_name` = "testtable")
      session$setInputs(`file_format` = ".txt")
      txt <- read.delim(output$data_download, sep = "")
      testthat::expect_equal(
        txt,
        data.frame(
          "setosa" = c(NA, 5.01),
          "versicolor" = c(NA, 5.94),
          "virginica" = c(NA, 6.59),
          row.names = c("——————————————————————————————————————", "Mean")
        )
      )
    }
  )
})

testthat::test_that("table_with_settings_srv: gtsummary table renders with content", {
  gtsummary_r <- shiny::reactive({
    gtsummary::tbl_summary(mtcars[1:5, 1:3])
  })

  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(id = "tws", table_r = gtsummary_r),
    expr = {
      html_content <- as.character(output$table_out_main$html)
      testthat::expect_s3_class(output$table_out_main$html, "html")
      testthat::expect_true(grepl("mpg|cyl|disp", html_content, ignore.case = TRUE))
      testthat::expect_true(grepl("<table", html_content, ignore.case = TRUE))
    }
  )
})

testthat::test_that("table_with_settings_srv: gt table renders with content", {
  gt_r <- shiny::reactive({
    gt::gt(mtcars[1:5, 1:3])
  })

  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(id = "tws", table_r = gt_r),
    expr = {
      html_content <- as.character(output$table_out_main$html)
      testthat::expect_s3_class(output$table_out_main$html, "html")
      testthat::expect_true(grepl("mpg|cyl|disp", html_content, ignore.case = TRUE))
      testthat::expect_true(grepl("<table", html_content, ignore.case = TRUE))
    }
  )
})

testthat::test_that("type_download_srv_table: downloading tbl_split output types", {
  tbl_split_r <- shiny::reactive({
    gtsummary::tbl_split_by_rows(gtsummary::tbl_summary(gtsummary::trial, by = "trt"), variables = c("marker"))
  })

  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = tbl_split_r),
    expr = {
      for (down_type in c(".txt", ".csv", ".pdf")) {
        if (down_type == ".pdf") {
          testthat::skip_if_not_installed("webshot2")
          testthat::skip_on_cran()
        }
        session$setInputs(
          "pagination_switch" = FALSE,
          "file_format" = down_type,
          "file_name" = "testtable"
        )
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_equal(
          basename(output$data_download), paste0(input$file_name, ".zip")
        )
      }
    }
  )
})

testthat::test_that("table_with_settings_srv: tbl_split table renders with content", {
  tbl_split_r <- shiny::reactive({
    gtsummary::tbl_split_by_rows(gtsummary::tbl_summary(gtsummary::trial, by = "trt"), variables = c("marker"))
  })

  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(id = "tws", table_r = tbl_split_r),
    expr = {
      html_content <- as.character(output$table_out_main$html)

      testthat::expect_s3_class(output$table_out_main$html, "html")
      testthat::expect_true(grepl("Tumor Response", html_content, ignore.case = TRUE))
      testthat::expect_true(grepl("<table", html_content, ignore.case = TRUE))
    }
  )
})

testthat::test_that("table_with_settings_srv: unsupported table throws error", {
  shiny::testServer(
    teal.widgets::table_with_settings_srv,
    args = list(id = "tws", table_r = reactive(structure(list(a = 1), class = "unsupported"))),
    expr = {
      testthat::expect_error(
        output$table_out_main$html,
        "Unsupported table type. table_with_settings supports",
        fixed = TRUE
      )
    }
  )
})

testthat::test_that("type_download_srv_table: downloading gtsummary output types", {
  tbl_split_r <- shiny::reactive({
    gtsummary::tbl_summary(gtsummary::trial, by = "trt")
  })

  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = tbl_split_r),
    expr = {
      for (down_type in c(".txt", ".csv", ".pdf")) {
        if (down_type == ".pdf") {
          testthat::skip_if_not_installed("webshot2")
          testthat::skip_on_cran()
        }
        session$setInputs(
          "pagination_switch" = FALSE,
          "file_format" = down_type,
          "file_name" = "testtable"
        )
        testthat::expect_true(file.exists(output$data_download))
        testthat::expect_equal(
          basename(output$data_download), paste0(input$file_name, down_type)
        )
      }
    }
  )
})

testthat::test_that("type_download_srv_table: unsupported type", {
  shiny::testServer(
    teal.widgets:::type_download_srv_table,
    args = list(id = "tws", table_reactive = reactive(structure(list(a = 1), class = "unsupported"))),
    expr = {
      session$setInputs(
        "pagination_switch" = FALSE,
        "file_format" = ".csv",
        "file_name" = "testtable"
      )
      testthat::expect_error(output$data_download, "Unsupported table type for download")
    }
  )
})

testthat::test_that("type_download_srv_table: warns about non-meaningful file names for all table types", {
  tables <- list(
    rtables = table_r,
    gt = shiny::reactive(gt::gt(mtcars[1:2, 1:2])),
    gtsummary = shiny::reactive(gtsummary::tbl_summary(gtsummary::trial[, c("trt", "age")]))
  )
  for (tbl_r in tables) {
    shiny::testServer(
      teal.widgets:::type_download_srv_table,
      args = list(id = "tws", table_reactive = tbl_r),
      expr = {
        for (bad in c("        ", "_-!@#$%^&", "....", "")) {
          session$setInputs(file_name = bad)
          testthat::expect_false(file_name_valid())
          testthat::expect_match(as.character(output$file_name_warning$html), "meaningful file name")
        }
        for (good in c("df", "testtable")) {
          session$setInputs(file_name = good)
          testthat::expect_true(file_name_valid())
          testthat::expect_null(output$file_name_warning)
        }
      }
    )
  }
})
