# stager

`stager` is a flexible framework for separating R logic from its physical environment. It solves a set of real-world problems saving time without difficulty or costly overhead.

If you run the same program that uses files or database conenctions on different machines, operating systems, or share with your colleagues, this framework may save you time and reduce software fragility.

It lets you reduce cognitive load by using conventions and reuse simple facilities like performance logging.

This framework does not help with writing scripts that don't need to be portable, shared with other people, or use a standard way of structuring project files.

---

## Quick examples of value for the impatient

### File naming portability

A typical example on the web will show that you can simply write a file on a Mac in the following way.

```r
write.csv(x, "~/output/temp/some file.dat")
```

You then choose to deploy it to production on a Windows production machine and it doesn't work unless you change **the program** to

```r
write.csv(x, "C:\\temp\\some file.dat")
```

It's error prone and wastes time. It's much better for the program to not have to change no matter where it runs. It's better to write symbolically,

```r
write.csv(x, e$authors)
```

and keep the definition of `e$authors` in an external configuration file. Now you can flip between operating systems, production, development, and test environments without changing the program. It saves time and debugging pain for you and your colleagues.

If I maintain a program already in production, I don't want to find references to all external production resources and change them so it runs on my local machine. Worse, I don't want to introduce critical bugs by putting the software back and forgetting to change the environment references. There has to be a better way!

---

### Reuse of useful facilities

Most of the time we don't log performance of out jobs until we have a problem. When we do, we wish we had a history of how the job used to run and compare to how it runs today.

```r
e$start_log()
your program goes here...
e$end_log()
```

The above fragment will log each job instance, so you can use it later, and the output is in a csv file e.g. [example log file](AnalyticSoftwareInternal/Example/Example.csv)

You could produce a historical performance picture

![sample](AnalyticSoftwareInternal/Example/log%20picture.png)

---

## Broad solution description

`stager` lets you keep programs unchanged, no matter where they run and make it easier to reuse artefacts. I see the following needs, which are often unfulfiled.

* You work on many projects and each may have many programs. You wish to reuse file definitions, database connections or functions between programs.

* Sometimes you want to use the same files or connections across many projects.
* Every time you take a program from production and run it on a local machine, you want to put files locally and not on the production server. When you put the program back to production, you want it to work on production files again without changing `R` code.
* You work on a Mac and Windows. Each time you pick up a different machine, the file paths change, but you want the program to stay the same. You don't want to change your programs, but rather, use symbolic names for files and connections.
* You want keep the physical names in configuration files so when the program moves, it uses these physical names automatically.
* You also want all project structures to have a common directory structure so they are easy to navigate.
* You want to have ready-made functions that work in any project or program without having to rewrite them again.

If you are interested in such functionality without a lock-in, proprietory software and freedom to customise, read on.

One tiny snippet of code makes our future programs portable and makes it easy to reuse functions without needing to build packages.

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

---

---

## Architecture and conventions

We often put software in one central place and conventions help to work together safely. `stager` assumes conventions and folder structure but you can change them easily to your needs.

**The framework currently assumes that the project's working directory is where the project has the main file and checks for it.** You can change or remove that dependency if you feel strongly about it.

*Your R program starts with :

```r
source(file.path(dirname(getwd()), "config", "load_config.R"),
       local = e <- new.env())
```

Please see the [sample program here](AnalyticSoftware/Example/sample%20program%201.R)

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

---

The project structure is defined in `config_global.R`. If you wish to change the folder names or structure, change `config_global.R`.

You define symbolics specific to a project in `config_local.R`.

`config_local.R` or `config_global.R` may wish to reuse file roots or conenctions defined in `config_platform.R`.

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

Enjoy :v:
