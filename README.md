# SynthEtic Australian WEathEr Data Generator - seaweed
Seaweed R package is a synthetic Australian weather data generator that approximates monthly weather conditions at ten of Australia's most well known locations. Weather conditions, as labels, are estimated through probabilistic Markov Chains learnt from historical patterns. Temperature, pressure and humidity are estimated by random sampling monthly probability density functions derived from the historical measurements at each location.

## Installation
Seaweed was developed using R version 3.3.1 (2016-06-21) -- "Bug in Your Hair" on an x86_64 Mac running OS X El Capitan Version 10.11.6. The seaweed algorithm was built with the following packages:

```r
data.table (>= 1.9.7),
devtools (>= 1.12.0),
lubridate (>= 1.6.0),
markovchain (>= 0.6.5.1),
readr (>= 1.0.0),
weatherData (>= 0.4.5),
```

They should be installed using RStudio by executing the sequence of commands shown below one line at a time:

```r
install.packages("devtools")
install.packages("data.table", type = "source", repos = "http://Rdatatable.github.io/data.table")
install.packages("lubridate")
install.packages("markovchain")
install.packages("readr")
devtools::install_github("Ram-N/weatherData")
```
After successfully satisfying the above package dependancies, execute the following in R to install the seaweed package:

```r
devtools::install_github("qubz/seaweed")
```
## Example

Once the seaweed is installed, copy and paste the code below into your favorite R tool. Make sure you __change the path__ in ```write_delim``` to a suitable location __before you run the code__.

```r
library(seaweed)

dt <- get_weather(1, F)
dt <- set_conditions(dt)
dt <- create_markovchains(dt)
pdfs <- compute_pdfs(dt)
dt <- generate_metrics(dt, pdfs)
dt <- format_output(dt)

write_delim(dt, "<your own path>/syntheic_weather_data.dat",
            delim = "|",
            col_names = F)
```
The file created will contain a synthetic Australian weather dataset similar to the sample shown below -
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
The code was tested using Hadley Wickham's ```testthat``` R package. To re-execute test cases, download the source and refer to the instructions here - http://r-pkgs.had.co.nz/tests.html
Documentation for package functions are available through the Help tab of RStudio and in the source itself.

海藻はおいしいです
