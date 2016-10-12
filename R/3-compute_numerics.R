#' @title Random sampling from statistical models
#' @description  Pick daily temperature, pressure and humidity from a normal distribution
#' @param dt A \code{data.table} created by the function \code{\link{create_markovchains}}
#' @param pdfs A \code{data.table} created by the function \code{\link{compute_pdfs}}
#' @return A \code{data.table} with temperature, pressure and humidity calculated
#' from a random variable drawn from a normal distribution described by a
#' @details Temperature, pressure and humidity are randomly chosen from a normal
#' distribution described by the mean and standard deviation (the probability density
#' function) for daily weather conditions observed at each station over each month.
#' @seealso \code{\link{create_markovchains}} \code{\link{compute_pdfs}}
#' @export
generate_metrics <- function(dt, pdfs) {
  # Clean up the data and remove variables that are not not needed anymore
  dt[, condition := mcs]
  dt[, c(
    "Mean_TemperatureC",
    "Mean_Humidity",
    "Mean_Sea_Level_PressurehPa",
    "Precipitationmm",
    "CloudCover",
    "mcs"
  ) := NULL]

  temp <- numeric()
  press <- numeric()
  hum <- numeric()

  for (r in 1:nrow(dt)) {
    t_mean <-
      pdfs[station == dt[r]$station &
              month == dt[r]$month & condition == dt[r]$condition]$t_mean
    t_sd <-
      pdfs[station == dt[r]$station &
              month == dt[r]$month & condition == dt[r]$condition]$t_sd
    t <- rnorm(1, t_mean, t_sd)

    p_mean <-
      pdfs[station == dt[r]$station &
              month == dt[r]$month & condition == dt[r]$condition]$p_mean
    p_sd <-
      pdfs[station == dt[r]$station &
              month == dt[r]$month & condition == dt[r]$condition]$p_sd
    p <- rnorm(1, p_mean, p_sd)

    h_mean <-
      pdfs[station == dt[r]$station &
              month == dt[r]$month & condition == dt[r]$condition]$h_mean
    h_sd <-
      pdfs[station == dt[r]$station &
              month == dt[r]$month & condition == dt[r]$condition]$h_sd
    h <- rnorm(1, h_mean, h_sd)

    temp <- c(temp, t)
    press <- c(press, p)
    hum <- c(hum, h)
  }

  dt[, temperature := round(temp, 1)]
  dt[, pressure := round(press, 1)]
  dt[, humidity := as.integer(hum)]

  dt
}
