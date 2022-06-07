debug <- FALSE

# global inter-project directory locations ####

app_dir <- app_wd <- getwd()
app_folder <- basename(getwd())
app_root <- dirname(dirname(getwd()))
app_input_dir <- file.path(app_root, "AnalyticSoftwareInput", app_folder)
app_output_dir <- file.path(app_root, "AnalyticSoftwareOutput", app_folder)
app_internal_dir <- file.path(app_root, "AnalyticSoftwareInternal", app_folder)
log_file <- file.path(app_internal_dir, paste0(app_folder, ".csv"))


# get the main execution file name ####

app_main_src_fl <- grep("--file=", x = commandArgs(), value = TRUE)
app_main_src_fl <- strsplit(app_main_src_fl, "=")
if (length(app_main_src_fl) == 0) {
  # we are in RStudio
  app_main_src_fl <-
    basename(rstudioapi::getSourceEditorContext()$path)
  message(paste("INFO: Main source file is", app_main_src_fl))
} else if ((length(app_main_src_fl) == 1) &&
           (length(app_main_src_fl[[1]]) == 2)) {
  # we are in batch
  app_main_src_fl <- app_main_src_fl[[1]][2]
  message(paste("INFO: Main source file is", app_main_src_fl))
} else {
  stop("Unexpected arguments giving ambiguous main file name")
}


# A sanity check for working directory ####

message(paste("INFO: Working directory is", app_dir))
if (!file.exists(file.path(app_dir, app_main_src_fl))) {
  stop(paste("The working directory does not contain the main script",
             "this framework might not be for you..."))
}


# Default relevant dates. ####

def_dt <- list(today = Sys.Date())
def_dt <- within(def_dt, {
  fin_year_h <- as.integer(format(today, "%Y"))
  if (as.integer(format(Sys.Date(), "%m")) < 7) {
    fin_year_h <- fin_year_h - 1
  }
  fin_year_t <- fin_year_h + 1
  fin_year_l <- fin_year_h - 4
  bound_h <- as.Date(paste0(fin_year_h,     "-06-30"))
  bound_l <- as.Date(paste0(fin_year_l - 1, "-07-01"))
})

# Handy debug messaging ####
dmsg <- function(msg = NULL, env = e) {
  if (env$debug) {
    message(paste("INFO:", msg, Sys.time()))
  }
  invisible(NULL)
}
