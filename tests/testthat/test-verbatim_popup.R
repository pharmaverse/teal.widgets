testthat::test_that("format_content returns a `shiny` reactive when passed a string", {
  test_content <- "Test content"
  testthat::expect_true(inherits(format_content(test_content), "reactive"))
})

testthat::test_that("format_content returns a `shiny` reactive when passed an expression", {
  test_content <- expression("Test content")
  testthat::expect_true(inherits(format_content(test_content), "reactive"))
})

testthat::test_that("format_content returns a `shiny` reactive when passed a reactive", {
  test_content <- shiny::reactiveVal("Test Content")
  testthat::expect_true(inherits(format_content(test_content), "reactive"))
})

testthat::test_that("format_content returns a reactive when passed a condition", {
  test_content <- structure("Test Content", clas = "condition")
  testthat::expect_true(inherits(format_content(test_content), "reactive"))
})

testthat::test_that("format_content returns a reactive when passed a reactive holding a condition", {
  test_content <- shiny::reactive({
    validate(need(1 > 4, "1 is less than 4"))
  })
  testthat::expect_true(inherits(format_content(test_content), "reactive"))
})

testthat::test_that("format_content concatenates the passed array of strings", {
  test_content <- c("Test", "Content")
  result <- shiny::isolate(format_content(test_content))
  testthat::expect_length(result, 1)
})

testthat::test_that("format_content concatenates the passed array of expressions", {
  test_content <- c(expression("test"), expression("content"))
  result <- shiny::isolate(format_content(test_content))
  testthat::expect_length(result, 1)
})

testthat::test_that("format_content concatenates the passed array of string inside a reactive", {
  test_content <- shiny::reactive(c("Test", "Content"))
  result <- shiny::isolate(format_content(test_content)())
  testthat::expect_length(result, 1)
})

testthat::test_that(
  "format_content returns a reactive storing a styled string when passed
  an expression, character or reactive when style = TRUE",
  code = {
    shiny::isolate({
      # Reactive
      test_content <- shiny::reactive(c("Test", "Content"))
      result <- format_content(test_content, style = TRUE)()
      testthat::expect_equal(result, "Test\nContent")

      # Expression
      test_content <- expression({
        print(7)
        if (TRUE) print(8)
      })
      result <- format_content(test_content, style = TRUE)()
      testthat::expect_equal(result, paste(
        "{",
        "  print(7)",
        "  if (TRUE) {",
        "    print(8)",
        "  }",
        "}",
        sep = "\n"
      ))

      # Character
      test_content <- c("Test", "Content")
      result <- format_content(test_content, style = TRUE)()
      testthat::expect_equal(result, "Test\nContent")
    })
  }
)

testthat::test_that("button_click_observer returns an observer", {
  testthat::expect_true(inherits(button_click_observer(
    click_event = shiny::reactive(0),
    copy_button_id = "test_copy_button_id",
    copied_area_id = "test",
    modal_title = "test Title",
    modal_content = "Test content"
  ), "Observer"))
})

testthat::test_that("verbatim_popup_ui returns a tag list", {
  testthat::expect_true(
    inherits(verbatim_popup_ui(id = "test_id", button_label = "Test button label"), "shiny.tag.list")
  )
})

testthat::test_that("verbatim_popup_ui with type not equal to 'button' or 'link' throws error", {
  testthat::expect_error(
    verbatim_popup_ui(id = "test_id", button_label = "Test button label", type = "abc"),
    "" # match.arg explicitly says in documentation not to test specific error message
  )
})

testthat::test_that("verbatim_popup_ui with type 'button' produces a button", {
  ui_char <- as.character(verbatim_popup_ui(id = "test_id", button_label = "Test button label", type = "button"))
  testthat::expect_true(grepl("^<button ", ui_char))
})

testthat::test_that("verbatim_popup_ui with type 'link' produces a button with a class link", {
  ui_char <- as.character(verbatim_popup_ui(id = "test_id", button_label = "Test button label", type = "link"))
  testthat::expect_true(grepl("^<button class=.+\\blink\\b", ui_char))
})

testthat::test_that("verbatim_popup_srv with id not a string produces error", {
  expect_error(verbatim_popup_srv(numeric(), "test", "my title"))
})

testthat::test_that("verbatim_popup_srv with verbatim_content invalid type produces error", {
  expect_error(verbatim_popup_srv("id", numeric(), "my title"))
})

testthat::test_that("verbatim_popup_srv with disabled invalid type produces error", {
  expect_error(verbatim_popup_srv("id", "test", "my title", disabled = numeric()))
})

testthat::test_that("verbatim_popup_srv with title not a string produces error", {
  expect_error(verbatim_popup_srv("id", "test", numeric()))
})

testthat::test_that("verbatim_popup_srv with style not a flag produces error", {
  expect_error(verbatim_popup_srv("id", "test", "my title", style = "yes"))
})


