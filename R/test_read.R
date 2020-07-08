library(tidyverse)
library(readr)
library(magrittr)
library(reticulate)

library(httr)
library(XML)
library(bitops)


use_miniconda(condaenv = 'r-reticulate')    

source_python(file = './python/irods_connect.py')
source("./R/iRODS_API.R")

res <- context$getDataObjectContents("/nluu12p/home/research-keestest/test.txt", FALSE)
res

read_yoda_python <- function(file_name) {
  session <- create_irods_session()             # python function to create a session object
  objs    <- py_get_attr(session, name = 'data_objects')
  obj     <- objs$get(sprintf('/nluu12p/home/research-keestest/%s', file_name))
  content <- obj$open()$read()$decode() # reticulate translates this to 'obj.open().read().decode()'
}



sizes_MB <- c(1) #, 5, 10) #,50, 100, 500)

timings_tbl <- tibble(
  system     = character(),
  storage_connection = character(),
  command    = character(),
  file_MB    = numeric(),
  timing     = numeric()
)

timings_row <- list()

timings_row$system <- 'Research Cloud'

# ssd/data
#
timings_row$storage_connection <- 'ssd'
timings_row$command    <- 'read'
for (N in sizes_MB) {
  timings_row$file_MB = N
  timings_row$timing <- system.time({
     data_set <- read_csv(file = file.path(getwd(), 'data', sprintf('yoda_data_%dMB', N)))})[3]
  timings_tbl %<>% rbind(as_tibble(timings_row))
}

# ssd/data
#
timings_row$storage_connection <- 'Research Drive'
timings_row$command    <- 'read'
for (N in sizes_MB) {
  timings_row$file_MB = N
  timings_row$timing <- system.time({
    data_set <- read_csv(file = file.path('/home/kveijden/researchdrive', 'data', sprintf('yoda_data_%dMB', N)))})[3]
  timings_tbl %<>% rbind(as_tibble(timings_row))
}

# YODA python client api
#
timings_row$storage_connection <- 'YODA - python'
timings_row$command    <- 'read'
for (N in sizes_MB) {
  timings_row$file_MB = N
  timings_row$timing <- system.time({
    yoda_file_name   <- sprintf('yoda_data_%dMB', N)
    data_set <- read_csv(file = read_yoda_python(yoda_file_name))
  })[3]
  timings_tbl %<>% rbind(as_tibble(timings_row))
}

# YODA R client api
#
timings_row$storage_connection <- 'YODA - R'
timings_row$command    <- 'read'
for (N in sizes_MB) {
  timings_row$file_MB = N
  timings_row$timing <- system.time({
    context <- IrodsContext("localhost", "8080", "k.vaneijden@uu.nl")
    
    yoda_file_path   <- sprintf('/nluu12p/home/research-keestest/yoda_data_%dMB', N)
    file <- context$getDataObjectContents(yoda_file_path, FALSE)
    data_set <- read_csv(file = file)
  })[3]
  timings_tbl %<>% rbind(as_tibble(timings_row))
}

timings_row$storage_connection <- 'YODA - igets'
timings_row$command    <- 'read'

for (N in sizes_MB) {
  timings_row$file_MB = N
  timings_row$timing <- system.time({
    yoda_file_name   <- sprintf('/nluu12p/research-keestest/data/yoda_data_%dMB.csv', N)
    system2(command = '/Applications/icommands/iget',
      args=c('/nluu12p/home/research-keestest/yoda_data_10MB', './temp.csv'))
    data_set <- read_csv(file = './temp.csv')
    file.remove(./temp.csv)
  })[3]
  timings_tbl %<>% rbind(as_tibble(timings_row))
}

