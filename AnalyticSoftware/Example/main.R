# expects the working directory = project directory
rm(list = ls())
source(file.path(dirname(getwd()), "config", "load_config.R"),
       local = e <- new.env())

e$start_log()

e$end_log()
