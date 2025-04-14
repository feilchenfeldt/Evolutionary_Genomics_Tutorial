## Plotting Population Genomic results in R

by the [Svardal lab](svardallab@gmail.com), based on material by [Alexandros Bantounas](Alexandros.Bantounas@uantwerpen.be) and contributions by [Curro Campuzano](curro.campuzanojimenez@uantwerpen.be) [^1].

[^1]: I have added some footnotes for those who have more experience. Feel free to ignore them!

## Overview of the data

In order to plot the genomics results, certain output files need to be downloaded to the local drive and in our working/project directory. Download the following files:

- The .dist and .dist.id files for the distance matrix.

- The metadata .csv file.

- The .eigenvec and .eigenval files for the PCA.

- The .fam and .Q files for the ADMIXTURE analysis.

- The windowed.weir.fst file for the Fst analysis.

## Metadata

First step, is to load the metadata:

```{r}
library(tidyverse)
metadata <- read_csv("metadata.csv")
metadata
```

## Distance matrix

First, we load the names of the samples from the `dist.id` file, and the distance matrix.

```{r, echo=TRUE}
dist_ids <- read_tsv("output_chr14_elisa.dist.id", col_names = c("Sample1", "Sample2"))
dist_ids$Sample1 == dist_ids$Sample2
distance_mat <- as.matrix(read_tsv("output_chr14_elisa.dist", col_names = F))
```

## Link samples with the metadata

```{r, echo = TRUE}
# We want to extract the sample id from the filename. We can achieve this
# by removing the file extension
sample_ids <- str_remove(dist_ids$Sample1, ".sorted.bam")
sample_ids
# *Sanity check*
# Check that the metadata is in the same order.
# Code below will raise an error if the samples are not
# in the correct order. If that's the case, you can uncomment
# the following lines of code (or do something similar).
# rownames(metadata) <- metadata$Sample_ID
# metadata[sample_ids, ] <- sample_ids
stopifnot(all(metadata$Sample_ID == sample_ids))
rownames(distance_mat) <- sample_ids
colnames(distance_mat) <- sample_ids
```

## Heaptmap

We can make a simple heatmap that shows the how samples cluster together in base `R`.

```{r, echo = TRUE}
heatmap(distance_mat)
```

## Clustering

Notice that, in the previous plot, there is a dendrogram showing the a hierarchical structure. We can choose the agglomeration method to use.

```{r, echo=TRUE}
# You can execute ?heatmap and ?hclust to read the documentation
upgma <- function(x) hclust(x, method = "average")
heatmap(distance_mat, hclustfun = upgma)
```

## A more advance heatmap[^2]

