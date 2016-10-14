#' @title Write generated weather data to file
#' @description Write a pipe delimeted file to the working directory
#' @param dt A \code{data.table} created by the function \code{\link{format_output}}
#' @details The synthetic Australian weather data generated upstream is writted out
#' to a pipe delimited file in the project root directory. The file is named
#' "seaweed_generated.dat" and it's extension is .dat. The file's data layout conforms
#' to the format applied by the function \code{\link{format_output}}.
#' @export
#' @import readr
write_output <- function(dt) {
  write_delim(dt,
              "seaweed_generated.dat",
              delim = "|",
              col_names = F)
  print(paste0("Seaweed data written to file here - ", getwd(), "/seaweed_gen.dat"))
}