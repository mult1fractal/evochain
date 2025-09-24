    #!/bin/bash
    
    BAMFILE=$1
    TAXID=$2
    NAME=$3
    
    # Get mapped reads
    MAPPED_READS=$(samtools coverage  ${BAMFILE} | tail -n+2 | cut -f4 | awk '{s+=$1} END {print s}')

    # Create coverage info and append additional informations for plotting
    samtools depth -a  ${BAMFILE} |\
        awk -v a="${TAXID}" '{print $0,a}' OFS='\t' |\
        awk -v a="${MAPPED_READS}" '{print $0,a}' OFS='\t' \
        > ${NAME}_${TAXID}.tsv


    # generate summary



    samtools coverage ${BAMFILE} |\
        awk -F'\t' \
        -v awk_tax_id="${TAXID}" \
        -v awk_name="${NAME}" \
        '{sum_size += $3; sum_reads += $4; sum_bases += $5} END {print "tax_id\tname\tgenome_size\tcovered_bases\tmapped_reads\n" awk_tax_id "\t" awk_name "\t" sum_size "\t" sum_bases "\t" sum_reads "\n"}' \
        > ${NAME}_${TAXID}_summary.tsv

# generate statistics - needs to read into channel and calculate it there via "it" then save to csv file
# samtools coverage merged_fastq_54291.bam | awk -F'\t' '{sum_size += $3; sum_reads += $4; sum_bases += $5} END {print "genome_size\tcovered_bases\tmapped_reads\n" sum_size "\t" sum_bases "\t" sum_reads}' 
