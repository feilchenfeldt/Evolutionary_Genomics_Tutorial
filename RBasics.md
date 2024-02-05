# Basics of `R` for plotting 
by the Svardal lab, svardallab@gmail.com, 
based on material by Alexandros Bantounas Alexandros.Bantounas@uantwerpen.be

## `R` Elements

Using R involves writing commands (“code”). These commands are assembled
in a **script** that is saved and can be re-used. The R **console**
receives the commands, either from the script or by directly typing, and
also shows the progress and outputs of those commands. **Plots** can be
visualized in a separate window. All these elements can be combined in
integrated development environments (IDEs). The commonest IDE for R is
**RStudio**. The RStudio environment should look like this:

In RStudio you can also bundle all the analysis in Projects, allowing
you to have all the data, scripts and outputs available in one place. A
typical R workflow looks like this:

1.Define/create a folder to be used as the working directory.

2.Open R Studio and create a new Script file (menu). You can also create
a project (button top right).

3.Set the working directory to your prepared folder.

4.Write your script in the script window and save it. Send selected code
line(s) to the console using ctrl+Return (PC).

5.Conduct analyses, save the script, outputs and graphs. When the entire
analysis is ready, you can compile code and output into a notebook.

## R commands

The structure of an R command is the following:

**command.name(argument1, argument2,…)**

The arguments “tell” R on which data and with what options to execute
the command.

## R objects and assignment

Inputs and outputs in R can be assigned to objects using the assignment
arrow **\<-**. For example, let’s assign different data to a variable
and execute the command **print()** to visualize them:

``` r
a <- 3
print(a)
b <- "Genomics"
print(b)
```

Bear in mind that for text to be recognised as text in R it has to be
between ‘single’ or “double” quotes, otherwise it is recognised as an
object.

Using the same object name to assign multiple objects results in the
last object to be assigned in that object name.

``` r
i <- "Genomics"
print(i)
i <- "Hey"
print(i)
```

There are multiple object categories, such as vectors, lists, data
frames, matrices and more specialized object types.

Multiple data can be assigned to the same object using the command
**c()**. This creates vectors of similar data types:

``` r
#Numeric vector
numeric.vector <- c(1,2,3,4)
print(numeric.vector)
#Character vector
character.vector <- c("2023", "Omics", "Techniques")
print(character.vector)
#Notice that vectors can only take the same type of data
character.vector2 <- c(2023, "Omics", "Techniques")
print(character.vector)
```

##Packages R packages are sets of custom functions and object classes
that can be installed and used. Most R packages are deposited in the
CRAN repository. An important set of packages involved in data
manipulation and plotting is the **tidyverse**.

``` r
#Installing packages directly from CRAN. This function has to be executed once.
install.packages("tidyverse")
#Loading a package to be used in the current script. This function has to be executed every time the script is re-opened and re-used.
library(tidyverse)
```

## Loading and exploring data

Small datasets can be created using the command **data.frame()**; larger
datasets are loaded into R from files prepared in other programs such as
the genomics pipeline run today. The **data.frame()** command creates an
R object that can combine vectors with numbers, for example
measurements, and vectors with categories.

In order to load into R larger datasets located in a directory, the main
command to use is **read.table()**.

``` r
#header specifies whether the entries have headers, sep the separator between values (comma in csv files)
my.data <- read.table(file = "Mypath\\file_name", header = TRUE, sep = ",", dec = ".")
```

Now let’s explore a dataset that comes with the base R, the **iris**
dataset:

``` r
data("iris") #This loads any premade datasets from base R or any packages installed.
head(iris, n=10) #This shows the first n rows of the dataset, 6 by default.
str(iris) #This command shows an overview of the structure of the dataset. 
```

After we have an overview of our data, it is important to know how to
navigate or “call” specific entries in our dataset. There are two main
ways to access entries in a dataset:

``` r
#When referencing a named column, we can use the dollar sign $
head(iris$Sepal.Length)
#We can also access any row, column combination using [r,c]
iris[1,] #Accessing first row.
iris[,1] #Accessing first column.
iris[1,1] #Accessing the value in the first column and first row.

#Finally, if instead of a data frame we have a list we use the [[n]][m] notation to access the mth value in the nth item of the list
list1 <- list(1:20)
list1[[1]][2]
```

### Subsetting data and missing values

There are many situations where only a specific subset of the data needs
to be used. In R, this is done with entering a so-called logical
statement (see below) in the square brackets. For example, if we wish to
choose the cells with sepal length larger than 6:

``` r
iris.selected <- iris[iris$Sepal.Length > 6,]
str(iris)
str(iris.selected)
```

Missing data may appear in dataset as NA (no value) or NaN (not a
number). A useful command to quickly check whether there are NA values
in the dataset is to use a combination of the **sum()** and **is.na()**
commands. This finds any NA values in our dataset and sums the number of
NA values found.

``` r
sum(is.na(iris))
example.df <- data.frame(column1 = c(18, NA, 23, 17),
                         column2 = c(NA, "Antwerp", "Brussels","Gent"))
sum(is.na(example.df))
#To find the positions of NA values we use the which() function
which(is.na(example.df)==TRUE)
```

## Loops in R

Loops allow us to iteratively apply a function on a list of inputs. The
main loop used in this tutorial is the **for** loop:

``` r
for(j in 1:20){
  print(j^2)
  }
```

## Advanced dataset manipulation

Very useful packages in manipulating datasets are the packages
**plyr/dplyr**. In this tutorial we will see multiple functions as well
as the symbol **%\>%** which acts like the pipe **\|** in Unix. Some
example functions:

