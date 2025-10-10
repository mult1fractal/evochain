// Define color codes


def startupMSG() {
    def c_turquoise = "\033[1;36m"
    def c_green = "\033[1;32m"
    def c_dim = "\033[2;37m"
    def c_reset = "\033[0m"
    def c_enabled = "${c_green}ENABLED${c_reset}"
    def c_disabled = "${c_dim}DISABLED${c_reset}"
    def line = "─" * 30

    def gff3_status = params.gff3 ? c_enabled : c_disabled
    def protein_status = params.protein ? c_enabled : c_disabled
    def gene_status = params.gene_name ? params.gene_name : "N/A"
    def fasta_compare = params.fasta ? c_enabled : c_disabled
    

    log.info """
${c_turquoise}${line} Tree_GP Workflow Information ${line}${c_reset}
${c_turquoise}Profile:           ${c_reset}${workflow.profile}
${c_turquoise}Current User:      ${c_reset}${workflow.userName}
${c_turquoise}Nextflow Version:  ${c_reset}${nextflow.version}
${c_turquoise}Start Time:        ${c_reset}${nextflow.timestamp}
${c_turquoise}Results Dir:       ${c_reset}${params.output}
${c_turquoise}Work Dir:          ${c_reset}${workflow.workDir}

${c_turquoise}Inputs:${c_reset}
  GFF3:              ${gff3_status}
  Protein FASTA:     ${protein_status}
  Search For:        ${gene_status}
  Fasta comparison:  ${fasta_compare}
  

${c_turquoise}Cores:             ${c_reset}${params.cores}
${c_turquoise}Max Cores:         ${c_reset}${params.max_cores}
${c_turquoise}${line * 3}${c_reset}
"""
}




def helpMSG() {
  def c_green = "\033[0;32m";
  def c_reset = "\033[0m";
  def c_yellow = "\033[0;33m";
  def c_blue = "\033[0;34m";
  def c_dim = "\033[2m";
  log.info """
  ${c_yellow}Usage example:${c_reset}
    nextflow run /path/to/evochain.nf --gff3 '/path/to/file.gff3' --protein '/path/to/go_terms.txt' --gene_name -profile local,docker
    nextflow run /path/to/evochain.nf --fasta '/path/to/file.fasta' -profile local,docker

  ${c_yellow}Input options:${c_reset}
    --gff3              Input GFF3 file for gene annotation
    --protein           Input protein FASTA file
    --gene_name         name of the gene you want to build a tree for
    --fasta             Input FASTA files for comparison (no gene search)

    {c_yellow}NOTE: file.gff3 and file.faa should have the same filename ${c_reset} 
  

  ${c_yellow}General options:${c_reset}
    --output            Output directory
    --cores             Number of cores per process${c_dim} Default: ${params.cores} ${c_reset}
    --max_cores         Maximum number of cores to use${c_dim} Default: ${params.max_cores} ${c_reset}
    --help              Show this message and exit

  ${c_yellow}Error handling:${c_reset}
    ${c_dim}--profile is WRONG use -profile${c_reset}
    ${c_dim}No input provided via [--gff3], [--protein] ${c_reset}
   

  ${c_yellow}Workflow steps:${c_reset}
    1. Search genes of interest (if --gff3 --protein and --gene_name provided)
    2. Align sequences using MAFFT (if --fasta provided)

  ${c_blue}Profiles for execution (via -profile):${c_reset}
    local, docker

  """.stripIndent()
}
