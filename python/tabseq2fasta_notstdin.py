#!/usr/bin/env python3


import sys

__author__ = "Carl Mathias Kobel"
__version__ = "0.0" # Not tested enough


def eprint(string, *args, **kwargs):
    print(string, *args, **kwargs, file = sys.stderr)


f"""
	This is the tabseq2fasta_cf.py script
	It ouputs a wrapped fasta file to output.
	The script might need testing?
"""



input_file = sys.argv[1]
fill_sample = sys.argv[2]

eprint(f"Reading from {input_file}...")
# Read input file

def wrap(sequence):
	# Wrap
	rv = ''
	for i in range(0, len(sequence), 60):
		rv += sequence[i:(i+60)] + '\n'
	return rv.strip()

#rv = ''
num = 0
with open(input_file, 'r') as input_file_open:
	for line in input_file_open:
		if line[0] == '#':
			continue

		sample, part, comment, sequence = line.split('\t')
		sequence = sequence.strip("\n")


		if part == "NA":
			part = ""
		else:
			part = "_" + part

		if comment == "NA":
			comment = ""
		else:
			comment = "_" + comment

		fasta_header = f">{sample}{part}{comment}" # "look at the tree" # A_NA_3328-130A
		print(fasta_header)


		#print(wrap(sequence))
		print(sequence)
		num += 1


# Print fasta header.
#stem = '.'.join(input_file.split('.')[:-1])
#print(f">{stem}")



# Wrap
#for i in range(0, len(rv), 60):
#	print(rv[i:(i+60)])



eprint('Wrote', num, 'sequences to stdout.\n')