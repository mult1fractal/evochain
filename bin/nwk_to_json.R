#!/usr/bin/env Rscript

# Load the libraries
#install.packages("ape")
#install.packages("jsonlite")
library(ape)
library(jsonlite)



# --- get inputs and define output name ---
# Get command-line arguments (all arguments after the script name)
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

# --- Conversion Function ---
#' Converts an ape 'phylo' tree object to a nested list for JSON export
#' 
#' @param tree An object of class 'phylo' from the ape package.
#' @param node_id The current node index (starts with the root).
#' @return A nested list representing the tree structure.
tree_to_json_list <- function(tree, node_id = Ntip(tree) + 1) {
  # Get the children nodes of the current node
  children_indices <- tree$edge[tree$edge[, 1] == node_id, 2]
  
  # Identify the name (tip or internal node label)
  if (node_id <= Ntip(tree)) {
    node_name <- tree$tip.label[node_id] # Tip node name
  } else {
    # Internal node (use the node's label or index if label is missing)
    node_name <- tree$node.label[node_id - Ntip(tree)]
    if (is.na(node_name) || node_name == "") {
      node_name <- paste0("Node_", node_id)
    }
  }
  
  # Build the current node's JSON object (list in R)
  node_list <- list(name = node_name)
  
  # Add branch length if it exists
  edge_index <- which(tree$edge[, 2] == node_id)
  if (length(edge_index) > 0) {
    node_list$branch_length <- tree$edge.length[edge_index]
  }
  
  # Recursively process children
  if (length(children_indices) > 0) {
    node_list$children <- lapply(children_indices, function(child_id) {
      tree_to_json_list(tree, child_id)
    })
  }
  
  return(node_list)
}


# 1. Read the Newick file
cat("Reading Newick file:", input_file, "\n")
tree_phylo <- read.tree(input_file)

# 2. Convert the 'phylo' object to the hierarchical R list
# Start the recursion from the root node
json_list_root <- tree_to_json_list(tree_phylo)

# 3. Write the nested list to a JSON file
cat("Writing JSON output to:", output_file, "\n")
jsonlite::write_json(json_list_root, output_file, pretty = TRUE, auto_unbox = TRUE)
