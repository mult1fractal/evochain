process gff_faa_merger {
    label "ggplot2"
    publishDir "${params.output}/gff_faa_merge/", mode: 'copy'
    input:
        tuple val(species), path(clean_core_alignment)
    output:
        tuple val(species), path("${species}_clean.core.tree.nwk")
    script:
        """
        FastTree -gtr -nt ${clean_core_alignment} > ${species}_clean.core.tree.nwk
        """
    stub:
        """
        touch ${species}_clean.core.tree.nwk
        """
}