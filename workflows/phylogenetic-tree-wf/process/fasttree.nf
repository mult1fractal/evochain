process fasttree {
    publishDir "${params.output}/fasttree/", mode: 'copy'
    label "fasttree"
    tag "${params.gene_name}"
    input:
        path(alignment)
        path(metadata)
        path(protein_ids)
    output:
        path("tree.nwk"), emit: tree_ch
        path("extracted_records.csv"), emit: metadata_ch
    script:
        """
        cat *anntotaiton_faa_merged.csv > all_meta_data.csv
        
        # First, print the header line from the data.csv
        head -n 1 all_meta_data.csv > extracted_records.csv

        grep -F -f ${protein_ids} all_meta_data.csv >> extracted_records.csv

        rm all_meta_data.csv
        rm *_bakta_anntotaiton_faa_merged.csv

        export OMP_NUM_THREADS=${task.cpus}
        FastTree -gtr  ${alignment} > tree.nwk
        """

    stub:
        """
        touch tree.nwk
        touch extracted_records.csv
        """
}
