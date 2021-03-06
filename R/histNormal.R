################################################################################
#
#' Histogram with normal curve superimposed to help with “by-eye” assessments
#' of normality of distribution
#'
#' @param x A numeric vector
#' @param xlab \code{x-axis} label
#' @param ylab \code{y-axis} label
#' @param main Plot title
#' @param breaks Passed to \code{hist()} function (\code{?hist} for details)
#' @param ylim \code{y-axis} limits
#' @return NULL
#' @examples
#' # \code{histNormal()} with data from a SMART survey in Kabul, Afghanistan
#' # (dist.ex01)
#' svy <- dist.ex01
#' histNormal(svy$muac)
#' histNormal(svy$haz)
#' histNormal(svy$waz)
#' histNormal(svy$whz)
#' @export
#'
#
################################################################################

histNormal <- function(x,
                       xlab = deparse(substitute(x)),
                       ylab = "Frequency",
                       main = deparse(substitute(x)),
                       breaks = "Sturges",
                       ylim = NULL) {
  h <- hist(x, plot = FALSE, breaks = breaks)
  xfit <- seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length = 100)
  yfit <- dnorm(xfit, mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE))
  yfit <- yfit * diff(h$mids[1:2]) * length(x)

  if(is.null(ylim)) {
    ylim <- c(0, max(max(h$counts), max(yfit)))
  }

  hist(x, xlab = xlab, ylab = ylab, main = main, breaks = breaks, ylim = ylim)
  lines(xfit, yfit, lty = 3)
}
