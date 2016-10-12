#' @title Fits markov chains and builds conditions
#' @description Fit and create markov chains for daily weather station conditions
#' @param dt A \code{data.table} created by the function \code{\link{set_conditions}}
#' @return The input \code{data.table} with an extra variable 'mcs' a markov chain sequence of
#' weather conditions
#' @details Probabilistic markov chain sequences are learnt from weather conditions
#' for each month at each station found in the input data.
#' @export
create_markovchains <- function(dt) {
  mcs <- character()

  for (s in unique(dt$station)) {
    for (m in unique(dt$month)) {
      cond_seq <- dt[station == s & month == m]$condition
      priori <- createSequenceMatrix(cond_seq)

      set.seed(1234)
      fit_mc <-
        markovchainFit(
          data = cond_seq,
          method = "mle",
          confidencelevel = 0.95,
          sanitize = T,
          hyperparam = priori
        )

      mc <-
        markovchainSequence(length(cond_seq), fit_mc$estimate, t0 = cond_seq[1])
      mcs <- c(mcs, mc)
    }
  }
  # Assign markov chains back to data.table
  dt[, mcs := mcs]
  dt
}

#' @title Calculates probabilities for numeric variables
#' @description Calculate probability density functions of numeric weather characteristics
#' @param dt A \code{data.table} created by the function \code{\link{create_markovchains}}
#' @return A \code{data.table} of calculated means and standard deviations
#' @details Means and standard deviations are calculated for each weather condition's
#' observed temperature, pressure and humidity over the month for each station.
#' In the event of no monthly variation, a mertic is imputed from the complete
#' range of observations.
#' @export
compute_pdfs <- function(dt) {
  pdfs <- data.table(
    condition = character(),
    station = character(),
    month = integer(),
    t_mean = numeric(),
    t_sd = numeric(),
    p_mean = numeric(),
    p_sd = numeric(),
    h_mean = numeric(),
    h_sd = numeric()
  )

  for (s in unique(dt$station)) {
    for (m in unique(dt$month)) {
      station <- rep(s, length(unique(dt$condition)))
      month <-  rep(m, length(unique(dt$condition)))
      condition <- unique(dt$condition)

      d <- data.table(station, month, condition)

      t_stat <-
        dt[station == s &
             month == m, .(t_mean = mean(Mean_TemperatureC),
                           t_sd = sd(Mean_TemperatureC)), by = .(condition)]
      d <- merge(d, t_stat, by = "condition", all.x = T)

      p_stat <-
        dt[station == s &
             month == m, .(
               p_mean = mean(Mean_Sea_Level_PressurehPa),
               p_sd = sd(Mean_Sea_Level_PressurehPa)
             ), by = .(condition)]
      d <- merge(d, p_stat, by = "condition", all.x = T)

      h_stat <-
        dt[station == s &
             month == m, .(h_mean = mean(Mean_Humidity),
                           h_sd = sd(Mean_Humidity)), by = .(condition)]
      d <- merge(d, h_stat, by = "condition", all.x = T)

      pdfs <- rbind(pdfs, d)
    }
  }

  # Impute missing values by station condition
  cols <- c("station", "condition")
  pdfs[is.na(t_mean), t_mean := pdfs[.BY, mean(t_mean, na.rm = TRUE), on = cols], by = c(cols)]
  pdfs[is.na(t_sd), t_sd := pdfs[.BY, mean(t_sd, na.rm = TRUE), on = cols], by = c(cols)]
  pdfs[is.na(p_mean), p_mean := pdfs[.BY, mean(p_mean, na.rm = TRUE), on = cols], by = c(cols)]
  pdfs[is.na(p_sd), p_sd := pdfs[.BY, mean(p_sd, na.rm = TRUE), on = cols], by = c(cols)]
  pdfs[is.na(h_mean), h_mean := pdfs[.BY, mean(h_mean, na.rm = TRUE), on = cols], by = c(cols)]
  pdfs[is.na(h_sd), h_sd := pdfs[.BY, mean(h_sd, na.rm = TRUE), on = cols], by = c(cols)]

  # Missing values that aren't filled above are imputed using station means
  for (i in seq_along(pdfs))
    set(
      pdfs,
      i = which(is.na(pdfs[[i]])),
      j = i,
      value = mean(i, na.rm = T)
    )
  pdfs
}
