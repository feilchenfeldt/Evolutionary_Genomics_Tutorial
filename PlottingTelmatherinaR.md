# Plotting Population Genomic results in `R`
by the Svardal lab, svardallab@gmail.com, 
based on material by Alexandros Bantounas Alexandros.Bantounas@uantwerpen.be

If you need some basic introduction to `R`, follow the [RBasics](RBasics.md) tutorial
or consult online resources.

The R code for the first part of this tutorial (without explanations) can be found here: 
[PlottingTelmatherina.R](PlottingTelmatherina.R). You can copy paste it into an R script
or R studio.

## Plotting the genomics results

Here we want to plot the results of the tutorial on basic population genomics: 
[PopulationGenomicsTelmatherina](PopulationGenomicsTelmatherina.md).

If you have not managed to obtain the data, you can download it here for chromosome 1:
[TelmatherinaPopgen_results.zip](Results/TelmatherinaPopgen/TelmatherinaPopgen_results.zip)



In order to plot the genomics results, certain output files need to be
downloaded to the local drive and in our working/project directory.
Download the following files:

1.  The **.dist** and **.dist.id** files for the distance matrix.

2.  The metadata **.tsv** file.

3.  The **.eigenvec** and **.eigenval** files for the PCA.

4.  The **.fam** and **.Q** files for the ADMIXTURE analysis.

5.  The **windowed.weir.fst** file for the Fst analysis.

The first time running this, it is important to install the necessary packages. 
In this tutorial
we will use three packages: **tidyverse**, **ape** and **ggtree**.
The installation only needs to be run once.

``` r
install.packages(c("tidyverse", "ape","ggtree"))
```

If `ggtree` does not install, try the following:

```r
library(BiocManager)
BiocManager::install("ggtree")
```

Then load the libraries needed

```r
library(tidyverse)
library(ape)
library(ggtree)
```

Next, it is useful to set the directory in which you have your popgen results as
current working directory. For example, if your data is in `/home/johndoe/popgen`, use

``` r
setwd("/home/johndoe/popgen")
```

On windows, your filepath might of course look a bit different, like

``` r
setwd("C:\Users/Johndoe/popgen")
```

### Plotting the distance matrix

The first step is to load into R the distance matrix itself as a data
frame, as well as the sample ID to be used as labels:

``` r
plink.dist <- read.table(file = "Telmatherina38.pass.snps.biallelic.Chr1.dist",
                         header = FALSE, sep = "\t", dec = ".") #Distance matrix

plink.id <- as.data.frame(read.table(file = "Telmatherina38.pass.snps.biallelic.Chr1.dist.id", 
                                     header = FALSE, sep = "\t", dec = ".")) #Sample IDs

str(plink.dist)

```

The next step is to transform the data.frame into a matrix and
incorporate our sample IDs as the matrix dimension names.

``` r
plink.matrix <- as.matrix(plink.dist)

dimnames(plink.matrix) <- list(plink.id[,1], plink.id[,1])

plink.matrix
```

The next step is to transform the data from wide format into the long
format (which is a much more tidy way of representing data in R).

``` r
plink.dist.df<-  as_tibble(plink.matrix, rownames="A") %>%
  pivot_longer(-A,names_to = "B", values_to = "distances") 

view(plink.dist.df)
```

Finally, we get to plot the distance matrix! We will use a heatmap to
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

However, we know from the distance matrix that MP2 and MP3 are clear outgroups
(very distant from everything else). We may want to use them to root the tree,
and then plot a tree without those outgroups to get more resolution for the
ingroups.

To achevie this, do the following:
``` r
#remove MP3, root to MP2 and then remove MP2
NJ.tree2 <- drop.tip(NJ.tree, "MP3")
NJ.tree3 <- root(NJ.tree2, outgroup = "MP2")
NJ.tree4 <- drop.tip(NJ.tree3, "MP2")
```


``` r
#Plot the unrooted NJ tree
plot(x=NJ.tree4, type="unrooted", cex=0.5)

#Plot a rooted NJ tree
plot(x=NJ.tree4)
```

For other applications below, it will be useful to store the order of samples
in the tree:
``` r
#get tip labels in the the order of the phylogeny
is_tip <- NJ.tree4$edge[,2] <= length(NJ.tree4$tip.label)
ordered_tips <- NJ.tree4$edge[is_tip, 2]
labels_order<- NJ.tree4$tip.label[ordered_tips]
```
Furthermore, we may wish to “decorate” our tree by highlighting specific
edges or clusters based on our metadata file. In order to do that, we
first have to save our tree in a file in our working directory. A simple
tree file format is the Newick format:

``` r
write.tree(NJ.tree4, file = "NJ.tree.nwk", append = FALSE,
           digits = 10, tree.names = FALSE)
```

Now let’s load our tree into R and use the ggtree package to modify and
decorate our NJ tree:

``` r
tree <- read.tree("NJ.tree.nwk")
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

ggplot(tree) + geom_tree() + theme_tree()+ geom_tiplab()

ggtree(tree)+ geom_text(aes(label=node), hjust=-.3) #This shows node labels
#39 (sharpfins), 70 (bonti/river), 62 (roundfins)
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
  geom_tiplab(align = TRUE) + 
  geom_hilight(node=39, fill="blue") +
  geom_hilight(node=70, fill="green") +
  geom_hilight(node=62, fill="red") +
  geom_cladelabel(node=39, label="Sharpfin", 
                  color="blue", offset=180, align=TRUE) +
  geom_cladelabel(node=70, label="Bonti/River", 
                  color="green", offset=180, align=TRUE) +
  geom_cladelabel(node=62, label="Roundfin", 
                  color="red", offset=180, align=TRUE) +
  theme_tree() +
  coord_cartesian(xlim = c(0, 1300))

aligned_tree <- ggtree_object + geom_tiplab(align = TRUE, aes(label= "")) + theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))

  
```
### Ordering the distance matrix by tree order

