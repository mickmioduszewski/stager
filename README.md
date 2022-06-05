# stager

  A flexible framework for separating R logic from the physical environment.
This R framework aims to practically solve a set of real problems with minimal effort, without difficulty and costly overhead.

## Broad challenge

When working with R programs and moving from Windows to a Mac or Linux, my input and output files may need to change from `C:\temp\some file.dat` to `~/local copy/temp/some file.dat`; similarly to database connections and many references to an external environment.

I don't want to change an R program every time I move from Windows to Mac or Linux, because it is error-prone and wastes time. It's even worse if we collaborate because we can't predict what system my colleagues choose. I don't want me or them to go through the pain of changing file names to continue to work, or worse being in the same code and changing simultaneously in different directions.

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

## Framework detail
