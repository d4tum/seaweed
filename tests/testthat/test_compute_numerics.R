context("Computing temperature, pressure and humitidy from Probability Density Functions")

test_that("generate_metrics returns expected results", {
  # Number of variables
  expect_equal(ncol(generate_metrics(
    create_markovchains(set_conditions(get_weather(1, F))),
    compute_pdfs(create_markovchains(set_conditions(get_weather(
      1, F
    ))))
  )), 9)
  # New variables
  expect_equal(sum(
    names(generate_metrics(
      create_markovchains(set_conditions(get_weather(1, F))),
      compute_pdfs(create_markovchains(set_conditions(get_weather(
        1, F
      ))))
    )) %in% c("temperature", "pressure", "humidity")
  ), 3)
  # Missing values
  expect_equal(sum(is.na(
    generate_metrics(
      create_markovchains(set_conditions(get_weather(1, F))),
      compute_pdfs(create_markovchains(set_conditions(get_weather(
        1, F
      ))))
    )
  )), 0)
})
