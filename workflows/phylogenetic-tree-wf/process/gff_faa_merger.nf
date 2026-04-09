process gff_faa_merger {
    label "r"
    publishDir "${params.output}/gff_faa_merge/${name}/", mode: 'copy'
    input:
        tuple val(name), path(faa), path(gff)
        path lifestyle_csv
    output:
        tuple val(name), path("${name}_anntotaiton_faa_merged.csv")
    script:
        def lifestyle_arg = params.lifestyle_info ? "\"${lifestyle_csv}\"" : '""'
        """
        faa_to_gff_mapper.R ${gff} ${faa} ${lifestyle_arg}
        mv anntotaiton_faa_merged.csv ${name}_anntotaiton_faa_merged.csv
        """
    stub:
        """
        touch ${name}_anntotaiton_faa_merged.csv
        """
}