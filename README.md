# Evolutionary Genomics Tutorials

This is a collection of tutorials to analyse genome sequencing data using a
unix terminal, R, and/or python.

## Preamble
Many of the tutorials are targeted towards first-time users of the respective tools
and techniques. As such, I sometimes use familiar terms and simplifications
to describe specific concepts
rather than the jargon of the respective informatics community (unix, python, etc.). 
Sometimes this means that statments are generalistions and/or not generally or strictly
correct.

This is to make the entry easier for non-specialists. I still try to convey the most
important and common technical terms and concepts, but I do believe that it helps people to get
an intuitive understanding, if sometimes more accessible terms or explanations are used.

## Unix Terminal

A basic tutorial for first time unix terminal users is given in [UnixBasics](UnixBasics.md).
It also covers how to get a unix terminal running on Windows, MacOS and Linux.

Building on this, the tutorial [UnixIntermediate](UnixIntermediate.md) provides some
experience with using shell variables, shell loops, and shell scripts.

## From raw reads to variant calls and basic popgen analysis

This tutorial treats the case of short read based whole genome resequencing with an existing reference genome.
It covers how to from raw sequencing reads to a basic population genetic analysis.


It is logical to start with [Alignment and Variant Calling](AlignmentVariantCalling.md).
The variant callset produced in this part is then used in
[Population Genomics](PopulationGenomics.md) to run some basic population genomic 
analysis. This tutorial can be run together with the [R plotting tutorial](PlottingPopgenR.md) that shows how to plot the results. 


