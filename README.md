# YODA-R

<<<<<<< HEAD
Package for integrating YODA in an R compute environment

## Installation
clone this repository

### Conda and Python modules
Install python

```pip install python-irodsclient```


### Connecting to YODA data repository
Create and edit irods_environment.json
Manage ownership of the file
Add irods password to environment file


### R packages and set-up
```install.packages("reticulate")```  
```install.packages("readr")```

### Start Rstudio
open read_yoda_file.R





### R irods api 
This API seems not regularly maintained.


Package for integrating YODA in an R compute environment.

Currently using the [reticulate](https://rstudio.github.io/reticulate/) package of R in combination with the [python client](https://github.com/irods/python-irodsclient) seems the most promising option.

