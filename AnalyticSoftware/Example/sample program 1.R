source(file.path(dirname(getwd()), "config", "load_config.R"),
       local = e <- new.env()) # start the framework ----
e$start_log()                  # log start of the job ----

# get input files ----
authors <- read.csv(e$authors)
books <- read.csv(e$books)

# merge and write ----
x <- merge(authors, books, all = TRUE)
write.csv(x = x, file = e$my_output, row.names = FALSE)
write.csv(x = x, file = e$local_copy1)

e$end_log() # log end of the job ----
