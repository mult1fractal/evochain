#!/bin/bash
    
INFILE=$1
TAXINFO=$2
OUTPUT=$3

	
# count kmers (35 kmer length is default)
	cut -f5 < $INFILE |\
		tr " " "\n" |\
		grep -v ":[0-9]$"|\
		tr ":" "\t" |\
		awk -v OFS='\t' '{ seen[$1] += $2 + 35 } END { for (i in seen) print i, seen[i] }' |\
		sort -k 1b,1  > tmpresults.tsv

# prep tax, while adding the unclassified information
	printf "0\tU\tunclassified\n" > tmptax.tsv
	awk -v OFS='\t' '{print $5, $4, $6, $7, $8, $9, $10, $11, $12}' $TAXINFO |\
		grep -v "#" | grep -v "db," | grep -v "hash" |\
		sort -k 1b,1 >> tmptax.tsv
		

# join and replace the last 3 spaces with tab, so no tab between species names
## header
	printf "TAXID\tBASEPAIRS\tRANK\tNAME\n" > $OUTPUT 
## join and remove total hitsl below 100bp	
	join -1 1 -2 1  <(cat tmpresults.tsv) <(cat tmptax.tsv) |\
		sed 's/ /\t/'| sed 's/ /\t/'| sed 's/ /\t/' | sort -k 2 -h -r |\
		grep -v -P "\t[0-9][0-9]\t" >> $OUTPUT 

# cleanup
rm tmptax.tsv tmpresults.tsv