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

### hfhf