``` r
library(dplyr)
# Create DataFrame
df <- data.frame(
  id = c(10,11,12,13,14,15,16,17),
  name = c('sai','ram','deepika','sahithi','kumar','scott','Don','Lin'),
  gender = c('M','M','F','F','M','M','M','F'),
  dob = as.Date(c('1990-10-02','1981-3-24','1987-6-14','1985-8-16',
                  '1995-03-02','1991-6-21','1986-3-24','1990-8-26')),
  state = c('CA','NY',NA,NA,'DC','DW','AZ','PH'),
  row.names=c('r1','r2','r3','r4','r5','r6','r7','r8')
)
df
#Filter function allows us to filter the dataset based on specific criteria
  # filter() by row name
  df %>% filter(rownames(df) == 'r3')
  
  # filter() by column Value
  df %>% filter(gender == 'M')
  
  # filter() by list of values
  df %>% filter(state %in% c("CA", "AZ", "PH"))
  
  # filter() by multiple conditions
  df %>% filter(gender == 'M' & id > 15)

#Select allows us to select colums or variables from the data  
  # select() single column
  df %>% select('id')
  
  # select() multiple columns
  df %>% select(c('id','name'))
  
  # Select multiple columns by id
  df %>% select(c(1,2))

#Mutate is used to update/replace the values of columns in dataframes
  # Replace on selected column
  df %>% 
    mutate(name = str_replace(name, "sai", "SaiRam"))
```

## Plotting using base R

Plotting in R utilizes a graphics device. The plots are modular and
essentially the elements of a plot are added one on top of the other in
the graphics device. This logic is especially important when plotting
using ggplot2.

While plotting in base R the main command used is the universal
**plot()** command. In this tutorial we wil use a toy dataset included
with R distributions, the **iris** dataset. So the first step is to load
this dataset in R and see its structure:

``` r
data("iris") #Example data
str(iris)
```

The next step is to plot two columns of the dataset one over the other.
Let’s plot the **Sepal.Length** on the y axis and the **Sepal.width** on
the x axis:

``` r
plot(Sepal.Length ~ Sepal.Width, data=iris)
```

We can also change this basic plot’s main title and axis labels:

``` r
plot(Sepal.Length ~ Sepal.Width, data=iris,main="Sepal length over sepal width", xlab="Sepal Width", ylab="Sepal Length")
```

We can also modify the symbol used for our points **(pch)**, their size
**(cex)**, or colour them based on the value they have on a different
column of the dataset **(col)**. Here we colour them based on their
species.

``` r
plot(Sepal.Length ~ Sepal.Width, data=iris,main="Sepal length over sepal width", xlab="Sepal Width", ylab="Sepal Length", pch="*", cex=2.0, col=c("blue", "green", "red")[Species])
```

Finally, to add a legend to our plot we use the separate command
**legend()** and choose its position, its title, the label names and the
colours used to match our graph’s.

``` r
plot(Sepal.Length ~ Sepal.Width, data=iris,main="Sepal length over sepal width", xlab="Sepal Width", ylab="Sepal Length", pch="*", cex=2.0, col=c("blue", "green", "red")[Species])

legend("topright", pch="*", col=c("blue", "green", "red"), c("I.setosa", "I.versicolor", "I.virginica"), cex=0.8, title="Species")
```

Finally, an important aspect of the graphics device is the manipulation
of the number of plots per window and the margins of the graphics
device. The former is done through the **par(mfrow=c(y,x))** command,
where y is the number of plots per column and x the number of plots per
row. The margins can be manipulated through the **par(mar=c(x,y,z,k))**
command, where x is the bottom margin and the rest follow a clockwise
order. Finally, the graphics device can be emptied using the
**dev.off()** command, deleting all plots in the plotting window and
resetting its settings.

Try to plot all 4 of the plots above in the same window using the
par(mfrow) command and then executing the 4 plot commands in sequence.

## Plotting using ggplot2

A very useful package for plotting in R is the **ggplot2** package that
is included in the **tidyverse**. The main difference between using base
R and ggplot2 is the concept of aesthetic mappings, which allow for high
customization and make the code extremely modular. In any plotting
pipeline with ggplot2 the first step is to specify which data are
plotted with the main function **ggplot()** and assigning this graph
element to a variable.

``` r
library(tidyverse) #loading tidyverse which includes ggplot2
example.plot <-  ggplot(data=iris, mapping = aes(x = Sepal.Width, 
                      y = Sepal.Length))
example.plot
```

Evaluating the plot above yields an empty graph. This is because in
ggplot2, unlike base R, we have to specify with a separate command how
to draw the plot between our two variables. This is done through various
commands for the various graph types, all beginning with the **geom\_**
element. In this case, for a scatter plot of points we use
**geom_point()**.

``` r
example.plot <-  ggplot(data=iris, mapping = aes(x = Sepal.Width, 
                      y = Sepal.Length))
example.plot + geom_point()
```

Multiple types of graphs can be plotted for different types of data
(continuous\~continuous or continuous\~categorical):

``` r
example.plot2 <-  ggplot(data=iris, mapping = aes(x = Species, 
                      y = Sepal.Length))
example.plot2 + geom_boxplot(mapping = aes(color=Species))

example.plot2 + geom_violin(mapping = aes(color=Species, fill=Species))
```

We can also specify how our points can be coloured, either in the
aesthetics of the base plot or in the aesthetics of the geom element:

``` r
example.plot <-  ggplot(data=iris, mapping = aes(x = Sepal.Width, 
                      y = Sepal.Length, 
                      color = Species,
                      fill = Species)) + geom_point()
example.plot

example.plot2 <-  ggplot(data=iris, mapping = aes(x = Sepal.Width, 
                      y = Sepal.Length)) + geom_point(mapping=aes(color = Species,
                      fill = Species))
example.plot2
```
