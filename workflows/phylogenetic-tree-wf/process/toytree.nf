process toytree {
    publishDir "${params.output}/phylotrees/", mode: 'copy'
    label 'toytree'
  input:
    path(tree)
  output:
	  tuple path("tree.svg"), path("tree.pdf"), path("tree_radial.svg"), path("tree_radial.pdf")
  script:
    """

    
    cp ${tree} tree_INPUT.newick
    vis_tree_features.py
    vis_tree_features_radial.py

    mv tree.svg tree_.svg
    mv tree.pdf tree_.pdf
    mv tree_radial.svg tree_radial.svg
    mv tree_radial.pdf tree_radial.pdf
    """
  stub:
    """
    echo "storing"
    """  
}
