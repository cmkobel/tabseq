
# \<your file name\>`.tabseq`

[![R-CMD-CHEK](https://github.com/cmkobel/tabseq/workflows/R-CMD-CHECK/badge.svg)](https://github.com/cmkobel/tabseq/actions)
## Brief
Tabseq is simply a sequence file standard based on a the tabular file format - like a .tsv-file.

## Background
Many great data tools work well with rectangular data (think .tsv and .csv files) files. The fasta format though requires specialized tools. Tasks as simple as measuring the length of sequences (could be contigs or genes) in a fasta file requires specialized tools like awk, bioawk, biopython etc. Data scientists will be proficient in arranging content in rectangular file formats, so why don't we apply these skills on our sequence files instead of learning all these extra tools just to work with sequence data? - Sequences are -after all- just data like anything else that we tend to put into a rectangular format anyway.

## R and tidyverse
Working with sequences in a rectangular format comes with pros. As this project is mainly an R-package intended to be imported together with tidyverse, working with sequences in the tabseq format opens up the possibility of using column operations and string operations that tidyverse does so well.

For instance you can use stringr::sub_str() to extract parts of a sequence, think about genes inside a chromosome. You can use dplyr::filter and left_join to filter and join individual genes from different samples or species based on database lookups: For instance, you could use dplyr::inner_join to get the core genes from a set of species. This, you could of course also do with a GFF file, but with `.tabseq` you have the option to take the sequences along, and make concatenations, reverse_complements, GC_measurements and k-mer observations right off the bat.  

The concept is simple, and hopefully you will find it to be powerful as well. Below, we will walk through a few examples together, to make it clear how this works in practice.

## So, what does it look like?

Imagine a file containing the 16S gene from two different species.
The corresponding .tabseq file might look something like this: 
```
#sample              part   metadata                   sequence
E. coli K12          16S    strand=+;ref_ANI=0.980;    AAAGAATAAGTTAGGACAGCACTTTTTAAATGACATT...
S. acidocaldarius    16S    strand=+;ref_ANI=0.973;    AGAGAAAAAGTTATTACAGCACATTTAAAATGAAATT...
```
(The white space is supposed to resemble tap stops)

The first line starting with a #-symbol is simply the header, defining the four columns that make up the structure of the .tabseq-format. Any line starting with a #-symbol is interpreted as a comment. Consequently, the header is unecessary, but may be included to make human-reading more straightforward. 

The four columns are required: `sample`, `part`, `metadata`, `sequence`. They're all strings. tabseq files are utf-8 encoded, so you can really put any symbol you'd like. If a feature is not necessary for your project, you can can either fill it with the R NA-value, or leave it empty (surrounded by two tab symbols).

TODO: Consider renaming column _comment_ to _metadata_.

### Column definitions

 1. `sample`: What is the name of your sample? Here you can specify a unique sample name for your project, the public sample name or just the general species.
 2. `part`: It might come handy to be able to subset your sequences in any way. The most typical use for part is to specify the name of the gene the sequence represents. Another typical use is to specify the name of the contig represented.
 3. `metadata`: This is an auxillary column to put metadata or anything really. If you want to encode more than a single variable worth of information, use the semicolon-separated list of name=value pairs, as in the GFF format; for example `GC=0.23;strand=+` etc. The R-package comes with tools to expand and condense these `name=value;` pairs.
 4. `sequence`: This is the sequence that the whole format is all about. Just a long line of ATGCs (or any IUPAC DNA/AA code) with no line breaks or fancy symbols.

 

## Conversion scripts

In order to help converting between formats, I created a series of conversion scripts that help with this. Using these conversion scripts means that won't have to fire up R to convert a tabseq into fasta, or vice versa.


# Installation of R-package (all platforms)
Install and load devtools, then install directly from github
Minimum R version required is 3.6.3

```R
if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")
}

devtools::install_github("cmkobel/tabseq")

# Then load the library in your script
# library(tidyverse)
library(tabseq)
```


# Installation of cli conversion scripts (macos/linux/unix)

Clone this repo, and expand your path to the `python/` directory.

Depends on python3.

```bash
cd ~
git clone git@github.com:cmkobel/tabseq.git

# Optionally, add the conversion scripts to your PATH-variable
echo "PATH=\$PATH:~/tabseq/python" >> ~/.bashrc
```

**Dependencies**:
 * git
 * python3
