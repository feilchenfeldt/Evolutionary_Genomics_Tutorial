# Plotting Population Genomic results in `R`
by Alexandros Bantounas Alexandros.Bantounas@uantwerpen.be

## R Elements

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

## Plotting the genomics results

In order to plot the genomics results, certain output files need to be
downloaded to the local drive and in our working/project directory.
Download the following files:

1.  The **.dist** and **.dist.id** files for the distance matrix.

2.  The metadata **.csv** file.

3.  The **.eigenvec** and **.eigenval** files for the PCA.

4.  The **.fam** and **.Q** files for the ADMIXTURE analysis.

5.  The **windowed.weir.fst** file for the Fst analysis.

It is also important to install the necessary packages. In this tutorial
we will use three packages: **tidyverse**, **ape** and **ggtree**.

``` r
install.packages(c("tidyverse", "ape","ggtree"))
library(tidyverse)
library(ape)
library(ggtree)
```

### Plotting the distance matrix

The first step is to load into R the distance matrix itself as a data
frame, as well as the sample ID to be used as labels:

``` r
plink.dist <- read.table(file = "Path_to_working_directory\\Telmatherina38.pass.snps.biallelic.Chr1.dist", header = FALSE, sep = "\t", dec = ".") #Distance matrix

plink.id <- as.data.frame(read.table(file = "Path_to_working_directory\\Telmatherina38.pass.snps.biallelic.Chr1.dist.id", header = FALSE, sep = "\t", dec = ".")) #Sample IDs

str(plink.dist)
```

The next step is to transform the data.frame into a matrix and
incorporate our sample IDs as the matrix dimension names.

``` r
plink.matrix <- as.matrix(plink.dist)

dimnames(plink.matrix) <- list(plink.id[,1],plink.id[,1])

plink.matrix
```

The next step is to transform the data from wide format into the long
format (which is a much more tidy way of representing data in R).

``` r
plink.dist.df<-  as_tibble(plink.matrix, rownames="A") %>%
    pivot_longer(-A,names_to = "B", values_to = "distances") 

view(plink.dist.df)
```

Finally we get to plot the distance matrix! We will use a heatmap to
represent our distance matrix, encoded by the **geom_tile()** command in
ggplot2.

``` r
plink.dist.df %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()
```

However, we can already see that this plot has several issues: The tiles
are drawn as rectangles, the colour scheme is not optimal, the axes are
not properly labeled and still have axis lines and the x’x axis labels
are not readable due to their angle. We can mitigate all these issues by
manipulating these elements with additional commands:

``` r
plink.dist.df %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()+
  coord_equal()+ #making the tiles into squares
  scale_fill_gradient(low = "#FF0000", high = "#FFFFFF", name=NULL) + #changing the colour scheme
  labs(x="Samples", y="Samples") + #changing axis labels
  theme_classic()+ #gets rid of the grey background of the base ggplot2 theme
  theme(axis.line = element_blank(), #removes axes lines and ticks
        axis.ticks = element_blank(),
        axis.text = element_text(size=8), #changes the font size
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) #rotates x axis labels by 90 degrees to make them readable
```

### Making and plotting a neighbour-joining (NJ) tree

In this part of the tutorial we will make use of the genomic pairwise
distance matrix to create a phylogenetic tree of our samples. While
there are multiple algorithms, we will use the simplest one called
“neighbour-joining”. To build the NJ tree we will use the package
**ape** and more specifically its **nj()** function.

``` r
NJ.tree <- ape::nj(plink.matrix)
```

Let’s see how our tree looks. Basic plots of the trees can be done
through using the ape package:

``` r
#Plot the unrooted NJ tree
plot(x=NJ.tree, type="unrooted", cex=0.5)

#Plot a rooted NJ tree
plot(x=NJ.tree)
```

However, we may wish to “decorate” our tree by highlighting specific
edges or clusters based on our metadata file. In order to do that, we
first have to save our tree in a file in our working directory. A simple
tree file format is the Newick format:

``` r
write.tree(NJ.tree, file = "NJ.tree.nwk", append = FALSE,
           digits = 10, tree.names = FALSE)
```

Now let’s load our tree into R and use the ggtree package to modify and
decorate our NJ tree:

``` r
tree <- read.tree("Path_to_working_directory\\NJ.tree.nwk")
```

The ggtree package introduces a dedicated **geom_tree()** function to
plot trees in ggplot2. There are multiple ways to plot our tree, as seen
below:

``` r
ggplot(tree) + geom_tree() + geom_tiplab()
ggtree(tree, layout="roundrect")+ geom_tiplab()
ggtree(tree, layout="slanted")+ geom_tiplab()
ggtree(tree, layout="ellipse")+ geom_tiplab()
ggtree(tree, layout="circular")+ geom_tiplab()
ggtree(tree, layout="fan", open.angle=120)+ geom_tiplab()
ggtree(tree, layout="equal_angle")+ geom_tiplab()
ggtree(tree, layout="daylight")+ geom_tiplab()
ggtree(tree, branch.length='none')+ geom_tiplab()
ggtree(tree, layout="ellipse", branch.length="none")+ geom_tiplab()
ggtree(tree, branch.length='none', layout='circular')+ geom_tiplab()
ggtree(tree, layout="daylight", branch.length = 'none')+ geom_tiplab()
```

As you can see different tree types can be used to convey different
types of information. For the rest of this tutorial we will focus on the
so-called “phylograms”. These phylograms show the evolutionary
relationships with respect to the evolutionary time and the amount of
change between time. An important step in annotating our tree is to find
the node labels (which are numbered). These can be performed using the
following code:

``` r
ggplot(tree) + geom_tree() + theme_tree()+ geom_tiplab()

ggtree(tree)+ geom_text(aes(label=node), hjust=-.3) #This shows node labels
```

Now that we know the node labels, we can try and highlight some clades
from our metadata file that cluster together in the NJ tree. Let’s try
to highlight the North clade. First we need to visually inspect our tree
to discover which is the node of the most recent common ancestor of the
clade we wish to highlight. Then we run the following code:

``` r
ggtree(tree) + 
  geom_tiplab() + 
  geom_cladelabel(node=55, label="roundfins", 
                  color="blue", offset=.8, align=TRUE) + 
  theme_tree2() + #cleaner tree theme
  xlim(0, 9000) + #increasing x axis maximum to help with label alignment
  theme_tree()
```

This code added lines to the side indicating the labels associated with
a specific clade from our metadata. However, it may be easier to
highlight the entire clade on the tree. This can be performed using the
following code:

``` r
ggtree(tree) + 
  geom_tiplab() + 
   geom_hilight(node=55, fill="purple") +
  geom_cladelabel(node=55, label="roundfins", 
                  color="blue", offset=.8, align=TRUE) + 
  theme_tree2() + #cleaner tree theme
  xlim(0, 9000) #increasing x axis maximum to help with label alignment
```

Try to use the code above to highlight the another clade from the
metadata file in the tree.

### Plotting genomic Principal Component Analysis (PCA)

Another useful analysis performed using the pairwise distance matrix is
the PCA. This is a dimensionality reduction method, allowing us to
summarise the n-dimensional variation of the pairwise distance matrix
with created dimensions (usually 2) explaining as much of the variation
as possible. Let’s use the plink PCA output files to plot the two axes
explaining most of the genomic variation in our samples.

Firstly we need to load the plink output files and the metadata file
into R:

``` r
#Reading in the .eigenvec and .eigenval files
eigenvec <- read_delim("Path_to_working_directory\Telmatherina38.pass.snps.biallelic.Chr1.eigenvec", delim = " ", col_names = FALSE)
eigenval <- read_delim("Path_to_working_directory\Telmatherina38.pass.snps.biallelic.Chr1.eigenval", delim = " ", col_names = FALSE)

#Loading the metadata file
metadata <- read.csv(file = "Path_to_working_directory\Samples_metadata_sil38_simple.tsv", sep = "\t")
```

Next, let’s calculate how much variation does each principal axis
explain. We will use the eigenvalues with a simple percentage
calculation mathematical formula:

``` r
eigenvalue_percent <- round((eigenval$X1/sum(eigenval$X1))*100)
```

We will also add the group of each sample from the
metadata to the eigenvector dataframe by creating an additional column.
This will help with colouring the sample points later on:

``` r
eigenvec$group <- metadata$group
```

Finally, it’s time to plot the PCA using ggplot2. Plotting the PCA is
essentially a scatter plot where the coordinates for each point are
given by the eigenvectors of each principal axis. Since we are plotting
the first to axes, we will use the first two eigenvectors (columns X3
and X4 of the dataframe). We will also use the population column to
colour our points:

