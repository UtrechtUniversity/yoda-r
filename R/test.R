library(reticulate)
library(ggplot2)

setwd('/home/jelle/Repositories/yoda-r/R')
py_config()

source_python("../python/read_irods.py")
df <- read_file("testdata.csv", "/nluu6p/home/research-zwerts", ',')

ggplot(df, aes(id, value)) + geom_point()
