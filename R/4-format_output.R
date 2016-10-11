#' Format sawdata according to specification
#'
#' @param dt A \code{data.table} created by the function \code{\link{generate_metrics}}
#' @return A \code{data.table} formatted according to the specifications in details
#' @details Synthetic Australian weather data is fromatted as such:
#'
#' station location time condition temperature pressure humidity\cr
#' SYD|-33.86,151.21,39|2015-12-23T05:02:12Z|Rain|+12.5|1004.3|97\cr
#' MEL|-37.83,144.98,7|2015-12-24T15:30:55Z|Snow|-5.3|998.4|55\cr
#' ADL|-34.92,138.62,48|2016-01-03T12:35:37Z|Sunny|+39.4|1114.1|12\cr
#'
#' A random time component is added to the date variable to align to the specs.
#' @seealso \code{\link{create_markovchains}} \code{\link{compute_pdfs}}
#' @examples
#' \dontrun{head(format_output(dt))}
#' station          location                 time condition temperature pressure humidity
#' ADL   -34.57,138.31,4 2016-09-01T10:09:34Z      Rain        12.1   1021.6       70
#' ASP -23.48,133.54,541 2016-09-01T10:16:28Z    Cloudy        21.7   1014.8       43
#' BNE   -27.23,153.08,5 2016-09-01T18:50:40Z     Sunny        19.1   1013.0       54
#' CBR -35.17,149.10,577 2016-09-01T13:40:24Z      Rain        10.1   1012.2       78
#' CNS   -16.52,145.45,7 2016-09-01T21:33:33Z      Rain        22.7   1010.4       74
#' DRW  -12.25,130.54,30 2016-09-01T08:46:37Z     Sunny        28.9   1010.1       51
#' @export
format_output <- function(dt) {
  # Add lat/lng and elevation to the data
  location <-
    data.table(
      station = c(unique(dt$station)),
      location = c(
        "-42.49,147.31,27",
        "-37.40,144.49,141",
        "-35.17,149.10,577",
        "-33.57,151.10,3",
        "-27.23,153.08,5",
        "-16.52,145.45,7",
        "-12.25,130.54,30",
        "-31.56,115.59,13",
        "-34.57,138.31,4",
        "-23.48,133.54,541"
      )
    )

  # Join location to the data
  dt <- merge(dt, location, by = "station", all.x = T)

  out <- data.table(
    station = character(),
    location = character(),
    time = character(),
    condition = character(),
    temperature = numeric(),
    pressure = numeric(),
    humidity = integer()
  )

  for (d in unique(dt$Date)) {
    for (s in unique(dt$station)) {
      station <- dt[Date == d & s == station]$station
      location <- dt[Date == d & s == station]$location
      time <- dt[Date == d & s == station]$Date
      condition <- dt[Date == d & s == station]$condition
      temperature <- dt[Date == d & s == station]$temperature
      pressure <- dt[Date == d & s == station]$pressure
      humidity <- dt[Date == d & s == station]$humidity

      o <-
        data.table(station,
                   location,
                   time,
                   condition,
                   temperature,
                   pressure,
                   humidity)
      out <- rbind(out, o)
    }
  }

  # Format the datetime to the spec adding a random time componenet
  # e.g. "2016-03-05" -> "2015-12-23T05:02:12Z"
  for (i in seq_len(nrow(out))) {
    out[i, time :=
          paste0(time,
                 "T",
                 format(as.POSIXct(Sys.Date() +
                                     runif(1, max = 60 * 60 * 24)),
                        "%H:%M:%S",
                        tz = "UTC"),
                 "Z")]
  }

  # Clean-up
  rm(list = setdiff(ls(), c("out")))
  out
}
# Save final dataset to file
# save(out, file = "data/04_synawegen_final_dataset.rda")
# Write out to psv file
# write_delim(out,
#             "data/weather_data.dat",
#             delim = "|",
#             col_names = F)
