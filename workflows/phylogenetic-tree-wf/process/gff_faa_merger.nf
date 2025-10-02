process gff_faa_merger {
    label "r"
    publishDir "${params.output}/{name}/gff_faa_merge/", mode: 'copy'
    input:
        tuple val(name), path(faa), path(gff)
    output:
        tuple val(name), path("${name}_anntotaiton_faa_merged.csv")
    script:
        """
        faa_to_gff_mapper.R ${gff} ${faa}
        mv anntotaiton_faa_merged.csv ${name}_anntotaiton_faa_merged.csv
        """
    stub:
        """
        touch ${name}_anntotaiton_faa_merged.csv
        """
}