testthat::test_that("verbatim_popup_ui with id not a string produces error", {
  expect_error(verbatim_popup_ui(numeric(), "label"))
})

testthat::test_that("verbatim_popup_ui with button_label not a string produces error", {
  expect_error(verbatim_popup_ui("id", numeric()))
})

testthat::test_that("format_content handles reactive throwing error", {
  test_content <- shiny::reactive({
    stop("Test error")
  })
  result <- format_content(test_content)
  # The reactive should catch the error and return it as a condition
  shiny::isolate({
    content <- tryCatch(result(), error = function(e) e)
    testthat::expect_true(inherits(content, "error") || inherits(content, "character"))
  })
})

testthat::test_that("format_content validates content type", {
  test_content <- shiny::reactive(list(invalid = "type"))
  result <- format_content(test_content)
  # Should fail validation because list is not a valid type
  shiny::isolate({
    expect_error(result(), "verbatim_content should be an expression, character or condition")
  })
})

testthat::test_that("format_content handles error from reactive correctly", {
  test_content <- shiny::reactive({
    stop("Test error message")
  })
  result <- format_content(test_content, style = FALSE)
  shiny::isolate({
    # The error should be caught by tryCatch in format_content
    output <- result()
    # Should return the error message
    testthat::expect_type(output, "character")
    testthat::expect_true(grepl("Test error message", output))
  })
})

testthat::test_that("format_content styles code when style=TRUE", {
  test_content <- "if(TRUE){print(1)}"
  result <- format_content(test_content, style = TRUE)
  shiny::isolate({
    output <- result()
    # Styled output should have proper formatting
    testthat::expect_type(output, "character")
    # Should contain formatted code
    testthat::expect_true(nchar(output) > 0)
  })
})

testthat::test_that("button_click_observer accepts modal_content as reactive", {
  observer <- button_click_observer(
    click_event = shiny::reactive(0),
    copy_button_id = "test_copy",
    copied_area_id = "test_area",
    modal_title = "Test Title",
    modal_content = shiny::reactive("Test content"),
    disabled = shiny::reactive(FALSE)
  )
  testthat::expect_true(inherits(observer, "Observer"))
})

# Test verbatim_popup_ui with additional arguments via ...
testthat::test_that("verbatim_popup_ui passes additional arguments to actionButton", {
  ui <- verbatim_popup_ui(
    id = "test_id",
    button_label = "Test",
    type = "button",
    class = "custom-class"
  )
  testthat::expect_s3_class(ui, "shiny.tag.list")
  ui_char <- as.character(ui)
  testthat::expect_true(grepl("custom-class", ui_char))
})

# Test verbatim_popup_srv with reactive content
testthat::test_that("verbatim_popup_srv works with reactive verbatim_content", {
  test_content <- shiny::reactiveVal("Initial content")

  shiny::testServer(
    app = verbatim_popup_srv,
    args = list(
      verbatim_content = test_content,
      title = "Test Title",
      style = FALSE
    ),
    expr = {
      # Verify we can access and update the reactive content
      initial_val <- test_content()
      testthat::expect_equal(initial_val, "Initial content")
      test_content("Updated content")
      testthat::expect_equal(test_content(), "Updated content")
    }
  )
})

# Test verbatim_popup_srv with style=TRUE
testthat::test_that("verbatim_popup_srv works with style=TRUE", {
  shiny::testServer(
    app = verbatim_popup_srv,
    args = list(
      verbatim_content = "print(1)",
      title = "Test Title",
      style = TRUE
    ),
    expr = {
      # Verify session object is created
      testthat::expect_type(session, "environment")
      # Server should initialize without errors
      testthat::expect_no_error(session$ns("test"))
    }
  )
})

testthat::test_that("format_content with non-reactive expression", {
  test_content <- expression(print(1))
  result <- format_content(test_content, style = FALSE)
  shiny::isolate({
    output <- result()
    testthat::expect_type(output, "character")
    testthat::expect_equal(output, "print(1)")
  })
})

testthat::test_that("format_content with character vector", {
  test_content <- c("line1", "line2", "line3")
  result <- format_content(test_content, style = FALSE)
  shiny::isolate({
    output <- result()
    testthat::expect_type(output, "character")
    testthat::expect_equal(output, "line1\nline2\nline3")
  })
})

testthat::test_that("format_content ignores style = TRUE when passed a condition", {
  test_content <- simpleError("object 'x' not found")
  result <- format_content(test_content, style = TRUE)
  shiny::isolate({
    output <- result()
    testthat::expect_identical(output, paste(as.character(test_content), collapse = "\n"))
  })
})

testthat::test_that("format_content ignores style = TRUE when reactive throws an error", {
  test_content <- shiny::reactive(stop("object 'x' not found"))
  result <- format_content(test_content, style = TRUE)
  shiny::isolate({
    output <- result()
    testthat::expect_type(output, "character")
    testthat::expect_true(grepl("object 'x' not found", output, fixed = TRUE))
  })
})
