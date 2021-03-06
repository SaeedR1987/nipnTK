################################################################################
#
#' Goodness of fit to an expected (model-based) age distribution
#'
#' @param age Vector of ages
#' @param u5mr Under five years mortality rate as deaths / 10,000 persons / day
#' @param groups Age groupings specified as recodes parameter in the
#'     \code{recode} function; default is
#'     \code{"6:17=1; 18:29=2; 30:41=3; 42:53=4; 54:59=5"}
#' @return A list of class "ageChildren" with:
#' \describe{
#' \item{\code{u5mr}}{Under five years mortality rate as deaths / 10000 persons / day}
#' \item{\code{observed}}{Table of counts in each (year-centred) age group}
#' \item{\code{expected}}{Table of expected counts in each (year-centred) age group}
#' \item{\code{X2}}{Chi-squared test statistic}
#' \item{\code{df}}{Degrees of freedom for Chi-squared test}
#' \item{\code{p}}{p-value for Chi-squared test}
#' }
#' @examples
#' # Chi-Squared test for age of children in dp.ex02 sample dataset using an
#' # \code{u5mr} of 1 / 10,000 / day.
#' svy <- dp.ex02
#' ac <- ageChildren(svy$age, u5mr = 1)
#' ac
#'
#' # Apply function to each sex separately
#' # Males
#' acM <- ageChildren(svy$age[svy$sex == 1], u5mr = 1)
#' acM
#' # Females
#' acF <- ageChildren(svy$age[svy$sex == 2], u5mr = 1)
#'
#' # Simplified call to function by sex
#' by(svy$age, svy$sex, ageChildren, u5mr = 1)
#' @export
#'
#
################################################################################

ageChildren <- function(age,
                        u5mr = 0,
                        groups = "6:17=1; 18:29=2; 30:41=3; 42:53=4; 54:59=5") {

  ycag <- recode(age, groups)
  z <- (u5mr / 10000) * 365.25
  t <- 0:4
  p <- exp(-z * 0:4)
  d <- c(1, 1, 1, 1, 0.5)
  p <- d * p / sum(d * p)
  expected <- p * sum(table(ycag))
  names(expected) <- 1:5
  observed <- fullTable(ycag, values = 1:5)
  X2 <- sum((observed - expected)^2 / expected)
  pX2 <- pchisq(X2, df = 4, lower.tail = FALSE)
  result <- list(u5mr = u5mr,
                 observed = observed,
                 expected = expected,
                 X2 = X2,
                 df = 4,
                 p = pX2)
  class(result) <- "ageChildren"
  return(result)

}


################################################################################
#
#' \code{print()} helper function for \code{ageChildren()} function
#'
#' @param x Object resulting from applying \code{ageChildren()} function
#' @param ... Additional \code{print()} arguments
#' @return Printed output of \code{ageChildren()} function
#' @examples
#' # Print Chi-Squared test for age of children in dp.ex02 sample dataset using
#' # an \code{u5mr} of 1 / 10,000 / day.
#' svy <- dp.ex02
#' ac <- ageChildren(svy$age, u5mr = 1)
#' print(ac)
#' @export
#
################################################################################

print.ageChildren <- function(x, ...) {
  cat("\n\tAge Test (Children)\n\n", sep = "")
  cat("X-squared = ", formatC(x$X2, format = "f", width = 6), ", df = ", x$df, ", p = ", formatC(x$p, format = "f", width = 6), "\n\n", sep = "")
}


################################################################################
#
#' \code{plot()} helper function for \code{ageChildren()} function
#'
#' @param x Object resulting from applying \code{ageChildren()} function
#' @param ... Additional \code{barplot()} graphical parameters
#' @return Bar plot comparing table of observed counts vs table of expected counts
#' @examples
#' # Plot Chi-Squared test for age of children in dp.ex02 sample dataset using
#' # an \code{u5mr} of 1 / 10,000 / day.
#' svy <- dp.ex02
#' ac <- ageChildren(svy$age, u5mr = 1)
#' plot(ac)
#' @export
#
################################################################################

plot.ageChildren <- function(x, ...) {
  YLIM = c(0, max(max(x$observed), max(x$expected)))
  par(mfcol = c(1, 2))
  barplot(x$observed, main = "Observed", ylim = YLIM)
  barplot(x$expected, main = "Expected", ylim = YLIM)
}
