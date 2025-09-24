process fasttree {
    label "fasttree"
    publishDir "${params.output}/phylotrees/", mode: 'copy'
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