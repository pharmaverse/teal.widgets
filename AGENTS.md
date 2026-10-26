
# teal.widgets R Package Development Guide

## Package Overview

`teal.widgets` is part of the `teal` framework. It provides a set of
reusable `shiny` widgets that `teal` modules use to build their
interface: plot and table outputs with resizing and download buttons,
layout helpers, and a few custom inputs. Each widget works on its own;
there is no shared app, router, or state.

All widgets are exported for `teal` module developers, in two forms:

- **Full modules** are a `<name>_ui()` and `<name>_srv()` pair wired
  into your app’s UI and server, for example `plot_with_settings`,
  `table_with_settings`, and `verbatim_popup`.
- **Standalone functions** are called directly, with no server
  counterpart to wire up, such as `optionalSelectInput`,
  `optionalSliderInput`, `draggable_buckets`, `standard_layout`,
  `panel_group`, `white_small_well`, and `get_dt_rows`.

## Development Context

This package provides reusable `shiny` widgets for `teal` modules:

- **Outputs** — plots and tables the user can resize and download
  (`plot_with_settings`, `table_with_settings`), configured through the
  settings pipeline (`ggplot2_args()` / `basic_table_args()`).
- **Inputs** — customized versions of `shiny`/`shinyWidgets` controls
  built for `teal`’s needs (`optionalSelectInput`,
  `optionalSliderInput`, `draggable_buckets`).
- **Layout helpers** — arrange module UI (`standard_layout`,
  `panel_group`, `white_small_well`) and display code or content in a
  modal (`verbatim_popup`, `nested_closeable_modal`).

### Relationships with other packages

`teal.widgets` sits at the bottom of the framework. `teal` and the
`teal.modules.*` packages depend on it, but it does not depend on any of
them.

Packages it relies on:

- `shiny`, `htmltools`, and `bslib` for the UI and layout.
- `shinyWidgets` and `shinyjs` for richer inputs and client-side
  behavior.
- `rtables`, `gt`, and `gtsummary` for the table types it renders and
  exports.
- `ggplot2` and base/grid graphics for plots.
- `rvest` and `xml2` for reading and editing table HTML.
- `checkmate` for input validation.
- `webshot2` (a `Suggests`) is needed to download `gt`, `gtsummary`, or
  `tbl_split` tables as PDF.

### How plots and tables are handled

- **Plots.** `plot_with_settings` works out the plot type on its own
  (`ggplot`, lattice, `grob`, or base graphics), so it is not limited to
  `ggplot2`. Its `plot_r` argument can be a `reactive` or a `function`;
  a `function` is only needed when a base plot has to be captured for
  download.
- **Tables.** `export_table`, `render_table_to_html`, and
  `file_download_format` (in `R/table_with_settings.R`) use S3 dispatch,
  with one method per table class (`rtables`, `gt`, `gtsummary`,
  `tbl_split`).
- **Plot and table settings.** `ggplot2_args()` and `basic_table_args()`
  capture the options, `resolve_*()` merges them with the defaults
  (including the global `getOption("teal.ggplot2_args")` and
  `getOption("teal.basic_table_args")`), and `parse_*()` produces the
  final code.
- **Front-end.** CSS and JS files live in `inst/<widget>/` and are
  registered with `htmltools::htmlDependency()`.

### Workflows

- Before fixing a bug, remember that `teal.widgets` is at the bottom of
  the framework, so the cause is often somewhere else: in the `teal`
  module that calls the widget, or in the package that produced the
  object being rendered (`rtables`, `gt`, `gtsummary`, `ggplot2`).
  Confirm the problem is really here before changing widget code, and
  check whether an issue already exists.
- To support a new table type, add a method for the new class to each of
  `export_table`, `render_table_to_html`, and `file_download_format`,
  instead of branching on class.
- To change how plot or table settings are applied, edit
  `ggplot2_args()` / `basic_table_args()`, `resolve_*()`, and
  `parse_*()` together, since a setting flows through all three.
- To add front-end assets, put the file in `inst/<widget>/` and register
  it in the widget’s dependency function; do not inline a `tags$script`.
- Run the full test suite before trusting a green run: set environment
  variable `TESTING_DEPTH=5`, because the default of `3` skips the heavy
  `shinytest2` tests. Server and unit tests are in `test-<widget>.R`; UI
  tests are in `test-<widget>_ui.R`.
- Add a regression test when you fix a bug.

<!-- markdownlint-disable-file MD002 MD041 -->

This package is part of the teal framework. The following configuration
applies to all packages within the teal framework.

## Package Structure and Organization

### Key Directories

Follow the standard R package structure with teal-specific conventions:

