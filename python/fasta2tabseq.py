#!/usr/bin/env python3

import sys


__author__ = "Carl M. Kobel"
__version__ = "0.1"


def eprint(*args, **kwargs):
    print(*args, **kwargs, file = sys.stderr)
 
eprint(f"""
    This is the fasta2tabseq.py conversion script,
    compatible with multi line fasta files.
    Parsing fasta from stdin...
""")

# TODO: Implement --fill_sample
fill_sample = ""
fill_sample = sys.argv[1].strip()


# Print the header
print('sample', 'part', 'comment', 'sequence', sep = '\t')


def write(fasta_header, dna):
    print(f"{fill_sample}\t{fasta_header}\t\t{dna}")


fasta_header = ""
dna = ""
init = True
for line in sys.stdin: #[i for i in sys.stdin] + [">"]:


    if line[0] == ">":
        
        # Output contents
        if not init:
            write(fasta_header, dna)
        
        init = False

        dna = "" # Reset buffer

        # Get ready for new DNA
        fasta_header = line[1:].strip() #.replace("\t", " ").replace(" ", "_")
        
    elif line[0] == "\n":
        continue
    else:
        
        dna += line.strip()

write(fasta_header, dna)


