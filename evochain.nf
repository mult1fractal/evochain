#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- Gene/Protein Tree an Search Workflow
* Author: mult1fractal
*/

include { search_genes_wf; search_proteins_wf } from './workflows/search_wf'
include { visualisation_wf }                    from './workflows/visualisation_wf'
include { helpMSG; startupMSG }                 from './libs/messages.nf'

workflow {

    if ( params.help ) { exit 0, helpMSG() }

    startupMSG()

    /*************
    ERROR HANDLING
    *************/
    if ( params.profile ) { exit 1, "--profile is WRONG use -profile" }
    if ( !params.gff3 && !params.protein && !params.gene ) {
        exit 6, "No input provided via [--gff3], [--protein], or [--gene]"
    }
    if ( params.go_terms && !(params.gff3 || params.protein || params.gene) ) {
        exit 7, "[--go-terms] requires an input file via [--gff3], [--protein], or [--gene]"
    }
    if ( params.gene_name && !(params.gff3 || params.gene) ) {
        exit 8, "[--gene_name] requires an input file via [--gff3] or [--gene]"
    }
    if ( params.gene_description && !(params.gff3 || params.gene) ) {
        exit 9, "[--gene_description] requires an input file via [--gff3] or [--gene]"
    }

    /**************************
    * INPUTs and checks
    **************************/

    gff3_input_ch = params.gff3 ?
        Channel.fromPath(params.gff3, checkIfExists: true)
            .map { file -> tuple(file.baseName, file, "gff3") } :
        Channel.empty()

    protein_input_ch = params.protein ?
        Channel.fromPath(params.protein, checkIfExists: true)
            .map { file -> tuple(file.baseName, file, "protein") } :
        Channel.empty()

    gene_input_ch = params.gene ?
        Channel.fromPath(params.gene, checkIfExists: true)
            .map { file -> tuple(file.baseName, file, "gene") } :
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
    if (params.gff3 && params.protein && (params.go || params.gene_name || params.gene_description) ) {
        search_proteins_wf(
          gff3_input_ch.mix(protein_input_ch)
        )
    }

    // Visualisation
    visualisation_wf(
        search_genes_wf.out.results.mix(search_proteins_wf.out.results)
    )
}
