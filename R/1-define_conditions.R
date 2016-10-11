#' Define daily weather conditions from rules applied to historical weather data.
#'
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
#' @examples
#' \dontrun{head(set_conditions(dt))}
#' station       Date Mean_TemperatureC Mean_Humidity Mean_Sea_Level_PressurehPa Precipitationmm CloudCover year month day condition
#' HBA 2016-09-01                12            57                       1012            0.51          3 2016     9   1      Rain
#' HBA 2016-09-02                 9            76                       1013            0.00          5 2016     9   2    Cloudy
#' HBA 2016-09-03                 8            84                       1005            0.25          5 2016     9   3      Rain
#' HBA 2016-09-04                12            52                       1010            0.00          3 2016     9   4     Sunny
#' HBA 2016-09-05                14            51                       1019            0.00          3 2016     9   5     Sunny
#' HBA 2016-09-06                14            53                       1022            0.00          4 2016     9   6    Cloudy
#' @export
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
