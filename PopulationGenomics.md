# Evolutionary Population Genomics Tutorial

## Instruction

Each students should start with a biallelic pass SNP vcf produced by the AlignmentVariantcalling tutorial. Each student should work with a different chromosome. For each analyses step, compare and discuss the results for the different chromosomes. 

## Introduction

### Learning goals

The goals of this tutorial is to learn to run basic population genomic analyses from a unix command line and plot and interpret the output using `R`.

### The study system

See AlignmentVariantcalling tutorial.

### Biological questions

See AlignmentVariantcalling tutorial.

### The dataset

See AlignmentVariantcalling tutorial.

### The VCF file format

VCF (Variant Call Format) is a  text file format that is used to store genetic variation such as SNPs or insertions/deletions. The full format specifications and valuable information about the different tags can be found [here](https://samtools.github.io/hts-specs/VCFv4.2.pdf).

## Computing a pairwise difference matrix

A straighforward way to assess genetic relationships between samples is to count the number of differences between them (i.e., average number of SNP differences between the two haplotypes in each of the samples). We will use the program called `plink` to calculate pairwise differences. 

The command line for to calculate a distance matrix in plink is as follows

    plink --double-id --vcf snps.pass.biallelic.vcf --out <output_base_name> --distance square

Note: the flag `--double-id` is needed by plink to allow for underscore characters in the sample names (as is the case for our samples). Note2: It makes sense to give an informative name to `<output_base_name>`, e.g. the type of variants used (snps.pass) and/or the name of the chromosome you are using.

Use `ls -tr` to display files in the directory with the most recently changed files displayed at the bottom. Which files were produced? Inspect the files using `cat`. 

Load the distance matrix into `R` and plot it with the the sample names next to it. Which samples Are most closely related. Which samples do you think are from the same population? Are the results for the different chromosomes consistent?

## Building a tree of genetic relationships (phylogeny)

Running clustering algorithms on the pairwise differences computed above is a simple way to obtain a tree of genetic relationships (phylogeny). One such algorithm, which has been shown to be consistent with the evolutionary process, is called Neighbour-Joining (NJ).

Alexandros will show you how to construct a neighbour joining tree from the pairwise distance matrix and plot it. 

Also load the metadata file into R. This table gives information on the samples such as sampling location, sex, etc. Inspect this file.

Use the metadata to annotate samples in the tree by sampling location. Do samples cluster by sampling location/population?

## Principle component analysis (PCA)

Principal component analysis (PCA) is a useful tool to identify sample relationships/populations. Genetic variation between samples is projected in lower dimensional space. Admixed populations can appear as "smear" between parent populations.

We will use `plink` to perform a PCA

    plink --double-id --vcf snps.pass.biallelic.vcf --out <output_base_name> --pca

Use `ls -tr` to display files in the directory with the most recently changed files displayed at the bottom. Which files were produced? Inspect the files using `cat`. 

Use `R` to plot the PCA and discuss the results.

Sometimes it makes sense to remove rare SNPs (SNPs where only a few individuals are different from the rest) from the PCA. This can give more resolution to differentiate different clades. Try rerunning plink pca with the option `--maf 0.05` to exclude SNPs with less the 5% allele frequency. Does the resulting PCA plot look any differnt?


