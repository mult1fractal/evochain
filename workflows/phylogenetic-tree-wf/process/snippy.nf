process snippy {
    label "snippy"
    publishDir "${params.output}/phylotrees/", mode: 'copy'
    input:
        tuple val(name), path(chromosome), val(species)
    output:
        tuple env("SPECIES"), path("*_clean.full.aln"), emit: alignment
    script:
        """
        SPECIES=\$(echo "${species}" | tr " " "_")

        # Sort fastas and references away for snippy
            mkdir -p genomes reference
            mv ${chromosome} genomes/
            ls genomes/* | head -1 | xargs -I{} mv {} reference/

        # Run snippy
            for fasta in genomes/*
                do
                    FILENAME=\$(basename \${fasta%.*})
                    snippy --cpus ${task.cpus} --outdir \${SPECIES}/\${FILENAME}/ --ref reference/* --ctgs \${fasta}
                done

            snippy-core --ref reference/* --prefix results \${SPECIES}/*/

        # Replace non-[AGTCN-] chars with 'N'
            snippy-clean_full_aln results.full.aln > \${SPECIES}_clean.full.aln

        # Replace "Reference" with first name of fasta list head 1 w/o suffix
            NAME=\$(ls reference/ | rev | cut -f 2- -d "." | rev)
            sed -i "s/Reference/\$NAME/g" \${SPECIES}_clean.full.aln

        """
    stub:
        """
        \${SPECIES}_clean.full.aln
        """  
}