library(ggplot2)
library(scales)
library(lubridate)
source(file.path(dirname(getwd()), "config", "load_config.R"),
       local = e <- new.env()) # start the framework ----
e$start_log()                  # log start of the job ----

log <- read.csv(e$log_file)
ggplot(log, aes(x = ymd_hms(start), y = duration, colour = program)) +
  geom_line() +
  xlab("when run (time)") +
  ylab("duration (seconds)")

e$end_log() # log end of the job ----
