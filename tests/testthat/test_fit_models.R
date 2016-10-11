context("Creating weather condition Markov Chains and Probability Density Functions")

test_that("The markov chain data is correct", {
  expect_equal(ncol(create_markovchains(set_conditions(get_weather(1, F)))), 12)
  expect_equal(sum(is.na(create_markovchains(set_conditions(get_weather(1, F)))[]$mcs)), 0)
})

test_that("PDF data is correct", {
  expect_equal(ncol(compute_pdfs(create_markovchains(set_conditions(get_weather(1, F))))), 9)
  expect_equal(sum(is.na(compute_pdfs(create_markovchains(set_conditions(get_weather(1, F)))))), 0)
})