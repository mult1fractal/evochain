include { gff_faa_merger } from './process/gff_faa_merger.nf'
include { snippy } from './process/snippy.nf'
include { toytree } from './process/toytree.nf'
include { fasttree } from './process/fasttree.nf'
include { proteins_of_interest } from './process/proteins_of_interest.nf'
include { mafft } from './process/mafft.nf'
include { nwk_to_json } from './process/nwk_to_json.nf'




workflow search_proteins_wf {
    take:   gff_protein         // val(name), path("${name}_chromosomes.fasta")
                      // val(name), path(fasta), val(species), val(kingdom;family;etc;species)
    main:
                
                
                // process_extract genes of interest from merged faa-gff file(gff_faa_merger.out) tuple val(name), path(merged), val(params.protein_of_interest)
                proteins_of_interest(gff_protein)

                // Error handling if no proteins found - stop the workflow
                proteins_of_interest.out.proteins_of_interest_ch
                        .subscribe { sample_name, list_file ->

                if (list_file.size() == 0) {
                        error("No ${params.gene_name} found. Please search for another gene")
                        }
                }
                
                // merge gff and faa files
                gff_faa_merger(gff_protein)

                mafft(proteins_of_interest.out.map { it -> it[1] }.collect())

                collected_metadata = gff_faa_merger.out.map { it -> it[1] }.collect()
                fasttree(mafft.out, collected_metadata)
                nwk_to_json(fasttree.out.tree_ch)

                //toytree(fasttree.out)   

    //emit:    fasttree.out
}