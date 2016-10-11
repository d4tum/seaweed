context("Setting weather conditions from commonsensical rules relating to weather measurements")

test_that("set_conditons are all set correctly", {
  # Columns
  expect_equal(ncol(set_conditions(get_weather(1, F))), 11)
  # Conditions
  expect_equal(length(unique(set_conditions(get_weather(1, F))[]$condition)), 3)
  # Missing conditions
  expect_equal(sum(is.na(set_conditions(get_weather(1, F))[]$condition)), 0)
})