[^2]: You can take a look at their _extensive_ [documentation](https://jokergoo.github.io/ComplexHeatmap-reference/).

```{r, echo=TRUE, eval=FALSE}
# BiocManager::install("ComplexHeatmap")
library(ComplexHeatmap)
Heatmap(distance_mat, name = "Distance") +
    rowAnnotation(Clade = metadata$Clade, Sex = metadata$Sex)
```

## A more advance heatmap

```{r}
# BiocManager::install("ComplexHeatmap")
set.seed(101)
library(ComplexHeatmap)
Heatmap(
    distance_mat,
    name = "Distance",
    width = unit(4.5, "inch"), # Adjust width as needed
    height = unit(4.5, "inch"), # Adjust height as needed
) +
    rowAnnotation(Clade = metadata$Clade, Sex = metadata$Sex)
```

## Making and plotting a neighbour-joining (NJ) tree

Now, we will use the genomic pairwise distance matrix to create a phylogenetic tree of our samples. We can build a neighbour-joining tree using the `ape` package and visualize it using the `plot` function.[^3]

[^3]: The `plot`function is a generic function that can be overloaded by authors of different packages.

## Making and plotting a neighbour-joining (NJ) tree

```{r, echo=TRUE}
# install.packages("ape")
library(ape)
nj_tree <- nj(distance_mat)
plot(nj_tree)
```

## The `ggtree` package

```{r, echo=TRUE}
# BiocManager::install("ggtree")
library(ggtree)
nj_tree %>%
    ggplot() +
    geom_tree() +
    geom_tiplab() +
    theme_tree()
```

## The `ggtree` package

You can play with the aesthetic of the plot

```{r, echo=TRUE}
nj_tree %>%
    ggtree(layout = "ellipse") +
    geom_text(aes(label = node), hjust = -.3) +
    theme_tree(bgcolor = "lightblue")
```

## Working towards a more advance phylogenetic tree

We want, again, to link the phylogenetic tree with the metadata. Notice the weird `%<+%` operator ...

```{r, echo=TRUE, eval=FALSE}
p <- ggtree(nj_tree)
p %<+% metadata +
    # Add labels to the tips from the metadata
    geom_tippoint(aes(color = Clade), size = 3) +
    # Manually, highlight some some interesting regions
    geom_cladelabel(node = 37, label = "South", offset = 200) +
    # Highlight another regions. Notice that, by selecting the node
We are selecting all “descendants.”
    geom_hilight(node = 22, fill = "grey", alpha = 0.5) +
    theme_tree() +
    theme(legend.position = "bottom") +
    ggtitle("Annotated phylogenetic tree")
```

## Working towards a more advance phylogenetic tree

```{r}
p <- ggtree(nj_tree)
p %<+% metadata +
    # Add labels to the tips from the metadata
    geom_tippoint(aes(color = Clade), size = 3) +
    # Manually, highlight some some interesting regions
    geom_cladelabel(node = 37, label = "South", offset = 200) +
    # Highlight another regions. Notice that, by selecting the node
    # we are selecting all "descendents"
    geom_hilight(node = 22, fill = "grey", alpha = 0.5) +
    theme_tree() +
    theme(legend.position = "bottom") +
    ggtitle("Annotated phylogenetic tree")
```

## Plotting genomic Principal Component Analysis (PCA)

PCA is a dimensionality reduction method we can use to visualize the genomic differences among individuals. First, we have to load the plink PCA output.

```{r}
eigenvalues <- as.numeric(read_lines("pca_maf_0.05.eigenval"))
eigenvectors <- read_delim("pca_maf_0.05.eigenvec", col_names = FALSE)
eigenvectors
```

## Percentage of variance explained

```{r}
variance_explained <- eigenvalues / sum(eigenvalues) * 100
variance_explained
```

## Tidy the eigenvectors

Let's tidy the table:

```{r, echo=TRUE}
pca_data <- eigenvectors %>%
    mutate(
        # Extract the filename from the full path in column X1
        basename = basename(X1),
        # Remove the ".sorted.bam" extension to get the sample identifier
        Sample_ID = str_remove(basename, ".sorted.bam"),
        # Assign principal component values (assuming X3 and X4 are PC1 and PC2)
        PC1 = X3,
        PC2 = X4
    ) |>
    # Select only the relevant columns for PCA visualization
    select(Sample_ID, PC1, PC2) %>%
    # Merge PCA results with metadata to add sample information
    left_join(metadata, by = "Sample_ID")
glimpse(pca_data)
```

## Visualize the PCA

```{r, echo=TRUE, eval=FALSE}
pca_data %>%
    ggplot(aes(x = PC1, y = PC2, color = Clade)) +
    geom_hline(yintercept = 0, linetype = "dotted") + # Horizontal line at y = 0
    geom_vline(xintercept = 0, linetype = "dotted") + # Vertical line at x = 0
    geom_point(size = 2, alpha = 0.8) +
    theme_minimal() +
    labs(
        title = "Principal component analysis",
        x = paste0("Principal Component 1 (", sprintf("%.2f", variance_explained[[1]]), "%)"),
        y = paste0("Principal Component 2 (", sprintf("%.2f", variance_explained[[2]]), "%)"),
        color = "Population"
    ) +
    theme(legend.position = "bottom")
```

## Visualize the PCA

```{r}
pca_data %>%
    ggplot(aes(x = PC1, y = PC2, color = Clade)) +
    geom_hline(yintercept = 0, linetype = "dotted") + # Horizontal line at y = 0
    geom_vline(xintercept = 0, linetype = "dotted") + # Vertical line at x = 0
    geom_point(size = 2, alpha = 0.8) +
    theme_minimal() +
    labs(
        title = "Principal component analysis",
        x = paste0("Principal Component 1 (", sprintf("%.2f", variance_explained[[1]]), "%)"),
        y = paste0("Principal Component 2 (", sprintf("%.2f", variance_explained[[2]]), "%)"),
        color = "Population"
    ) +
    theme(legend.position = "bottom")
```

## ADMIXTURE plot

ADMIXTURE produced 2 files: `.Q` which contains cluster assignments for each individual and `.P` which contains for each SNP the population allele frequencies. We are interested in the `.Q` files.

```{r, echo=TRUE}
# Process data into a "tidy" long format
read_and_tidy_admixture <- function(file) {
    read_delim(file, col_names = F) %>%
        mutate(Sample_ID = metadata$Sample_ID) %>%
        pivot_longer(-Sample_ID, values_to = "Proportion", names_to = "pop_group") %>%
        mutate(
            index = as.numeric(str_remove(pop_group, "X")),
            K = max(index),
            pop_group = as.factor(index)
        )
}
# More R-style with a bit of regex ...
data_admix <- list.files(pattern = "*.Q") %>%
    map(read_and_tidy_admixture) %>%
    bind_rows()
# Otherwise ...
runs <- list()
# read in log files
for (i in 1:6) {
    runs[[i]] <- read_and_tidy_admixture(
        paste0("chr17.filtered.geno.", i + 1, ".Q")
    )
}
data_admix <- bind_rows(data_admix)
```

## Admixture plot

```{r, echo=TRUE, eval=FALSE}
data_admix %>%
    ggplot(aes(x = Sample_ID, y = Proportion, fill = pop_group)) +
    geom_col() +
    facet_wrap(~K) +
    scale_fill_brewer(palette = "Set1", name = "Population Group") +
    theme_classic() +
    theme(
        legend.position = "none",
        axis.text.x = element_text(size = 5, angle = 90, hjust = 1, vjust = 0.5)
    ) +
    labs(
        x = "Sample ID",
        y = "Ancestry Proportion",
        title = "ADMIXTURE Ancestry Proportions"
    )
```

## Admixture plot

```{r}
data_admix %>%
    ggplot(aes(x = Sample_ID, y = Proportion, fill = pop_group)) +
    geom_col() +
    facet_wrap(~K) +
    scale_fill_brewer(palette = "Set1", name = "Population Group") +
    theme_classic() +
    theme(
        legend.position = "none",
        axis.text.x = element_text(size = 5, angle = 90, hjust = 1, vjust = 0.5)
    ) +
    labs(
        x = "Sample ID",
        y = "Ancestry Proportion",
        title = "ADMIXTURE Ancestry Proportions"
    )
```

## Plotting the Fst results

```{r}
fst_file <- "chr15.windowed.weir.windowed.weir.fst"
data_fst <- read_tsv(fst_file)
data_fst %>%
    # First, we compute the middle of the windows
    mutate(middle = (BIN_START + BIN_END) / 2) %>%
    # Then, we plot the Fst values
    ggplot(aes(x = middle, y = MEAN_FST)) +
    geom_point(alpha = 0.5) +
    xlab("Window position") +
    ylab("Fst")+
    ylim(0, 1)+
    theme_minimal()
```
