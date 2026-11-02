# teal.widgets 0.7.0.9003

### Enhancements

* Added support for `tbl_split` object from `gtsummary` package to `table_with_settings`.

### Bug fixes

* Fixed PDF download of `gt` and `gtsummary` tables in `table_with_settings`. The download button of `table_with_settings` and `plot_with_settings` is now hidden, and a warning is shown, until the file name contains at least one letter or number (#363, #365).

### Miscellaneous

* teal.widgets has moved to the pharmaverse GitHub organisation: https://github.com/pharmaverse/teal.widgets.
* Appsilon becomes a core contributor and joins F. Hoffmann-La Roche AG as a copyright holder of teal.widgets, working alongside the wider contributor community.

# teal.widgets 0.6.1

### Bug fixes
* Fix snapshot failure during R CMD Check (#341).
* Fixed problem with resize plot popup that does not render content with newer version of shiny (#350).

### Miscellaneous
* Update maintainer.

# teal.widgets 0.6.0

### Enhancements
* Added support for `gt` and `gtsummary` object to `table_with_settings` (#337)
* `gt`, `gtsummary`, `xml2` and `rvest` packages were added to `Imports`.

# teal.widgets 0.5.1

### Miscellaneous
* Improve unit test coverage (#318).

# teal.widgets 0.5.0

### Enhancements
* Improved the layout and appearance of the widgets using `bslib` components (#288).

### Breaking changes
* `panel_group()` and `panel_item()` are soft deprecated. Please use the `bslib::accordion()` and `bslib::accordion_panel()` instead.
* `nested_closeable_modal()` was soft deprecated.

### Bug fixes
* Recompute the `live-search` option value dynamically in `updateOptionalSelectInput` (#291).
* Fix bug where plot height reset after resizing (#301).

# teal.widgets 0.4.3

### Miscellaneous
* Improve the documentation for several functions by adding examples.
* Fix several bugs related to plot resizing.
* Fix the bug when `plot_width` not given in `plot_with_settings`.

# teal.widgets 0.4.2

### Enhancements
* Introduce `nested_closeable_modal()` that can create nested popups inside an already existing popup.
* Replaces examples from `runApp` with `shinyApp`.
* Ensure that `table_with_settings()` is synchronized with the latest update of `rtables`, and updated the version dependency accordingly.

# teal.widgets 0.4.1

### Miscellaneous

* Documentation enhancements - code formatting package names and R objects.
* Add `grDevices` to Imports.
* Specified minimal version of package dependencies.
* Improved logic and documentation for `optionalSelectInput`.

# teal.widgets 0.4.0

### Bug fixes

* Fix the rendering on modal pop-up in plots.

### Miscellaneous

* Removed `scda` package dependency from examples.
* Update installation instructions in `README`.

# teal.widgets 0.3.0

### Enhancements
* Added support for downloading base plots.
* Add support for `draggable_buckets` to use `shinyvalidate` for input validation.
* The `disabled` in `verbatim_popup_srv` is no longer triggered when button is hidden.
* Added `type` argument to `verbatim_popup_ui` which allows the pop-up to be controlled by a `button` or a `link`.

### Bug fixes
* Added labels to pagination button in `table_with_settings` and fixed alt text.
* Fixed the html structure of `panel_item` function.

### Miscellaneous
* Added `shinytest2` tests for `plot_with_settings` and `table_with_settings`.
* Removed the `DRAFT` label on downloaded plots.
* Changed dependency type of `rtables` from `Imports` to `Suggests`.

# teal.widgets 0.2.0

### Breaking changes
* Updated `panel_group` and `panel_item` functions to no longer be an optional shiny input.

### Enhancements
* Updated `standard_layout` function to contain class not id for each output block.
* Added the `dim` slot to the list returned by the `plot_with_settings` module.
* Added `style` argument to `verbatim_popup_srv` to control whether the content is styled using `styler::style_text`.
* `condition` objects can now be displayed in `verbatim_popup`.

### Bug fixes
* Fixed bug in `verbatim_popup_srv` where `disabled` argument didn't influence the popup button.
* Fixed `optionalSliderInput` validation to remove a warning message in certain cases.

### New features
* Added a new module - `verbatim_popup`.

# teal.widgets 0.1.1

### New features
* Added a new widget `draggable_buckets`.

### Enhancements
* The `option` `teal.plot_dpi` controls the `dpi` for rendering and downloading plots in `plot_with_settings`. If `option` is not used then a default of `72dpi` is used (unchanged from the previous behavior).

### Bug fixes
* Fixed a bug where zooming in or out from the browser would cause a plot of a `grob` object to not re-render instead displaying a blank white space.

### Miscellaneous
* Updated package authors.

# teal.widgets 0.1.0

* Initial release of `teal.widgets` a package providing shiny widgets for `teal` applications.

## Changes (from behavior when functionality was part of `teal`)

### Bug fixes
* Fixed location of pagination toggle for downloading tables using `table_with_settings`.
