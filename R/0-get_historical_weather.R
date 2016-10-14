#' @title Get historical weather data
#' @description Returns historical weather station data for ten locations around Australia.
#' @param m Number of months of historical data to retrieve
#' @param download Whether to download a fresh batch of data TRUE or FALSE
#' @return A \code{data.table} containing \code{m} months of historical weather data
#' @details The data is fetched fetched through an API provided by \url{www.wunderground.com}.
#' When download is FALSE, \code{get_weather} reads from a local package datas file. The file
#' contains 12 months and 'm' will select 'n' months starting from the first month in the data.
#' When download is TRUE, the online API is called and fresh data is downloaded. In this
#' instance, 'm' will download 'n' months in the past. The first of which is the last month.
#'
#' NOTE: Trying to retrieve more that 1 years data where 'm' > 12 may fail.
#'
#' Airport weather stations collected for are:
#' Hobart, Melbourne, Canberra, Sydney, Brisbane, Cairns, Darwin, Perth, Adelaide
#' and Alice Springs.
#' @seealso \code{\link{set_conditions}}
#' @export
#' @import weatherData
#' @importFrom data.table fread
#' @importFrom data.table setDT
#' @importFrom data.table is.data.table
#' @importFrom lubridate month
#' @importFrom lubridate date
#' @importFrom lubridate rollback
#' @importFrom weatherData getWeatherForDate
get_weather <- function(m, download) {
  if (!download) {
    # Use stored raw data previously downloaded
    dt <-
      fread(
        system.file("extdata", "raw_sample_data.csv", package = "seaweed"),
        stringsAsFactors = FALSE
      )
    dt <- subset(dt, month(date(Date)) <= m)
    dt

  } else if (curl::has_internet()) {
    # Download a fresh batch
    # Set up weather station ICAO codes and give them 3 letter IATA names
    station_codes <-
      c("YMHB",
        "YMML",
        "YSCB",
        "YSSY",
        "YBBN",
        "YBCS",
        "YPDN",
        "YPPH",
        "YPAD",
        "YBAS")

    station_names <-
      c("HBA",
        "MEL",
        "CBR",
        "SYD",
        "BNE",
        "CNS",
        "DRW",
        "PER",
        "ADL",
        "ASP")

    # Fetch actual weather data from the past 6 months converting data.frames to data.tables on the fly
    # Whoa, data.table don't like POSIXlt dates
    dt <- data.frame()
    for (i in 1:length(station_codes)) {
      d <-  getWeatherForDate(
        station_codes[i],
        rollback(Sys.Date(), roll_to_first = T) - months(m, abbreviate = F),
        end_date = rollback(Sys.Date()),
        station_type = "airportCode",
        opt_custom_columns = T,
        custom_columns = c(3, 9, 12, 20, 21)
      )
      d$Date <- as.character(d$Date)
      station <- rep(paste0(station_names[i]), nrow(d))
      d <- data.frame(station, d, stringsAsFactors = F)
      dt <- rbind(dt, d)
    }

    setDT(
      dt,
      keep.rownames = F,
      key = NULL,
      check.names = F
    )

    dt

  } else {
    print("No internet connection available.")
  }
}
