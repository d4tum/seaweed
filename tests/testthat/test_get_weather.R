context("Using get_weather to retrieve historical weather data by local or online API")

test_that("get_weather's offline local data returns the correct data", {
  # Number of variables
  expect_equal(ncol(get_weather(1, F)), 7)
  # Typeof
  expect_equal(is.data.table(get_weather(1, F)), T)
  # Number of months
  expect_equal(length(unique(lubridate::month((lubridate::date(get_weather(1, F)[]$Date))))), 1)
  # Number of stations
  expect_equal(length(unique(get_weather(1, F)[]$station)), 10)
})

## Uncomment this to test the API - MUST HAVE INTERNET - TAKES TIME TO FINISH
# test_that("get_weather's online API data returns the correct data", {
#   # Number of variables
#   expect_equal(ncol(get_weather(1, T)), 7)
#   # Typeof
#   expect_equal(is.data.table(get_weather(1, T)), T)
#   # Number of months
#   expect_equal(length(unique(lubridate::month((lubridate::date(get_weather(1, T)[]$Date))))), 1)
#   # Number of stations
#   expect_equal(length(unique(get_weather(1, T)[]$station)), 10)
# })