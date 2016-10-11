context("Creating weather condition Markov Chains and Probability Density Functions")

test_that("The markov chain data is correct", {
  # Number of variables
  expect_equal(ncol(create_markovchains(set_conditions(get_weather(1, F)))), 12)
  # No missing markov chain values
  expect_equal(sum(is.na(create_markovchains(set_conditions(get_weather(1, F)))[]$mcs)), 0)
})

test_that("PDF data is correct", {
  # Number of variables
  expect_equal(ncol(compute_pdfs(create_markovchains(set_conditions(get_weather(1, F))))), 9)
  # No missing pdf values
  expect_equal(sum(is.na(compute_pdfs(create_markovchains(set_conditions(get_weather(1, F)))))), 0)
})