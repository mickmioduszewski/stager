get_config <- function() {
#load platform, global & local configuration ----

  cfg_loc <-
    list(
      p = getwd() |> dirname() |> file.path("config", "config_platform.R"),
      g = getwd() |> dirname() |> file.path("config", "config_global.R"),
      l = getwd() |> file.path("config_local.R")
    )
  if (file.exists(cfg_loc$p)) source(cfg_loc$p, local = parent.frame())
  else paste0("platform configuraion file", cfg_loc$p, "' does not exist") |>
    warning()
  if (file.exists(cfg_loc$g)) source(cfg_loc$g, local = parent.frame())
  else paste0("global configuraion file", cfg_loc$g, "' does not exist") |>
    warning()
  if (file.exists(cfg_loc$l)) source(cfg_loc$l, local = parent.frame())
  else paste0("local configuraion file", cfg_loc$l, "' does not exist") |>
    warning()

#create input and output standard directories if not existing ----
  if (!dir.exists(app_input_dir))
    dir.create(app_input_dir, recursive = TRUE)
  if (!dir.exists(app_output_dir))
    dir.create(app_output_dir, recursive = TRUE)
  if (!dir.exists(app_internal_dir))
    dir.create(app_internal_dir, recursive = TRUE)
}
#logging functions ----
start_log <- function() {
  if (!dir.exists(app_internal_dir))
    dir.create(app_internal_dir, recursive = TRUE)

  new_temp <- data.frame(
    project = app_folder,
    program = app_main_src_fl,
    start = format(Sys.time()#,
                   #tz = Sys.timezone(),
                   #usetz = TRUE
                   ),
    end = as.character(NA),
    duration = 0.0,
    stringsAsFactors = FALSE
  )
  #log_file <-
    #file.path(app_internal_dir, paste0(app_folder, ".csv"))

  if (file.exists(log_file)) {
    temp <- read.csv(log_file)
    new_temp <- rbind(new_temp, temp)
  }
  write.csv(x = new_temp,
            file = log_file,
            row.names = FALSE)
}
end_log <- function() {
  end_time <- Sys.time()
  #log_file <-
    #file.path(app_internal_dir, paste0(app_folder, ".csv"))

  temp <- read.csv(log_file)
  start_time <- as.POSIXlt(temp$start[1], tz = Sys.timezone())
  temp$end[1] <- format(end_time#, tz = Sys.timezone(), usetz = TRUE
                        )
  temp$duration[1] <-
    difftime(end_time, start_time, units = "secs")
  write.csv(x = temp,
            file = log_file,
            row.names = FALSE)

  duration <- difftime(end_time, start_time)

  print(duration)
}

get_config()
