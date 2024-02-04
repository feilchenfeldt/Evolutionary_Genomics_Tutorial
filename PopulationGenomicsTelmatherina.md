# Evolutionary Population Genomics of Sulawesi Silversides (*Telmatherinae*)

## Introduction

### Learning goals

The goals of this tutorial is to learn to run basic population genomic analyses
from a unix command line. In the tutorial [PlottingPopgenR](PlottingPopgenR.md)
you will learn how to plot and interpret the output using `R`.

### The study system

The study system is the adaptive radiation of Sailfin Silversides
from the Malili Lakes System in Sulawesi. Here are some slides
by Els De Keyzer that introduce the study system.

### Biological questions

The objective is to gain a basic understanding of relatedness 
patterns and evolutionary of the different species of the radiation.

### The dataset

The dataset is a variant call format (VCF) file containing biallelic
single nucleotide polymorphisms (SNPs) of 38 samples of different 
Telmatherina species and of an outgroup, called 
*Marosatherina ladigesi*.

You can find a table with metadata, like sample ids, species names, etc., 
here: 
[Samples_metadata_sil38_simple.tsv](Data/TelmatherinaPopgen/Samples_metadata_sil38_simple.tsv).

### The VCF file format

VCF (Variant Call Format) is a  text file format that is used to store genetic variation such as SNPs or insertions/deletions. The full format specifications and valuable information about the different tags can be found [here](https://samtools.github.io/hts-specs/VCFv4.2.pdf).

### How to get to a VCF file from sequencing reads

The tutorial [AlignmentVariantCalling](AlignmentVariantCalling.md)
teaches the basic steps how to obtain SNP data (variant calls)
starting from Illumina sequencing reads and aligning them against
a reference genome, but for a *different* dataset/study system.

## Setting up the software environment

We will need a unix/linux command line and the following programs
installed:
```
  - plink
  - bcftools
  - vcftools
  - admixture
```

If you don't have them installed on your system, which you can test
by typing `<program_name>` or `which <program_name>`, we recommend installing
them using `conda`. If you have not installed conda,
follow the instructions in
 [UnixSoftwareInstallationAndConda](UnixSoftwareInstallationAndConda.md).

### Setting up conda environment

To set up the conda environment, first create a conda environment
file called `popgen.env.yaml` and add the following content:

```
name: popgen
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - plink
  - bcftools
  - vcftools
  - admixture
```

  <details>
    <summary>I need help to do this.</summary>

    nano popgen.env.yaml
 Then copy paste all the lines above between `name: popgen` and
`- admixture` into the file. Press `ctrl o` to save and `ctrl x` to
exit.

  </details>

Now that you have the environment file, create a new conda environment
by executing

    conda env create -f popgen.env.yaml

Activate the new environment using

    conda activate popgen

Now you will see `(popgen)` at the right most side of your command
line. This tells you that you are in the environment `popgen` in
which the above programs are installed. 

[!Tip] Note that entering a conda environment does not change your
current directory. You are still in the same current directory you
were in before.

## Computing a pairwise difference matrix

A straighforward way to assess genetic relationships between samples is to count the number of differences between them (i.e., average number of SNP differences between the two haplotypes in each of the samples). We will use the program called `plink` to calculate pairwise differences. 

The command line for to calculate a distance matrix in plink is as follows

    plink --double-id --vcf snps.pass.biallelic.vcf --out <output_base_name> --distance square

Note: the flag `--double-id` is needed by plink to allow for underscore characters in the sample names (as is the case for our samples). Note2: It makes sense to give an informative name to `<output_base_name>`, e.g. the type of variants used (snps.pass) and/or the name of the chromosome you are using.

Use `ls -tr` to display files in the directory with the most recently changed files displayed at the bottom. Which files were produced? Inspect the files using `cat`. 

Load the distance matrix into `R` and plot it with the the sample names next to it. Which samples Are most closely related. Which samples do you think are from the same population? Specifically, there should be two populations with four samples each, can you identify them?

Are the results for the different chromosomes consistent?

## Building a tree of genetic relationships (phylogeny)

Running clustering algorithms on the pairwise differences computed above is a simple way to obtain a tree of genetic relationships (phylogeny). One such algorithm, which has been shown to be consistent with the evolutionary process, is called Neighbour-Joining (NJ).

Alexandros will show you how to construct a neighbour joining tree from the pairwise distance matrix and plot it. 

Also load the metadata file into R. This table gives information on the samples such as sampling location, sex, etc. Inspect this file.

Use the metadata to annotate samples in the tree by sampling location. Do samples cluster by sampling location/population?
`
## Principle component analysis (PCA)

Principal component analysis (PCA) is a useful tool to identify sample relationships/populations. Genetic variation between samples is projected in lower dimensional space. Admixed populations can appear as "smear" between parent populations.

We will use `plink` to perform a PCA

    plink --double-id --vcf snps.pass.biallelic.vcf --out <output_base_name> --pca

Use `ls -tr` to display files in the directory with the most recently changed files displayed at the bottom. Which files were produced? Inspect the files using `cat`. 

Use `R` to plot the PCA and discuss the results.

Sometimes it makes sense to remove rare SNPs (SNPs where only a few individuals are different from the rest) from the PCA. This can give more resolution to differentiate different clades. Try rerunning plink pca with the option `--maf 0.05` to exclude SNPs with less the 5% allele frequency. Does the resulting PCA plot look any differnt?

## Admixture analysis 

`ADMIXTURE` is a software tool for maximum likelihood estimation of individual ancestries from multilocus SNP genotype datasets. It uses the same statistical model as an earlier program called `STRUCTURE`, but runs faster. The model assumes a user-given number of ancestral populations and tries to assign each of the samples to (a mixture of) these hypothetical ancestral populations using the SNP genotype information.

If samples are displayed as a mixture of different ancestral populations, this can provide support for hybridisation and genetic admxiture. However, results have to be interpreted with care. See [Lawson et al. 2018](https://www.nature.com/articles/s41467-018-05257-7).

The manual of admixture can be found [here](https://dalexander.github.io/admixture/admixture-manual.pdf).

We will run `ADMIXTURE` with different numbers of ancestral populations (K). Admixture does not take a .vcf file as input, but it uses a different format called .bed. We will first use `plink` to convert the `.vcf` into a `.bed` file. We will only use SNPs with minor allele frequency greater than 5%.

        plink --double-id --vcf snps.pass.biallelic.vcf --maf 0.05 --out <output_base_name> --make-bed

Now run admixture with values of K=2,3,..,7. Type `admixture --help` to see the syntax. Write a bash script to automatise running admixture for these different K values.

Plot the results for the differnt K values. 

## Divergence scan

Now we want to look at divergence levels across chromosomes. For this we will compare genetic variation between the two populations with four samples each, Zooridge and Gifberg.

Create two files, `gifberg.ids` and `zooridge.ids`, containing the sample names of Gifberg and Zooridge samples, respectively (one sample name per line). (Note that the sample names must be identical as in the `.vcf` file. Check sample names in the vcf.

Then, use `vcftools` to calculate fst in 10 kilobase windows, for each window advancing by 1 kilobase. 

        vcftools --vcf snps.pass.biallelic.vcf --weir-fst-pop gifberg.ids --weir-fst-pop zooridge.ids --fst-window-size 10000 --fst-window-step 1000 --out <output_base_name>
        
Load the resulting output file `chr15.windowed.weir.fst` into R and use Alexandros script to plot it.

Discuss the results. How variable are divergence levels along chromosomes. What could be the reasons for this? How do you think would the plot change with larger sample sizes?


