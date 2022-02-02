
# .tabseq


You probably love fasta. But tell me - can you quickly concatenate all the genes from a fasta alignment of several samples? Can you quickly create a synthetic genome (i.e. core or pan genome) from a list of fasta files containing the harbored genes? If not, then take a look at the _.tabseq_-format.

This is a very simple idea: Use the tab-separated-values format (.tsv or .tab) for sequence data.

Here I come up with some reasonable data-features and conversion scripts that should make it easy to get started ditching the old fasta-format.

I got tired of reformatting fasta and xmfa files again and again. Sometimes you want an alignment where the core genes are concatenated, sometimes you want each gene in order with its own header. It all depends on what software you want to run on your data. If you find that your .fasta or .xmfa data files have the wrong structure for the analysis you want to carry out, you will find yourself spending lots of time restructuring the sequences until they do.

The file format I propose here purposedly solves the aforementioned problems. 

This repository contains the documentation of the .tabseq-format as well as a series of conversion-scripts (both in python and R), that makes it easy to import and export between all imagineable structures and formats. As well as making it possible to easily apply transformations.


## Formatting
As the name suggests, this file format is an heir of the tab-separated-value format. Each line contains one sequence trailed by a number of features.

Four features are required: `sample`, `part`, `comment`, `sequence`. They're all strings. _.tabseq_ files are utf-8 encoded, so you can really put any symbol you'd like. If a feature is not necessary for your project, you can simply fill it with the string: `NA`.

 - `sample`: What is the name of your sample? Here you can specify a unique sample name for your project, the public sample name or just the general species.
 - `part`: It might come handy to be able to subset your sequences in any way. The most typical use for part is to specify the name of the gene the sequence represents. Another typical use is to specify the name of the contig represented.
 - `comment`: Just an auxillary column to put metadata or anything really. If you want to encode more than a single variable worth of information, use the semicolon-separated list of tag=value pairs, as in the GFF format; for example `GC=0.23;strand=+` etc.
 - `sequence`: This is simply the sequence that the whole format is all about. No additives. Just a long line of ATGC' (or any IUPAC DNA/AA code) with no line breaks or fancy symbols.

That is it.

As as omen to command-line tools, the header should begin with a hash `#`, to make it easy to filter out when concatenating files.

### Simple Examples

These examples don't show any complex behaviour, but merely aims to give the reader an intuitive understanding of what the _.tabseq_ format looks like.

_Note:_ in the following examples, the use of tabs is emphasized using tab-symbols_ `⇥`. And the sequences are truncated after 17 bases to make things visible on normal sized screens._

**Example 1**: alignment of one gene from several samples. Here shown with GC and reference ANI information in the comment column.
```
#sample⇥part⇥comment⇥sequence
Rhizobium leguminosarum 3789⇥rpoB⇥GC=0.25;ref_ANI=0.834⇥ATGTGCAGCCGATGATTCTACTAGTGC
Rhizobium leguminosarum 3790⇥rpoB⇥GC=0.23;ref_ANI=0.822⇥ATGGCAGCCGATGATTCTACTAGTGCT
Rhizobium leguminosarum 3792⇥rpoB⇥GC=0.24;ref_ANI=0.899⇥ATGCCAGCCGATGATTCTACTAGTGCT
```

**Example 2**: alignment of full genomes from several samples. Here without any information in the comment column.
```
#species⇥sample⇥part⇥sequence
Rhizobium leguminosarum 3789⇥contig_2⇥NA⇥NNNNNNNNATGTGTGTTTATATAGATT
Rhizobium leguminosarum 3790⇥contig_2⇥NA⇥NNNNNNNNATGTGNGTTTATATAGATT
Rhizobium leguminosarum 3792⇥contig_2⇥NA⇥NNNNNNNNATGTCTGTTTATATAGATT
```

**Example 3**: All genes from one sample. 
```
#species⇥sample⇥part⇥sequence
Rhizobium leguminosarum 3789⇥gutA⇥NA⇥ATGCGATGTGAGCACGCACAGCAAGCT
Rhizobium leguminosarum 3789⇥rpoB⇥NA⇥ATGATATAGTGACTGACATGCAGAGCT
Rhizobium leguminosarum 3789⇥Glyt⇥NA⇥ATGCTGATCTGCGCCACGTGAAAAGCT
```



If you just want to store a sequence, and nothing else, it is not a problem. Just be aware that an empty string is not equivalent to `NA`.


**Example 4**: just a sequence
```
#species⇥sample⇥part⇥sequence
⇥⇥NA⇥ATCTGCGTCACGACGTACGATAACGATCTCATTATGACATCTACTACGAT
```

And of course you can save aminoacids as well


**Example 5**: just a sequence of amino acids
```
#species⇥sample⇥part⇥sequence
⇥⇥NA⇥GSTTSAAVGSILSEEGVPINSGCO
```

---- to do line ----
## Conversion-scripts

In order to help converting between formats, I created (in progress) a series of scripts "conversion-scripts" that help with this.

At the time of writing, only one such scripts exists: `tabseq2fasta.py`
This file will convert the tabseq to fasta, by the arguments given.


# Installation of R-package (all platforms)
Install and load devtools, then install directly from github

```{R}
if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")
}

devtools::install_github("cmkobel/tabseq")

# Then load the library in your script
library(tabseq)
```


# Installation of cli-tools (lunix)

Clone this repo, and expand your path to the `python/` directory.

Depends on python3.

```{sh}
cd ~
git clone git@github.com:cmkobel/tabseq.git

# Optionally, add the conversion scripts to your PATH-variable
echo "PATH=\$PATH:~/tabseq/python" >> ~/.bashrc
```

**Dependencies**:
 * git
 * python3
