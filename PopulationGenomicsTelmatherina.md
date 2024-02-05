# Evolutionary Population Genomics of Sulawesi Silversides (*Telmatherinae*)

## Introduction

### Learning goals

The goals of this tutorial is to learn to run basic population genomic analyses
from a unix command line. In the tutorial [PlottingPopgenR](PlottingPopgenR.md)
you will learn how to plot and interpret the output using `R`.

### The study system

The study system is the adaptive radiation of Sailfin Silversides
from the Malili Lakes System in Sulawesi. Here are some slides
by Els De Keyzer that introduce the study system: [Silversides_introduction](Resources/Silversides_introduction.pdf)

### Biological questions

The objective is to gain a basic understanding of relatedness 
patterns and evolutionary of the different species of the radiation.

### The dataset

The dataset are variant call format (VCF) file containing biallelic
single nucleotide polymorphisms (SNPs) of 38 samples of different 
Telmatherina species and of an outgroup, called 
*Marosatherina ladigesi*.

Each file only contains a subset (=small part) of a chromosome
to make computation quicker. Specifically, each file contains a region of 1 megabase 
(= 1 000 000 basepairs), but the file only contains the SNPs in this region,
which is much less than the region size.

#### The metadata

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

## Downloading and checking the data.

### Investigate the metadata

First, investigate the metadata file liked above ([Samples_metadata_sil38_simple.tsv](Data/TelmatherinaPopgen/Samples_metadata_sil38_simple.tsv).
) to know which
samples to expect. Just download it in your operating system's desktop environment
(e.g. Windows), right click it, select *Open with* and search for *Microsoft Excel*
or equivalent.

Alternatively, you can download the metadata with `wget` or `curl` from the unix command
line and investigate the file contents with `less`.

<details>
  <summary><i>I need help doing this.</i></summary> 

```
    wget --no-check-certificate https://raw.githubusercontent.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Samples_metadata_sil38_simple.tsv
    less -S -x 20 Samples_metadata_sil38_simple.tsv

```



</details>

### Download the variant call data

As for the variant call data, there are *VCF files* for different
chromosomes: `Chr1, Chr2, Chr3, Chr4`. Choose one chromosome to start with

<details>
  <summary><i>More details</i></summary>
If you are doing this tutorial in a group, I suggest
that different users choose different chromosomes so that the
results can be compared later. If you are
doing this tutorial with an instructor, let the instructor assign
a chromosome name to you. If you are doing this tutorial alone,
you can just run all steps on all chromosomes, either manually or 
automatised using a for loop, a shell script, a workflos system, and/or 'gnu parallel.
</details>

To download the data to your unix terminal, the following command

> [!IMPORTANT]  
> In the below command there is a paceholder `<chrom>`. You need to replace it by the
> chromosome you have chosen to work with, e.g., `Chr1`

```
wget --no-check-certificate https://raw.github.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data/TelmatherinaPopgen/Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz
```

Type `ls -trsh` to confirm that you have a new files called `Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz`.

###

Inspect the variant call data. (VCF) Variant call format is in principle a tab separated (tsv) text file. However, to optimise storage and read/write times, we 
generally work with a compressed version of it. You can see from the ending `.vcf.gz`
that this is a compressed file, because `.gz` stands for the compression tool `gzip`.

Since the `.vcf` file is compressed, to view it, you could decompress it using `gzip -dc <filename>.vcf.gz > <filename>.vcf` and then investigate the file with `head`, `tail`, `less -S` etc. 
However, do **NOT** run the decompression with a real vcf, because a real `.vcf` would be very big.

To view the vcf file in text format, first decompress it using the program `bcftools view`, then pipe the result into the view command you want to use. For example, run

    bcftools view Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz | less -S


## Computing a pairwise difference matrix

A straightforward way to assess genetic relationships between samples is to count
the number of differences between them (i.e., average number of SNP differences between the two haplotypes in each of the samples). We will use the program called `plink` to calculate pairwise differences. 

The command line for to calculate a distance matrix in plink is as follows

    plink --double-id --vcf Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz --out <output_base_name> --distance square

Note: the flag `--double-id` is needed by plink to allow for underscore characters in the sample names (as is the case for our samples). Note2: It makes sense to give an informative name to `<output_base_name>`, e.g. the type of variants used (snps.pass) and/or the name of the chromosome you are using. I suggest you use `Telmatherina38.pass.snps.biallelic.<chrom>`, where chrom is replaced by your chromosome.

So for chromosome 1, you would run

        plink --double-id --vcf Telmatherina38.pass.snps.biallelic.Chr1.1M.vcf.gz --out Telmatherina38.pass.snps.biallelic.Chr1 --distance square

