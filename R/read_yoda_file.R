library(reticulate)

library(readr)



# Script to read a file from Yoda into R session

use_miniconda(condaenv = 'r-reticulate')    

source_python(file = './python/irods_connect.py')

session <- create_irods_session()             # python function to create a session object


objs <- py_get_attr(session, name = 'data_objects')

obj <- objs$get('/nluu12p/home/research-keestest/parrot.png')

f <- obj$open()$read()$decode() # reticulate translates this to 'obj.open().read().decode()'
                                # return value is a character stream


data <- read_csv(file = f)      # just normal R function call

load.image(f)

