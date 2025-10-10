process mafft {
    publishDir "${params.output}/{name}/mafft/", mode: 'copy'
    label 'mafft'
  input:
    path(faa) 
  output:
	  path("protein_alignments.msa")
  script:

    """
    mkdir faa_files
    mv ${faa} faa_files/
    cat faa_files/*.faa > all_proteins.aa
  	mafft --thread ${task.cpus} --auto all_proteins.aa > protein_alignments.msa
    """
   
  stub:
   """
   touch protein_alignments.msa
   """
}

// (up to ∼5,000) on a standard desktop computer
// FFT-NS-1 or FFT-NS-2; for medium-large datasets and accuracy, G-INS-1 is good;
