# Evolutionary Genomics Tutorial
A tutorial/assignment on how to get from raw sequencing reads to a basic population genetic analysis.

## Introduction

### Background and Aim
This activity will guide you through some of the basic steps for getting from whole-genome sequencing data to filtered variant calls and to do some basic population/evolutionary genetic analyses. Some intermediate steps are simplified but it should give you a good idea.

### Learning goals
After this activity, you should be able to
- understand the structure of .fastq, .fasta, .sam/.bam, .vcf files
- run basic quality control (QC) on sequencing reads
- align reads to a reference genome and get basic alignment stats
- call genetic variants and understand and apply basic hard filters to variants
- run basic QC on a vcf file
- reconstruct a basic phylogeny applying the neighbour-joinint algorithm to pairwise genetic differences

### How to follow this tutorial

#### General user (UAntwerp Omics Techniques course students can skip this section)

You need a computer with a unix command line and the following software installed
- fastQC
- bwa
- samtools
- bcftools
- plink

All these programs can be easily installed with conda or other package managers. You can search the internet on how to install them.

#### University of Antwerp students of Omics Techniques course

To run the analyses, you first need to connect to the CalcUA login node the way that you had learned it. From there you will connect to a different server/computer where you can run compuations.

Connect to leibniz the way that you have learned it, e.g., 

`ssh -i <path_to_key_file> <username>@login1-leibniz.hpc.uantwerpen.be`

Note that things in <> should be replaced by the value approapriate for your case, e.g., <username> could be replaced by your vscXXXX username. On windows, use MobaXterm to establish connection. Hint: your key file is likely located in a hidden subfolder of your home folder: `~/.ssh/`
  
Once on the leibniz login node, connect to our private node (*r0c03cn1*)

`ssh r0c03cn1`
  
On the privade node, activate a compute environment that has all software installed that we will need.
  
`/data/antwerpen/grp/asvardal/miniconda3/bin/conda activate`
  
Start a byobu session
  
`byobu`
  
## Warming up inspect the reads
  
## The study system
 
See presentation slides by Henrique Leitao
  
## Read aligment
[If not already done] Create a folder `<firstname_lastname>` in `/scratch/antwerpen/grp/aomicscourse`
 
  <details>
    <summary>Show me how to do this.</summary>
    
    
    cd /scratch/antwerpen/grp/aomicscourse
    mkdir max_mustermann
    
    
  </details>
  
  Copy the reads into your folder
  
   <details>
    <summary>Show me how to do this.</summary>
    
    
    cp ../genomics_activity/alignment_variant_calling/reads/HC_21_002.*
    
    
  </details>
  
  


