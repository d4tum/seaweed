context("Using get_weather to retrieve historical weather data by local or online API")

test_that("get_weather's offline local data returns the correct data", {
  expect_equal(ncol(get_weather(1, F)), 7)
  expect_equal(is.data.table(get_weather(1, F)), T)
  expect_equal(length(unique(lubridate::month((lubridate::date(get_weather(1, F)[]$Date))))), 1)
  expect_equal(length(unique(get_weather(1, F)[]$station)), 10)
})

# test_that("get_weather's online API data returns the correct data", {
#   expect_equal(ncol(get_weather(1, T)), 7)
#   expect_equal(is.data.table(get_weather(1, T)), T)
#   expect_equal(length(unique(lubridate::month((lubridate::date(get_weather(1, T)[]$Date))))), 1)
#   expect_equal(length(unique(get_weather(1, T)[]$station)), 10)
# })