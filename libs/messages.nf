

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
    def gene_status = params.gene ? c_enabled : c_disabled
    def go_terms_status = params.go_terms ? c_enabled : c_disabled

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
  Gene FASTA:        ${gene_status}
  GO Terms:          ${go_terms_status}

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
    nextflow run <workflow_name> --gff3 '/path/to/file.gff3' --go_terms '/path/to/go_terms.txt' -profile local

  ${c_yellow}Input options:${c_reset}
    --gff3              Input GFF3 file for gene annotation
    --protein           Input protein FASTA file
    --gene              Input gene FASTA file

  ${c_yellow}Search options:${c_reset}
    --go_terms          File with GO terms to search (requires --gff3, --protein, or --gene)
    --gene_name         Search for specific gene names (requires --gff3 or --gene)
    --gene_description  Search for gene descriptions (requires --gff3 or --gene)

  ${c_yellow}General options:${c_reset}
    --output            Output directory
    --cores             Number of cores per process${c_dim} Default: ${params.cores} ${c_reset}
    --max_cores         Maximum number of cores to use${c_dim} Default: ${params.max_cores} ${c_reset}
    --report            Inject a custom report template

  ${c_yellow}Error handling:${c_reset}
    ${c_dim}--profile is WRONG use -profile${c_reset}
    ${c_dim}No input provided via [--gff3], [--protein], or [--gene]${c_reset}
    ${c_dim}[--go_terms] requires an input file via [--gff3], [--protein], or [--gene]${c_reset}
    ${c_dim}[--gene_name] requires an input file via [--gff3] or [--gene]${c_reset}
    ${c_dim}[--gene_description] requires an input file via [--gff3] or [--gene]${c_reset}

  ${c_yellow}Workflow steps:${c_reset}
    1. Search genes of interest (if --gff3 or --gene provided)
    2. Search proteins of interest (if --protein provided)
    3. Visualisation of results

  ${c_blue}Profiles for execution (via -profile):${c_reset}
    local, docker, singularity, slurm

  """.stripIndent()
}
