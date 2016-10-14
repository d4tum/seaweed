[![Travis-CI Build Status](https://travis-ci.org/qubz/seaweed.svg?branch=master)](https://travis-ci.org/qubz/seaweed)
# seaweed
Seaweed is an R package that generates plausible and 'semi-realistic' synthetic weather data. Seaweed approximates monthly weather conditions at ten well known Australian locations. Weather conditions are estimated through Markov Chain models learnt from sequences within historical data. Temperature, pressure and humidity are estimated through random sampling using a statistical model of the probable ranges of monthly weather conditions at each location.

Seaweed was developed using R version 3.3.1 (2016-06-21) -- "Bug in Your Hair" on an x86_64 Mac running OS X El Capitan Version 10.11.6. The seaweed algorithm was built with the following packages:

```r
curl (>= 2.1),
data.table (>= 1.9.7),
lubridate (>= 1.6.0),
markovchain (>= 0.6.5.1),
readr (>= 1.0.0),
stats (>= 3.3.1),
weatherData (>= 0.4.5)
```
## Installation
To install seaweed run these two commands one at a time from the R console:
```r
install.packages("devtools")
devtools::install_github("qubz/seaweed")
```
## Example
Once seaweed is installed, copy, paste and run the code below in your favourite R tool.

```r
library(seaweed)

dt <- get_weather(1, F)
dt <- set_conditions(dt)
dt <- create_markovchains(dt)
pdfs <- compute_pdfs(dt)
dt <- generate_metrics(dt, pdfs)
dt <- format_output(dt)
write_output(dt)
```
The last function ```write_output``` in the snippet above will write a file to the working directory containing a dataset of seaweed generated data similar to the sample shown below.
```r
ADL|-34.57,138.31,4|2016-01-01T22:48:44Z|Sunny|19.9|1011.8|35
ASP|-23.48,133.54,541|2016-01-01T00:08:16Z|Cloudy|28.9|1013.1|27
BNE|-27.23,153.08,5|2016-01-01T00:45:55Z|Sunny|23.7|1011.2|62
CBR|-35.17,149.10,577|2016-01-01T12:57:04Z|Cloudy|24.4|1010.8|38
CNS|-16.52,145.45,7|2016-01-01T12:41:31Z|Rain|27.7|1012.2|66
DRW|-12.25,130.54,30|2016-01-01T23:11:23Z|Sunny|29.5|1010.5|66
HBA|-42.49,147.31,27|2016-01-01T01:16:43Z|Sunny|16.8|1016.2|58
MEL|-37.40,144.49,141|2016-01-01T13:40:50Z|Rain|21.4|1021.1|37
PER|-31.56,115.59,13|2016-01-01T16:26:05Z|Sunny|23.9|1012.2|55
SYD|-33.57,151.10,3|2016-01-01T13:48:08Z|Cloudy|24.8|1017.8|68
```
## Testing, Documentation and Final Words
The code was tested using Hadley Wickham's ```testthat``` R package. To re-execute test cases, clone or download the repo and refer to the instructions here - http://r-pkgs.had.co.nz/tests.html.
Documentation for package functions are available through the Help tab of RStudio and within the source itself.

海藻はおいしいです
## License
© Matthew Browne, 2016. Licensed under an Apache-2 license.
