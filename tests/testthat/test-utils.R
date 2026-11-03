# Create a sample ggplot2 plot object
ggplot_obj <- ggplot2::ggplot(data = iris, ggplot2::aes(x = Sepal.Length, y = Sepal.Width)) +
  ggplot2::geom_point()

testthat::test_that("apply_plot_modifications, Modify ggplot object with dblclicking enabled", {
  modified_ggplot <- apply_plot_modifications(
    plot_obj = ggplot_obj,
    plot_type = "gg",
    dblclicking = TRUE,
    ranges = list(x = c(4, 7), y = c(2, 4))
  )
  testthat::expect_true(identical(class(modified_ggplot), class(ggplot_obj)))
})

testthat::test_that("apply_plot_modifications, Modify ggplot object with dblclicking disabled", {
  modified_ggplot <- apply_plot_modifications(
    plot_obj = ggplot_obj,
    plot_type = "gg",
    dblclicking = FALSE,
    ranges = list(x = c(4, 7), y = c(2, 4))
  )
  testthat::expect_true(identical(class(modified_ggplot), class(ggplot_obj)))
})

testthat::test_that("apply_plot_modifications, Modify grob object", {
  testthat::skip_if_not_installed("grid")
  grob_obj <- grid::rectGrob()
  modified_grob <- apply_plot_modifications(
    plot_obj = grob_obj,
    plot_type = "grob",
    dblclicking = TRUE,
    ranges = list(x = c(0, 1), y = c(0, 1))
  )
  testthat::expect_null(modified_grob)
})

testthat::test_that("apply_plot_modifications, Do not modify plot object", {
  unchanged_plot <- apply_plot_modifications(
    plot_obj = ggplot_obj,
    plot_type = "other_type",
    dblclicking = TRUE,
    ranges = list(x = c(4, 7), y = c(2, 4))
  )
  testthat::expect_true(identical(unchanged_plot, ggplot_obj))
})

testthat::test_that(".warning_gt_webshot2, show warning only once a session", {
  old_value <- .warnings_env$gt_webshot2_warning
  withr::defer(.warnings_env$gt_webshot2_warning <- old_value)
  .warnings_env$gt_webshot2_warning <- NULL

  testthat::expect_warning(
    .warning_gt_webshot2(gt::gt(head(mtcars)), FALSE)
  )
  testthat::expect_no_warning(
    .warning_gt_webshot2(gt::gt(head(mtcars)), FALSE)
  )
})
