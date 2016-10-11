#' @title Fits markov chains and build conditions
#' @description Fit and create markov chains for daily weather station conditions
#' @param dt A \code{data.table} created by the function \code{\link{set_conditions}}
#' @return The input \code{data.table} with an extra variable 'mcs' a markov chain sequence of
#' weather conditions
#' @details Probabilistic markov chain sequences are learnt from weather conditions
#' for each month at each station found in the input data.
#' @examples
#' \dontrun{head(create_markovchains(dt))}
#' station       Date Mean_TemperatureC Mean_Humidity Mean_Sea_Level_PressurehPa Precipitationmm CloudCover year month day condition    mcs
#' HBA 2016-09-01                12            57                       1012            0.51          3 2016     9   1      Rain     Cloudy
#' HBA 2016-09-02                 9            76                       1013            0.00          5 2016     9   2    Cloudy       Rain
#' HBA 2016-09-03                 8            84                       1005            0.25          5 2016     9   3      Rain       Rain
#' HBA 2016-09-04                12            52                       1010            0.00          3 2016     9   4     Sunny       Rain
#' HBA 2016-09-05                14            51                       1019            0.00          3 2016     9   5     Sunny      Sunny
#' HBA 2016-09-06                14            53                       1022            0.00          4 2016     9   6    Cloudy       Rain
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
#' @examples
#' \dontrun{head(compute_pdfs(dt))}
#' condition station month t_mean  t_sd   p_mean     p_sd   h_mean     h_sd
#' Cloudy   HBA     9 11.35714 2.239751 1014.429 5.079586 69.35714 9.919733
#' Rain     HBA     9 11.10000 2.330951 1006.000 7.630349 73.60000 9.788883
#' Sunny    HBA     9 11.66667 1.505545 1012.667 9.521905 60.50000 9.731393
#' Cloudy   MEL     9 12.11111 1.536591 1017.333 8.000000 69.88889 4.512329
#' Rain     MEL     9 11.10000 1.071153 1010.800 8.401754 78.20000 8.294577
#' Sunny    MEL     9 17.00000 5.000000 1019.000 7.000000 61.00000 9.000000
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
