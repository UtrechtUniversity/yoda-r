library(stringi)
library(tidyverse)
library(readr)

N <- 25900
file_sizes <- c(1, 5, 10, 50, 100, 500)

for (f in file_sizes) {
  test_data <- tibble(
    var1 = stri_rand_strings(N*f, 10, pattern = "[A-Za-z0-9]"),
    var2 = sample(c(TRUE,FALSE), N*f, replace = TRUE),
    var3 = sample.int(10000L, N*f, replace = TRUE),
    var4 = rnorm(N*f, sd = 1000)
  )
  write_csv(x = test_data, 
    file.path(getwd(), 'data', sprintf('yoda_data_%dMB.csv', f))
  )
}

