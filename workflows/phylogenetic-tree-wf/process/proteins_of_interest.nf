process proteins_of_interest {
    label "seqkit"
    publishDir "${params.output}/${name}/gff_faa_merge/", mode: 'copy'
    input:
        tuple val(name), path(faa), path(annotation_faa)
    output:
        tuple val(name), path("${name}_proteins_of_interest.faa"), emit: proteins_of_interest_ch, optional: true
    script:
        """
        grep -w -i "${params.gene_name}" ${faa} > temp.txt || true

        # If temp.txt is NOT empty, process it further and create list.txt
        if [ -s temp.txt ]; then
            cut -d" " -f1 temp.txt| tr -d '>' > list.txt
            seqkit grep -f list.txt ${faa} -o ${name}_proteins_of_interest.faa
        else
        touch "${name}_proteins_of_interest.faa"
        fi

        grep -w "${params.gene_name}" ${faa} | cut -d" " -f1 | tr -d '>' > list.txt
        

        """
    stub:
        """
        touch ${name}_anntotaiton_faa_merged.csv
        """
}