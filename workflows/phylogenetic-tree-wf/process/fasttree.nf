process fasttree {
    publishDir "${params.output}/fasttree/", mode: 'copy' , pattern: "*"
    label "fasttree"
    input:
        path(alignment)
        path(metadata)
    output:
        path("tree.nwk"), emit: tree_ch
        path("all_meta_data.csv"), emit: metadata_ch
    script:
        """
        cat *anntotaiton_faa_merged.csv > all_meta_data.csv
        export OMP_NUM_THREADS=${task.cpus}
        FastTree -gtr  ${alignment} > tree.nwk
        """

    stub:
        """
        touch tree.nwk
        """
}