## An opinionated introduction to R

by the [Svardal lab](svardallab@gmail.com), based on material by [Alexandros Bantounas](Alexandros.Bantounas@uantwerpen.be) and contributions by [Curro Campuzano](curro.campuzanojimenez@uantwerpen.be) [^1].

[^1]: I have added some footnotes for those who have more experience. Feel free to ignore them!

## What is R?

**_R_** is a programming language for statistical computing and data visualization.[^2]

[^2]: It is not a general programming language (so don't torture yourself by writing a command-line-application or an API.)

It has a _very_ rich ecosystem of packages (i.e. collections of pre-written code) to perform statistical and genomic analysis.

## Work with R

- You can enter interactive mode by executing `R` in the command line.
- You can run a script executing `Rscript script.R > output.txt` in the command line.
- You can use an IDE to write and execute code, for example [Rstudio](https://posit.co/download/rstudio-desktop/)

## Troubleshooting R

If you can't install R:

- You can play with a limited version of RStudio that runs in your browser[^3] at <https://webr.r-wasm.org/latest/>

- Or execute code directly in the cluster.

[^3]: Not in the cloud, in your browser via web assembly.

Has anyone had any problems?

## Typical R workflow

1.  Define/create a folder to be used as the working directory.

2.  Open R Studio and create a new Script file (menu). You can also create a project (button top right).

3.  Set the working directory to your prepared folder.

4.  Write your script in the script window and save it. Send selected code line(s) to the console using ctrl+Return (PC).

5.  Conduct analyses, save the script, outputs, and graphs. When the entire analysis is ready, you can execute the code and output into a notebook.

## RStudio IDE

Unlike Jupyter notebooks, Quarto notebooks (formerly known as RMarkdown files) are plain text documents. You can easily convert them to various formats and work with them directly in RStudio. For more details on using Quarto in RStudio, check out the official guide:

https://quarto.org/docs/get-started/hello/rstudio.html

## Basic syntax: Operators

```{r, echo=TRUE}
# You can comment your code starting a line with `#`
# 1 + 1
# You have basic operators such as
1 + 1 / 2
1 != 1
(1 + 1) > 3
# You can assign to variables using `<-`, `->`, or `=`
a <- 1234
1 + 1 -> b
c <- "abcd" # Strings can be created using quotes
d <- TRUE
```

## Key objects: atomic vectors and lists

In `R`, _almost everything_ is an **atomic vector**, a **list**, or a function.

```{r, echo=TRUE}
# All of the elements in an atomic vector are only of one type
c(1, 2, 3) # Numeric vector
c(T, F, T) # Logical vector
c("A", "C", "T", "G") # Character vector
# Lists can have different types of items in different components
mylist <- list(1, 2, "A")
```

## Key objects: using functions

Functions in R are reusable blocks of code that take inputs (arguments), perform a specific task, and return an output.

```{r, echo=TRUE}
vals <- c(1, 2, 5, 1, 2)
c(vals, 13)
max(vals) # Max
which.min(vals) # Argmin
# Random values from a Uniform(a, b)
vals <- runif(n = 100, min = 0, max = 10)
# A stats summary of a vector
summary(vals)
```

## Documentation

You can read the documentation of any function by typing `?` in front of the function.

```{r, echo =TRUE}
?max
```

## Key objects: writing functions

Making your own functions allows you to automate common tasks in a more powerful way than copy-pasting.

```{r, echo=TRUE}
z_score <- function(x) {
    (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}
```

## Loops in R

Loops allow us to iteratively apply a function on a list of inputs. The main loop used in this tutorial is the **for** loop [^4]:

[^4]: A more _idiomatic_ approach in `R` would be to use `apply`, `map` or `walk` functions.

```{r, echo=TRUE}
for (j in 1:5) {
    print(j^2)
}
```

## Packages

R packages are sets of custom functions and object classes that can be installed and used. Most R packages are deposited in the CRAN repository[^5].

[^5]: `Pak` is (yet) another approach to package installation that installs R packages from CRAN, Bioconductor, GitHub, URLs, git repositories, local files and directories. You can use the syntax `pak::pak(c("tidyverse", "ggtree"))`.

```{r, echo=TRUE, eval=FALSE}
# Install packages from CRAN
install.packages("tidyverse")
# Install packages from Bioconductor
if (!require("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
BiocManager::install(ggtree)
```

## The tidyverse

The `R` language has evolved quite a lot since it was created. [^6] A "modern" style of writing `R` code is promoted by the `tidyverse` package.

[^6]: The R core has almost no breaking changes with its predecessor `S`, which was created in the 70s.

```{r, echo=TRUE}
library(tidyverse)
```

The syntax `library(package_name)` _attaches_ names to your active session and lets you refer to them.

## Loading data

Often, you want to load data generated _outside_ your R session (by others or a genomics pipeline)[^7]. Tables are encoded as data frames, which are _lists of equal-length vectors_.

[^7]: In Tidyverse, data frames are of type `tibble`. They have very similar behavior but (1) allow lazy operations (without you noticing it) and (2) complain more (which is a good thing!).

```{r, echo=TRUE}
# Raw data URLs (but it could be local paths also)
uri_adelie <- "https://portal.edirepository.org/nis/dataviewer?packageid=knb-lter-pal.219.3&entityid=002f3893385f710df69eeebe893144ff"
df <- read_csv(uri_adelie)
```

## Inspecting the data

```{r, echo=TRUE}
dim(df) # This shows the dimension of the dataframe
colnames(df) # The names of the columns
glimpse(df) # Quick overview
```

## Selecting and subsetting

```{r, echo = TRUE}
x <- df[1, ] # Accessing the first row.
x <- df[, 1] # Accessing the first column.
df[, "studyName"] # Accessing the column by name
df$Species[1] # Accesing using the `$` operator
```

## Advanced dataset manipulation

For more advanced data manipulations, you can use functions from the `dplyr` package and **chain** operations by passing the output of one function as input to the next one using the `%>%` pipe operator.

```{r, echo = TRUE}
c(1, 2, NA, 5) %>%
    sum() %>%
    as.character()
c(1, 2, NA, 5) %>%
    sum(na.rm = T) %>%
    as.character()
```

## Example of `dplyr` manipulation

Could you guess what is happening exactly?

```{r, echo = TRUE}
df %>%
    mutate(Sex = tolower(Sex)) %>%
    filter(Sex == "female") %>%
    filter(Island %in% c("Torgersen", "Biscoe", "Dream")) %>%
    filter(!is.na(Stage)) %>%
    select("Island", starts_with("Culmen")) %>%
    slice_sample(n = 5)
```

## Example of `dplyr` manipulation

```{r, echo = TRUE}
df2 <- df %>%
    # mutate() creates/modifies columns - here converting Sex to lowercase
    # ensures consistent formatting (e.g., "FEMALE", "Female" -> "female")
    mutate(Sex = tolower(Sex)) %>%
    # filter() keeps rows matching conditions - selecting only female penguins
    # this removes all male penguins from the dataset
    filter(Sex == "female") %>%
    # %in% operator checks if values match any element in a vector
    # keeping only penguins from Torgersen, Biscoe, or Dream islands
    filter(Island %in% c("Torgersen", "Biscoe", "Dream")) %>%
    # !is.na() keeps only non-missing values in the Stage column
    # this removes incomplete records without Stage information
    filter(!is.na(Stage)) %>%
    # select() specifies which columns to keep in the output
    # starts_with() is a helper that matches column names by prefix
    # this keeps Island and all columns starting with "Culmen" (e.g., Culmen_Length_mm)
    select("Island", starts_with("Culmen")) %>%
    # slice_sample() randomly selects rows from the dataset
    # n=5 specifies exactly 5 rows to be randomly selected
    # useful for creating examples or smaller representative samples
    slice_sample(n = 5)
```

## Plotting using base R

In base R, there are many convenient plots that just "work" when you attempt to plot different objects. However, for `final` plots, it is not always the most convenient.

## Plot in base R example (1/2)

```{r, echo=TRUE}
cols <- c("Culmen Length (mm)", "Flipper Length (mm)", "Body Mass (g)")
plot(df[, cols])
```

## Plot in base R example (2/2)

```{r, echo=TRUE}
hist(df[["Culmen Length (mm)"]],
    main = "Distribution of Culmen Length",
    xlab = "Culmen Length (mm)",
    col = "skyblue",
    border = "black",
)
```

## Plotting using `ggplot` : A basic plot

```{r, echo=TRUE, eval=FALSE}
df %>%
    # Discard individuals with unknown sex
    filter(!is.na(Sex)) %>%
    # Create a plot with Body mass in the x-axis and fill by Sex
    ggplot(aes(x = `Body Mass (g)`, fill = Sex)) +
    # Plot an histogram
    geom_histogram(color = "black", alpha = 0.8) +
    xlab("Count") + # X-axis label
    ggtitle("Histogram example") # Add title
```

## Plotting using `ggplot`: A basic plot

```{r}
p1 <- df %>%
    # Discard individuals with unknown sex
    filter(!is.na(Sex)) %>%
    # Create a plot with Body mass in the x-axis and fill by Sex
    ggplot(aes(x = `Body Mass (g)`, fill = Sex)) +
    # Plot an histogram
    geom_histogram(alpha = 0.8, color = "black") +
    xlab("Count") + # X-axis label
    ggtitle("Histogram example") # Add title
p1
```

## `ggplot` basics [^8]

1. Data to create the plot
2. Mappings of data to the graph (aesthetic mapping)
3. What type of graph we want to use (`geom_` family of functions).
4. Final adjustments (`scale_` and `theme_` family of functions among others).

[^8]: As mentioned before, (almost) everything in R is a list. Try executing `glimpse(p1)`.

## Plotting using `ggplot`: More than one geom

```{r, echo=TRUE, eval=FALSE}
df %>%
    filter(!is.na(Sex)) %>%
    ggplot(aes(x = `Flipper Length (mm)`, y = `Body Mass (g)`, colour = Sex)) +
    geom_smooth(method = lm, linetype = "dashed") +
    geom_point(shape = 1) + # shape = 1 is data independent!
    facet_wrap(~Island) +
    ggtitle(
        label = "Flipper Length versus Body Mass",
        subtitle = "We don't see differences between islands but between sexes in Adelie Penguin"
    )
```

## Plotting using `ggplot`: More than one geom

```{r}
df %>%
    filter(!is.na(Sex)) %>%
    ggplot(aes(x = `Flipper Length (mm)`, y = `Body Mass (g)`, colour = Sex)) +
    geom_smooth(method = lm, linetype = "dashed") +
    geom_point(shape = 1) + # shape = 1 is data independent!
    facet_wrap(~Island) +
    ggtitle(
        label = "Flipper Length versus Body Mass",
        subtitle = "We don't see differences between islands but between sexes in Adelie Penguin"
    )
```

## Resources

- If you have an idea of what you want, but don't know how to start you can visit the [The R Graph Gallery
  ](https://r-graph-gallery.com/).

- If you want to read more on data visualization with `R` I recommend [Modern Data Visualization with R
  ](https://rkabacoff.github.io/datavis/)

- If you want to read more on data science with `R` I recommend [R for Data Science (2e)
  ](https://r4ds.hadley.nz/)

- If you want to read advance topics[^9], I suggest to pick some of the chapters from [Advanced R](https://adv-r.hadley.nz/index.html).

[^9]: For example, re-writing only a few slow functions in C++ is actually _very simple_ with ChatGPT and the `Rcpp` package (or, at least, way simpler than th equivalent work in Python).
