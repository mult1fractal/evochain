process nwk_to_json {
    publishDir "${params.output}/nwk_to_json/", mode: 'copy'
    label 'nwk_to_json'
  input:
    path(tree) 
  output:
	path("*tree.json")
  script:
    """  
    nwk_to_json.R ${tree} tree.json
    """
}