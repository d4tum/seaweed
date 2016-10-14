context("Formatting output of synthetic weather data")

test_that("Output is correct", {
  # All variables
  expect_equal(ncol(format_output(
    generate_metrics(
      create_markovchains(set_conditions(get_weather(1, F))),
      compute_pdfs(create_markovchains(set_conditions(get_weather(
        1, F
      ))))
    )
  )), 7)
  # All stations
  expect_equal(length(unique(
    format_output(generate_metrics(
      create_markovchains(set_conditions(get_weather(1, F))),
      compute_pdfs(create_markovchains(set_conditions(get_weather(
        1, F
      ))))
    ))[]$station
  )), 10)
})