Use `ls -tr` to display files in the directory with the most recently changed files displayed at the bottom. Which files were produced? Inspect the files using `cat`. 

Load the distance matrix into `R` and plot it with the the sample names next to it. Which samples Are most closely related. Which samples do you think are from the same population? Specifically, there should be two populations with four samples each, can you identify them?

Are the results for the different chromosomes consistent?

## Building a tree of genetic relationships (phylogeny)

Running clustering algorithms on the pairwise differences computed above is a simple way to obtain a tree of genetic relationships (phylogeny). One such algorithm, which has been shown to be consistent with the evolutionary process, is called Neighbour-Joining (NJ).

Sophie will show you how to construct a neighbour joining tree from the pairwise distance matrix and plot it. 

Also load the metadata file into R. This table gives information on the samples such as sampling location, sex, etc. Inspect this file.

Use the metadata to annotate samples in the tree by sampling location. Do samples cluster by sampling location/population?
`
## Principle component analysis (PCA)

Principal component analysis (PCA) is a useful tool to identify sample relationships/populations. Genetic variation between samples is projected in lower dimensional space. Admixed populations can appear as "smear" between parent populations.

We will use `plink` to perform a PCA

    plink --double-id --vcf Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz --out <output_base_name> --pca

Use `ls -tr` to display files in the directory with the most recently changed files displayed at the bottom. Which files were produced? Inspect the files using `cat`. 

Use `R` to plot the PCA and discuss the results.

Sometimes it makes sense to remove rare SNPs (SNPs where only a few individuals are different from the rest) from the PCA. This can give more resolution to differentiate different clades. Try rerunning plink pca with the option `--maf 0.05` to exclude SNPs with less the 5% allele frequency. Does the resulting PCA plot look any differnt?



## Admixture analysis 

`ADMIXTURE` is a software tool for maximum likelihood estimation of individual ancestries from multilocus SNP genotype datasets. It uses the same statistical model as an earlier program called `STRUCTURE`, but runs faster. The model assumes a user-given number of ancestral populations and tries to assign each of the samples to (a mixture of) these hypothetical ancestral populations using the SNP genotype information.

If samples are displayed as a mixture of different ancestral populations, this can provide support for hybridisation and genetic admxiture. However, results have to be interpreted with care. See [Lawson et al. 2018](https://www.nature.com/articles/s41467-018-05257-7).

The manual of admixture can be found [here](https://dalexander.github.io/admixture/admixture-manual.pdf).

We will run `ADMIXTURE` with different numbers of ancestral populations (K). Admixture does not take a .vcf file as input, but it uses a different format called .bed. We will first use `plink` to convert the `.vcf` into a `.bed` file. We will only use SNPs with minor allele frequency greater than 5%.

        plink --double-id --vcf Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz --maf 0.05 --out <output_base_name> --make-bed

Now run admixture with values of `K=2,3,..,7`. Type `admixture --help` to see the syntax. Optional: Write a bash script with for loop to automatise running admixture for these different `K` values.

Plot the results for the differnt K values. 

## Divergence scan

Now we want to look at divergence levels across chromosomes. For this we will compare genetic variation between to species with five and seven samples, respectively: *T. opudi*  and *T. sarasinorum*.

Create two files, `sarasinorum.ids` and `opudi.ids`, containing the sample names of *T. sarasinorum* and *T. opudi* samples, respectively (one sample name per line). (Note that the sample names must be identical as in the `.vcf.gz` file. Check sample names in the vcf.

<details>
  <summary><i>I need help with this.</i></summary>
You could either create these id files manually using `nano` and checking the sample ids
in the metadata file. Or you can do it programatically, by searching for the species name, e.g.

    grep 'opudi' Samples_metadata_sil38_simple.tsv | cut -f1 > opudi.ids
    grep 'sarasinorum' Samples_metadata_sil38_simple.tsv | cut -f1 > sarasinorum.ids   

I recommend build up such a command, first just the first step without pipe '|' to check the output. Then add the first `| command` etc. That way you can check whether the output is as expected. 

</details>

Then, use `vcftools` to calculate fst in 10 kilobase windows, for each window advancing by 1 kilobase. 

        vcftools --gzvcf  Telmatherina38.pass.snps.biallelic.<chrom>.1M.vcf.gz --weir-fst-pop opudi.ids --weir-fst-pop sarasinorum.ids --fst-window-size 10000 --fst-window-step 1000 --out <output_base_name>
        
Load the resulting output file `<output_base_name>.windowed.weir.fst` into R and use the script to plot it.

Discuss the results. How variable are divergence levels along chromosomes. What could be the reasons for this? How do you think would the plot change with larger sample sizes?


