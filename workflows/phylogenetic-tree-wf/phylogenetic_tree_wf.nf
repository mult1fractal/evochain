include { snippy } from './process/snippy.nf'
include { fasttree } from './process/fasttree'
include { toytree } from './process/toytree'




workflow phylogenetic_tree_wf {
    take:   chromosomes         // val(name), path("${name}_chromosomes.fasta")
            species             // val(name), path(fasta), val(species), val(kingdom;family;etc;species)
    main:
    species_groups = chromosomes.join(species)
        .map { it -> tuple(it[0], it[1], it[3]) } // val(name), path(chromosome), val(species)
        .groupTuple(by:2)
        .filter{ it -> it[2] != 'unidentified' } // remove channel with unidentified species
        .filter { it -> it[1].size() > 1 } // remove channels with only one element
        .view{ it -> "🌳 The following species reached tree construction: ${it[2]}"}         

    snippy(species_groups)

    toytree(fasttree(snippy.out.alignment))   

    emit:   
    fasttree.out
}