Now that we have the order of samples in the tree, we can use this to re-order
samples in the distance matrix, and also remove the highly divergent TM

```r
#remove MP2 and MP3 - remove rows where A or B is MP2 or MP3
plink.dist.df2 <- plink.dist.df[plink.dist.df$A != "MP2" & plink.dist.df$A != "MP3" & plink.dist.df$B != "MP2" & plink.dist.df$B != "MP3", ]          

#change the order of the samples according to the phylogeny
plink.dist.df2$A <- factor(plink.dist.df2$A, levels = labels_order)
plink.dist.df2$B <- factor(plink.dist.df2$B, levels = labels_order)


plink.dist.df2 %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()

plink.dist.df2 %>%
  ggplot(aes(x=A, y=B, fill=distances)) +
  geom_tile()+
  coord_equal()+ #making the tiles into squares
  #scale_fill_gradient(low = "#FF0000", high = "#FFFFFF", name=NULL) + #changing the colour scheme
  scale_fill_distiller(palette = "Spectral", direction = -1) + 
  labs(x="Samples", y="Samples") + #changing axis labels
  theme_classic()+ #gets rid of the grey background of the base ggplot2 theme
  theme(axis.line = element_blank(), #removes axes lines and ticks
        axis.ticks = element_blank(),
        axis.text = element_text(size=8), #changes the font size
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) #rotates x axis labels by 90 degrees to make them readable

```


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
eigenvec <- read_delim(paste(outbase,".eigenvec", sep=''), delim = " ", col_names = FALSE)
eigenval <- read_delim(paste(outbase,".eigenval", sep=''), delim = " ", col_names = FALSE)

#Loading the metadata file
metadata <- read.csv(file = "Samples_metadata_sil38_simple.tsv", sep='\t')
```

Next, let’s calculate how much variation does each principal axis
explain. We will use the eigenvalues with a simple percentage
calculation mathematical formula:

``` r
eigenvalue_percent <- round((eigenval$X1/sum(eigenval$X1))*100)
```

We will also add the species of origin of each sample from the
metadata to the eigenvector dataframe by creating an additional column.
This will help with colouring the sample points later on:

``` r
eigenvec$species <- metadata$species
```

Finally, it’s time to plot the PCA using ggplot2. Plotting the PCA is
essentially a scatter plot where the coordinates for each point are
given by the eigenvectors of each principal axis. Since we are plotting
the first to axes, we will use the first two eigenvectors (columns X3
and X4 of the dataframe). We will also use the species column to
colour our points:

``` r
ggplot(data = eigenvec) +
  geom_point(mapping = aes(x = X3, y = X4, colour=species), size = 3, show.legend = TRUE ) +
  geom_hline(yintercept = 0, linetype="dotted") + #horizontal line with y=0
  geom_vline(xintercept = 0, linetype="dotted") + #vertical line with x=0
  labs(title = "PCA of selected Telmatherina species",
       x = paste0("Principal component 1 (",eigenvalue_percent[[1]]," %)"),
       y = paste0("Principal component 2 (",eigenvalue_percent[[2]]," %)"), 
       colour = "species") +#adding the percent variance explained colouring the points
  theme_minimal() #removes gray background of ggplot
```

As expected, the first axis of the PCA loads on the difference between 
**Marosatherina** and **Telmatherina**. Repeat the same plot as above, but plot `PC2` against
`PC3`. This will be more informative about the Malili lakes *Telmatherina*.

### ADMIXTURE plot

The first step in plotting the results of ADMIXTURE is to load the
sample names and the ADMIXTURE results for each K. In order to load the
results faster we will use a for loop that reads the specific naming
pattern of the .Q files and loads them in a list of dataframes:

``` r
samples<-read.table("Path_to_working_directory\\chr15.fam")[,1]

#read in all runs and save each dataframe in a list
runs<-list()
#read in log files
for (i in 1:6){
  runs[[i]]<-read.table(paste0("chr15.maf0p05.", i+1, ".Q")) #This is a way of loading multiple files using a series of numbers in the file name
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
  barplot(t(as.matrix(runs[[i]])),xlim = c(0,10), width=0.4,main = paste0("K=", i+1), col=palt[c(2:i+2)], ylab="Ancestry", border="black", names.arg = samples, las=2)
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
  runs[[i]]<-runs[[i]][c(1:4,5:6,15,7:11,12,16,19,13,17,14,18,20),]
}

samples_reorganized <- samples[c(1:4,5:6,15,7:11,12,16,19,13,17,14,18,20),]
```

We then plot the results again, using the re-arranged samples:

``` r
for(i in 1:6){
  barplot(t(as.matrix(runs[[i]])),xlim = c(0,10), width=0.4,main = paste0("K=", i+1), col=palt[c(2:i+2)], ylab="Ancestry", border="black", names.arg = samples_reorganized, las=2)
}
```

### Plotting the Fst results

The first step is to load the Fst results onto R:

``` r
fst <- read_tsv("Path_to_working_directory\\chr15.windowed.weir.fst")
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
  ggtitle("Fst-Chromosome 15") + #title of graph
  xlab(paste("Mb Chromosome ",15,sep="") ) + #x'x axis label
  ylab(expression(F[ST])) + #y'y axis label
  theme_minimal() 
fst_plot
```
