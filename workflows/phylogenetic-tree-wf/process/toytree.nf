process toytree {
    publishDir "${params.output}/phylotrees/", mode: 'copy'
    label 'toytree'
  input:
    tuple val(name), path(tree)
  output:
	  tuple path("tree_${name}.svg"), path("tree_${name}.pdf"), path("tree_radial_${name}.svg"), path("tree_radial_${name}.pdf")
  script:
    """
    cp ${tree} tree_INPUT.newick
    vis_tree_features.py
    vis_tree_features_radial.py

    mv tree.svg tree_${name}.svg
    mv tree.pdf tree_${name}.pdf
    mv tree_radial.svg tree_radial_${name}.svg
    mv tree_radial.pdf tree_radial_${name}.pdf
    """
  stub:
    """
    echo "storing"
    """  
}