``` text
package_name/
├── .github           # CI/CD workflows
├── R/                # R source code
├── tests/testthat/   # Unit tests using testthat
├── vignettes/        # Long-form documentation
├── inst/             # Package assets
├── AGENTS.md         # Development guide for AI agents (this file)
├── DESCRIPTION       # Package metadata
├── NAMESPACE         # Exports and imports
├── NEWS.md           # Change log
├── README.md         # Package overview
├── _pkgdown.yml      # Documentation website config
├── .lintr            # Linting configuration
└── .Rbuildignore     # Build exclusions
```

### Naming Conventions

- **Function names**: Use `snake_case` consistently
- **Class names**: Use `PascalCase` (e.g., `TealAppDriver`)
- **Module functions**: Prefix UI functions with `ui_` and server
  functions with `srv_`
- **Internal functions**: Use descriptive names without export

### File Organization

- **One main function per file** when the function is substantial
- **Group related utilities** in shared files (e.g., `utils.R`,
  `validations.R`)
- **Module files**: Use pattern `tm_<name>.R` for teal modules
- **Helper functions**: Prefix with the main function they support

## Code Style and Standards

### Code Quality

- **Run `pre-commit` hooks**: Always run `pre-commit run --all-files`
  before committing, Fix any issues it reports - the error messages are
  informative and will guide you. It automatically checks code style,
  documentation and other quality issues. If pre-commit is not
  available, run the checks manually. Lint the R code manually as well
  if not called by pre-commit.
- **Follow `tidyverse` style**: General R code style follows the
  `tidyverse` style guide.
- **Documentation**: All exported functions must have `roxygen2`
  documentation with `@returns` and `@examples` fields.
- **Formatting** rules are configured in the `.lintr` file.

## Dependencies and Imports

### Dependency Management

- **Minimize dependencies**: Only add dependencies that provide
  significant value
- **Version constraints**: Specify minimum versions for critical
  dependencies
- **Ecosystem coherence**: Prefer packages already used within teal
  ecosystem

### Import Best Practices

Avoid importing package functions via roxygen2 (`#' @import pkg`)tags in
favor of explicit namespacing for clarity when appropriate. When needed
prefer specific imports over full package imports.

## Testing Framework

### Testing Philosophy

- **Test public functions only**: Internal utilities should be tested
  through public interfaces
- **Precise, focused tests**: Each test should verify one specific
  behavior
- **High coverage**: Maintain at least 80% test coverage as measured by
  `covr`
- **Integration over units**: Test realistic usage patterns
- **Test Dependencies**.: Add
  `testthat::skip_if_not_installed(package_name)` only for dependencies
  in `Suggests` or related to tests cases

### Shiny Module Testing

- **Server functions**: Test with `shiny::testServer()`
- **UI functions**: Test basic usage with regular testing (class checks,
  error generation, snapshots, regexp search). Test UI scenarios and
  interactions with `teal:::TealAppDriver` (based on
  `shinytest2::AppDriver`) for integration testing
- **Reactive behavior**: Test reactive chains and side effects

### Test Organization and Naming

- **One test file per R file**: `test-module_example.R` for
  `module_example.R`
- **Descriptive test names**: Clearly describe what is being tested
- **End to end test names**: `test-shinytest2-module_example.R` for
  `module_example.R`
- **Logical grouping**: Group related tests using `describe()` and
  individual tests with `it()` when beneficial
- **Test data**: Create minimal test datasets, avoid external
  dependencies

## Documentation and Communication

### Package Documentation

- **`README.md`**: Clear overview, installation, basic usage examples
- **Vignettes**: Comprehensive guides for complex functionality
- **Function documentation**: All exported functions must have
  `roxygen2` documentation
- **`NEWS.md`**: Detailed changelog of features, bugs and miscellanea
  changes affecting the users

### Package Version Management

Do not change versions on your own. There is a CI/CD workflow that
manages the versions automatically on the `main` branch.

## CI/CD and Development Workflow

Prefer to reuse templates from r.pkg.template. Main checks in place are:

- `check.yaml`: R CMD check, unit tests, coverage
- `docs.yaml`: Documentation building and deployment
- `audit.yaml`: Security and dependency auditing
- `pkgdown.yaml`: Website generation

## Quality Assurance

### Code Quality Metrics

- **Test Coverage**: ≥80% line coverage
- **Linting**: No lint violations using configured `.lintr`
- **Documentation**: 100% of exports documented

### Code Review Process

- **Pull Request Reviews**: All changes require human review and
  approval
- **Automated Checks**: CI must pass before merging
- **Breaking Changes**: Require special consideration and communication
- **Documentation Updates**: Must accompany functional changes

### Performance Considerations

- **Shiny Reactivity**: Minimize unnecessary reactive computations
- **Data Processing**: Use efficient data manipulation patterns
- **Memory Usage**: Consider memory implications for large datasets
- **Loading Time**: Optimize package loading and module initialization

## Maintenance Guidelines

- **Long-term Support**: Maintain backward compatibility when possible
- **Dependencies**: Minimal and justified dependencies only
- **Deprecation**: Use `lifecycle` package for function deprecation
