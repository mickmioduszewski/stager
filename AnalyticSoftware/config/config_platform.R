platform <- "default"

machine_specific <-
  list(
    default = list(fs_root = "~/Library/CloudStorage/OneDrive-NSWGOV",
                   fs_root_local = "~/TEMP"),
    MickWinHome = list(fs_root = "~/Library/CloudStorage/OneDrive-NSWGOV",
                       fs_root_local = "~/TEMP")
  )


if (is.null(machine_specific[[platform]])) stop("Platform file misconfigured")
machine_specific <- machine_specific[[platform]]
for (i in names(machine_specific)) assign(i, machine_specific[[i]])
