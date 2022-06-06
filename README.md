# stager

  A flexible framework for separating R logic from the physical environment.
It solves a set of real-world problems saving time without difficulty or costly overhead.

## Broad challenge

When working with R programs and moving from Windows to a Mac or Linux, my input and output files may need to change from `C:\temp\some file.dat` to `~/local copy/temp/some file.dat`; similarly to database connections and many references to an external environment. It also happens when I move programs between production, development and test environments.

I don't want to change an R program every time I move from Windows to Mac or Linux, because it is error-prone and wastes time. It's even worse if we collaborate because we can't predict what system my colleagues choose. I don't want me or them to go through the pain of changing file names, or worse being in the same code and changing simultaneously in different directions.

If I maintain a program already in production, I don't want to find references to all external production resources and change them so it runs on my local machine. Worse, I don't want to introduce critical bugs by putting the software back and forgetting to change the environment references. There has to be a better way!

30 years ago, I took a solution for granted. I don't want to struggle today.:boom:

## Broad solution

One tiny snippet of code makes my future programs portable.

```r
source(file.path(dirname(getwd()), "config", "load_config.R"),
       local = e <- new.env())
```

Now I can refer to a file as `e$authors` instead of `"/Users/mickmioduszewski/Library/CloudStorage/OneDrive-NSWGOV/stager/stager/AnalyticSoftwareInput/Example/authors.csv"`.

For example:

```r
authors <- read.csv(e$authors)
```

On another system, `authors` might be  `"C:\\Users\\mick\\OneDrive-NSWGOV\\temp\\authors.csv"` with no change to the program.

## `stager` solves portability challenges

`stager` lets you keep my programs unchanged, no matter where they run.

* You work on many projects and each may have many programs.
* Each program wants to use the same files and database connections as the other program.
* Sometimes you want to use the same connections across many projects.
* Every time you take a program from production and run it on a local machine, you want to put files locally and not on the production server. When you put the program back to production, you want it to work on production files.
* You work on a Mac and Windows. Each time you pick up a different machine, the file paths change.
* You don't want to change your programs, but rather, use symbolic names for files and connections.
* You keep the physical names in configuration files.
* You also like to reuse the same functions across programs and projects without having to make packages.

If you are interested in such functionality without a lock-in, proprietory software and freedom to customise, read on.

## Architecture and conventions

We often put software in one central place and conventions help to work together safely. `stager` assumes conventions and folder structure but you can change them easily to your needs.

*Your R program starts with :*

```r
source(file.path(dirname(getwd()), "config", "load_config.R"),
       local = e <- new.env())
```

*Your directory structure is:*

* Some root of software directory
  * `AnalyticSoftware`
    * `config`
      * `config_global.R`
      * `config_platform.R`
      * `load_config.R`
    * project1
      * `config_local.R`
      * ...
  * `AnalyticSoftwareInput`
    * project1
      * ...
  * `AnalyticSoftwareInternal`
    * project1
      * some project 1.csv
      * ...
  * `AnalyticSoftwareOutput`
    * project1
      * ...

## How it works and how to work with it

By running the code snippet above, we instantiate the framework, run configurations and load useful functions.

You can now refer to files in a symbolic way because `e$authors` has the pysical path.

```r
authors <- read.csv(e$authors)
```

The framework does not depend on any external packages and can run with R v4.1 or higher. The flow is as follows:

* The main program executes `load_config.R` and stores values & functions in an environment. In the above example it's simply `e`, but you can name it any way you like it.
  1. Load `config_platform`, which creates variables relating to a specific execution environment, e.g. production on Linux or development on a Mac. The values are stored in `e`.
  2. Load `config_global.R`, which stores values you wish to reuse across projects but not platforms.
  3. Load `config_local.R`, which stores values you wish to reuse in your project.

  The idea is that when you move a project to production, you only move `config_local.R`. The production box already has `config_platform` and `config_global.R`.

For example, a target environment like test on a Mac defines a root folder for your files in `config_platform`:

  ```r
  fs_root = "~/Library/CloudStorage/OneDrive-NSWGOV"
  ```

The `config_global.R` defines the usual directory structure.

```r
app_root <- dirname(dirname(getwd()))
app_input_dir <- file.path(app_root, "AnalyticSoftwareInput", app_folder)
```

You define a logical file `authors` in `config_local.R`

```r
authors <- file.path(app_input_dir, "authors.csv")
```

No matter which execution environment you are in, the file always resides in the input directory on that environment; the program hasn't changed.

You may wish to be much more specific and define the file by reusing variable from `config_platform` in the following way:

```r
authors <- file.path(fs_root,"some input folder", "authors.csv")
```

In any case, the program has not changed, and the file path is right for the environment and you always access it by `e$authors`. On a different execution machine, the `config_platform` uses different paths, and the file magically uses them.
