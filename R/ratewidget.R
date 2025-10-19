#' Show the summary proportion in a widget
#'
#' A `ratewidget` displays a single statistic derived from a linked table, where
#' the numerator and denominator columns are specific. This is best used with
#' the `crosstalk`package, to allow dynamic filtering of the underlying data.
#'
#' @param data A data frame or data table containing the data to summarize,
#' with at least two numeric columns: one for the numerator and one for the
#' denominator. Normally, this should be an instance of [crosstalk::SharedData].
#' @param numerator The name of the column in `data` to use as the numerator.
#' @param denominator The name of the column in `data` to use as the
#' denominator.
#' @param multiplier A numeric value to multiply the proportion by (default is
#' 100, to express as a percentage).
#' @param digits The number of decimal places to round the result to (default is
#' 0).
#' @param suffix An optional suffix to append to the displayed value (e.g., "%").
#' @param width The width of the widget (optional).
#' @param height The height of the widget (optional).
#' @param elementId An optional element ID for the widget.
#'
#' @import crosstalk
#' @import htmlwidgets
#'
#' @export
ratewidget <- function(data, numerator, denominator, multiplier = 100, digits = 0, suffix = NULL, width = NULL, height = NULL, elementId = NULL) {

  if (is.SharedData(data)) {
    # Using Crosstalk
    key <- data$key()
    group <- data$groupName()
    data <- data$origData()
  } else {
    # Not using Crosstalk
    key <- NULL
    group <- NULL
  }

  # Check if numerator column is in data
  if (!(numerator %in% colnames(data)))
    stop("No ", numerator, " column in data.")
  data_num = data[[numerator]]

  # Check if denomiator column is in data
  if (!(numerator %in% colnames(data)))
    stop("No ", denominator, " column in data.")
  data_den = data[[denominator]]

  # forward options using x
  x <- list(
    data_num = data_num,
    data_den = data_den,
    settings = list(
      multiplier = multiplier,
      digits = digits,
      suffix = ifelse(is.null(suffix), "", suffix),
      crosstalk_key = key,
      crosstalk_group = group
    )
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'ratewidget',
    x,
    width = width,
    height = height,
    dependencies = crosstalk::crosstalkLibs(),
    package = 'ratewidget',
    elementId = elementId
  )
}

#' Shiny bindings for ratewidget
#'
#' Output and render functions for using ratewidget within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a ratewidget
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name ratewidget-shiny
#'
#' @export
ratewidgetOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'ratewidget', width, height, package = 'ratewidget')
}

#' @rdname ratewidget-shiny
#' @export
renderratewidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, ratewidgetOutput, env, quoted = TRUE)
}

# Use a <span> container rather than the default <div>
ratewidget_html <- function(id, style, class, ...){
  htmltools::tags$span(id = id, class = class)
}
