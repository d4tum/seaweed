context("Formatting output of synthetic weather data to fit the specs")

test_that("Output is correct", {
  expect_equal(ncol(format_output(
    generate_metrics(
      create_markovchains(set_conditions(get_weather(1, F))),
      compute_pdfs(create_markovchains(set_conditions(get_weather(
        1, F
      ))))
    )
  )), 7)
  expect_equal(length(unique(
    format_output(generate_metrics(
      create_markovchains(set_conditions(get_weather(1, F))),
      compute_pdfs(create_markovchains(set_conditions(get_weather(
        1, F
      ))))
    ))[]$station
  )), 10)
})