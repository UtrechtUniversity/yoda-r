install.packages("httr")
install.packages("XML")
install.packages("bitops")

library(httr)
library(XML)
library(bitops)



source("./R/iRODS_API.R")
context <- IrodsContext("localhost", "8080", "k.vaneijden@uu.nl")

res <- context$getDataObjectContents("/nluu12p/home/research-keestest/test.txt", FALSE)
res

