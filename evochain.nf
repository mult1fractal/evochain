#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- Gene/Protein Tree an Search Workflow
* Author: mult1fractal
*/

include { search_proteins_wf } from './workflows/phylogenetic-tree-wf/search_proteins_wf.nf'
include { helpMSG; startupMSG }                 from './libs/messages.nf'

workflow {

    if ( params.help ) { exit 0, helpMSG() }

    startupMSG()

    /*************
    ERROR HANDLING
    *************/
    if ( params.profile ) { exit 1, "--profile is WRONG use -profile" }
    if ( !params.gff3 && !params.protein && !params.gene_name ) {
        exit 6, "No input provided via [--gff3], [--protein], or [--gene]"
    }
    if ( params.gff3 && params.protein && !params.gene_name ) {
        exit 6, "No input provided via [--gene_name]"
    }
    // if ( params.go_terms && !(params.gff3 || params.protein || params.gene) ) {
    //     exit 7, "[--go-terms] requires an input file via [--gff3], [--protein], or [--gene]"
    // }
    // if ( params.gene_name && !(params.gff3 || params.gene) ) {
    //     exit 8, "[--gene_name] requires an input file via [--gff3] or [--gene]"
    // }
    // // if ( params.gene_description && !(params.gff3 || params.gene) ) {
    // //     exit 9, "[--gene_description] requires an input file via [--gff3] or [--gene]"
    // // }

    /**************************
    * INPUTs and checks
    **************************/

    gff3_input_ch = params.gff3 ?
        Channel.fromPath(params.gff3, checkIfExists: true)
            .map { file -> tuple(file.baseName, file) } :
        Channel.empty()

    protein_input_ch = params.protein ?
        Channel.fromPath(params.protein, checkIfExists: true)
            .map { file -> tuple(file.baseName, file) } :
        Channel.empty()

    /*************
    * Workflow
    *************/

    // Search genes of interest
    // if (params.gff3 && params.gene) {
    //     search_genes_wf(
    //         gff3_input_ch.mix(gene_input_ch),
    //         params.go_terms,
    //         params.gene_name,
    //         params.gene_description
    //     )
    // }

    // Search proteins of interest
   
    // if (params.gff3 && params.protein && (params.go || params.gene_name || params.gene_description) ) {
        search_proteins_input_ch = protein_input_ch.join(gff3_input_ch)
                                               
        search_proteins_input_ch.view()
                       
        
    // }

        if (params.gff3 && params.protein && params.gene_name ) {
        search_proteins_wf(search_proteins_input_ch)

                    
    }


}