``` r
ggplot(data = eigenvec) +
  geom_point(mapping = aes(x = X3, y = X4, colour=population), size = 3, show.legend = TRUE ) +
  geom_hline(yintercept = 0, linetype="dotted") + #horizontal line with y=0
  geom_vline(xintercept = 0, linetype="dotted") + #vertical line with x=0
  labs(title = "PCA of Telmatherina",
       x = paste0("Principal component 1 (",eigenvalue_percent[[1]]," %)"),
       y = paste0("Principal component 2 (",eigenvalue_percent[[2]]," %)"), 
       colour = "Population") +#adding the percent variance explained colouring the points
  theme_minimal() #removes gray background of ggplot
```

### ADMIXTURE plot

The first step in plotting the results of ADMIXTURE is to load the
sample names and the ADMIXTURE results for each K. In order to load the
results faster we will use a for loop that reads the specific naming
pattern of the .Q files and loads them in a list of dataframes:

``` r
samples<-read.table("Path_to_working_directory\Telmatherina38.pass.snps.biallelic.Chr1.fam")[,1]

#read in all runs and save each dataframe in a list
runs<-list()
#read in log files
for (i in 1:6){
  runs[[i]]<-read.table(paste0("Telmatherina38.pass.snps.biallelic.Chr1.", i+1, ".Q")) #This is a way of loading multiple files using a series of numbers in the file name
}
```

We then prepare our graphics device. It is useful to plot all 6 .Q files
in the same window, so we manipulate the graphics device settings. We
also load a colourblind-friendly palette to use for colouring the
samples’ ancestry estimates:

``` r
par(mar = c(7, 4, 2, 2) + 0.2) #add room for the rotated labels
par(mfrow = c(2,3)) #this allows for plotting six plots in one window
palt <- palette.colors(NULL, "Okabe-Ito")
```

Now we use a for loop to plot all the results at the same time. For
plotting we will use **barplot()**, which is the base R command for
creating barplots and behaves exactly like the basic **plot** command we
showed before:

``` r
for(i in 1:6){
  barplot(t(as.matrix(runs[[i]])),xlim = c(0,50), width=0.4,main = paste0("K=", i+1), col=c(2:i+2), ylab="Ancestry", border="black", names.arg = samples, las=2)
}
```

Using the above code, each run is plotted with a main title showing the
number of K clusters of that run. K colours are chosen from the
Okabe-Ito pallette to colour the clusters and each sample receives a
label based on the sample labels we loaded in the first step. Finally,
with **las=2** the labels are rotated by 90 degrees.

In order to make the clustering more obvious, let’s re-arrange the
samples on the graphs based on their cluster assignment. The proper way
to do this is to use the cluster assignments in the cluster with the
smallest cross-validation error. However, since we have not calculated
this, we will use the K=7 cluster assignment. We manually select the
order of sample we wish to have and then apply it to our list of result
dataframes using a for loop. We also re-arrange the sample label
dataframe. For the example chromosome 15 the assignments were the
following:

``` r
for(i in 1:6){
  runs[[i]]<-runs[[i]][c(1:21,29,30,33,31:32,34,22:28,37:38,35:36),]
}

samples_reorganized <- samples[c(1:21,29,30,33,31:32,34,22:28,37:38,35:36)]
```

We then plot the results again, using the re-arranged samples:

``` r
for(i in 1:6){
  barplot(t(as.matrix(runs[[i]])),xlim = c(0,10), width=0.4,main = paste0("K=", i+1), col=[c(2:i+2)], ylab="Ancestry", border="black", names.arg = samples_reorganized, las=2)
}
```

### Plotting the Fst results

The first step is to load the Fst results onto R:

``` r
fst <- read_tsv("Path_to_working_directory\Telmatherina38.pass.snps.biallelic.chr1.windowed.weir.fst")
str(fst)
```

The next step is to transform the chromosome position from bp to Mb with
a simple division:

``` r
#Plotting Fst for one chromosome
fst$BIN_START=fst$BIN_START/1E6
fst$BIN_END=fst$BIN_END/1E6
```

Finally, we plot the results for each chromosome separately using a
ggplot2 scatterplot:

``` r
fst_plot<-ggplot(fst) + 
  geom_point(aes(x=BIN_START, y=WEIGHTED_FST))+
  ggtitle("Fst-Chromosome 1") + #title of graph
  xlab(paste("Mb Chromosome ",1,sep="") ) + #x'x axis label
  ylab(expression(F[ST])) + #y'y axis label
  theme_minimal() 
fst_plot
```