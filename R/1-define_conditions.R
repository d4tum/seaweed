#' @title Define weather conditions
#' @description Defines daily weather conditions from rules applied to historical weather data.
#' @param dt A \code{data.table} created by the function \code{\link{get_weather}}
#' @return A \code{data.table} of all the input data including 4 extra variables -
#' \code{year}, \code{month}, \code{day} and \code{condition}
#' @details Rules to determine weather condition are based on commonsense and are
#' based upon mean values of "CloudCover" and "Precipitation" > 0. Weather onditions
#' can take only one of three values - "Sunny", "Cloudy" or "Rainy".
#'
#' The function splits the \code{Date} "YYYY-MM-DD" into "year", "month" and "day"
#' for use in the functions \code{create_markovchains(dt)} and \code{compute_pdfs(dt)}
#' that are used to model the weather data.
#' @seealso \code{\link{create_markovchains}} \code{\link{compute_pdfs}}
#' @export
#' @importFrom data.table :=
#' @importFrom lubridate year
#' @importFrom lubridate month
#' @importFrom lubridate day
#' @importFrom lubridate ymd
set_conditions <- function(dt) {
  # Split out Y M D from Date
  dt[, year := year(ymd(Date))]
  dt[, month := month(ymd(Date))]
  dt[, day := day(ymd(Date))]
  # Remove redundant Date
  # dt[, Date := NULL]

  ## Cleaning
  # Set CloudCover NAs to 0
  dt[, CloudCover := ifelse(is.na(CloudCover), 0, CloudCover)]

  ## Condition rules
  # Sunny
  dt[, condition := ifelse(Precipitationmm == 0 &
                             CloudCover < mean(CloudCover),
                           "Sunny",
                           "")]
  # Cloudy
  dt[, condition := ifelse(Precipitationmm == 0 &
                             CloudCover > mean(CloudCover),
                           "Cloudy",
                           condition)]
  # Rain
  dt[, condition := ifelse(Precipitationmm > 0, "Rain", condition)]
  # Else Sunny :)
  dt[, condition := ifelse(condition == "", "Sunny", condition)]
  dt
}
