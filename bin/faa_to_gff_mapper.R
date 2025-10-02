#!/usr/bin/env Rscript

library(ggplot2)
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
install.packages("data.table")
library(data.table)
# ARGS
 args <- commandArgs(trailingOnly = TRUE)
 bakta_gbff <- args[1]
 faa <- args[2] 


# input for testing in a docker

# funktion to read faa
read_faa<-function (file = NULL) 
{
  faa_lines <- readLines(file)
  seq_name_index <- grep(">", faa_lines)
  seq_name <- gsub(">", "", faa_lines[seq_name_index])
  seq_aa_start_index <- seq_name_index + 1
  seq_aa_end_index <- c(seq_name_index, length(faa_lines) + 
                          1)[-1] - 1
  seq_aa <- rep(NA, length(seq_name_index))
  for (i in seq_along(seq_name_index)) {
    seq_aa_start <- seq_aa_start_index[i]
    seq_aa_end <- seq_aa_end_index[i]
    seq_aa[i] <- gsub("[[:space:]]", "", paste(faa_lines[seq_aa_start:seq_aa_end], 
                                               collapse = ""))
  }
  data.frame(seq_name, seq_aa, stringsAsFactors = FALSE)
}

# # setwd("/input")
#  fasta_data <- read_faa("ATCC700603_bakta.faa")
#  annotation <- suppressMessages(read_delim("ATCC700603_bakta.gff3",
#                                            delim = "\t", escape_double = FALSE,
#                                            col_names = FALSE, comment = c("#"), trim_ws = TRUE))




annotation <- suppressMessages(read_delim(bakta_gbff,
                                          delim = "\t", escape_double = FALSE,
                                          col_names = FALSE, comment = c("#"), trim_ws = TRUE))
fasta_data <- read_faa(faa)


#Cleanup
annotation <- invisible(na.omit(annotation))
annotation<- annotation[!(annotation$X3=="region" | annotation$X3=="gene"),]
annotation <- separate(annotation, X9, c(NA, "ID"), remove = FALSE, "ID=")
annotation$ID <- gsub(";.*","",annotation$ID)
annotation$product <- str_extract(annotation$X9,pattern = "Name=(.*?)(;|$)") 
annotation$product <- gsub("Name=", "", annotation$product)
annotation$product <- gsub(";", "", annotation$product)
annotation$product[annotation$product==""] <- NA
annotation$go <- str_count(annotation$X9,"GO:")
annotation$kegg <- str_count(annotation$X9,"KEGG:")
annotation$pfam <- str_count(annotation$X9,"PFAM:")
annotation$rfam <- str_count(annotation$X9,"RFAM:")
annotation$ec <- str_count(annotation$X9,"EC:")
annotation$cog <- str_count(annotation$X9,"COG:COG")
annotation$cog_group <- str_count(annotation$X9, "COG:(?!COG)")
annotation$so <- str_count(annotation$X9,"SO:")
annotation$uniparc <- str_count(annotation$X9,"UniParc:")
annotation$uniref100 <- str_count(annotation$X9,"UniRef:UniRef100_")
annotation$uniref90 <- str_count(annotation$X9,"UniRef:UniRef90_")
annotation$uniref50 <- str_count(annotation$X9,"UniRef:UniRef50_")

annotation$ct_Domain_un_fun <- str_count(annotation$X9, pattern = "DUF")
annotation$ct_Domain_un_fun[is.na(annotation$ct_Domain_un_fun)==TRUE] <- 0

# And match it to gff by 
fasta_data$seq_name <- sub(" .*", "", fasta_data$seq_name )
# Merging
annotation_merged <- merge(annotation,fasta_data, by.x= "ID", by.y = "seq_name", all=TRUE)
write.csv(annotation_merged, file = "anntotaiton_faa_merged.csv")