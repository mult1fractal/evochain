process remove_duplicate_faa {
    label "seqkit"
    publishDir "${params.output}/unique_faa/", mode: 'copy'
    input:
        path(faa)
    output:
        path("removed_duplicates_protein.faa"), emit: deduplicated_faa_ch
        path("unique_ids_clean.txt"), emit: unique_ids_ch

    script:
        """
        mkdir faa_files
        mv ${faa} faa_files/
        cat faa_files/*.faa > all_proteins.faa

        seqkit rmdup -n  all_proteins.faa > removed_duplicates_protein.faa

        grep ">" removed_duplicates_protein.faa > unique_ids.txt
        tr -d '>' < unique_ids.txt | cut -d" " -f1 > unique_ids_clean.txt

        ## zcat reads_1.fq.gz | seqkit rmdup -s -o clean.fa.gz
        """
    stub:
        """
        touch removed_duplicates_protein.faa
        """
}