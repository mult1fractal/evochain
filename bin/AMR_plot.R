#!/usr/bin/env Rscript

library(ggplot2)
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
#install.packages("data.table")
library(data.table)
# ARGS
args <- commandArgs(trailingOnly = TRUE)
filein <- args[1]
kraken <- args[2] 
kreport <- args[3]
filout <- args[4]


# Assuming your TSV file is named "BK10220_k14_amrfinder.tsv"
# Replace with the actual file name if different


kraken <- fread(kraken, header = FALSE)
kreport <- read_tsv(kreport, col_names = FALSE)
amrfinderin <- read_tsv(filein, col_names = TRUE)


merged_df <- merge(amrfinderin, kraken, by.x = "Contig id", by.y = "V2", all.x = FALSE)
# drop some columns
merged_df["V5"] <- NULL
merged_df["V4"] <- NULL

amrfinder <- merge(merged_df, kreport, by.x = "V3", by.y = "X7", all.x = FALSE)


amrfinder <- amrfinder %>%
  mutate(Subclass = str_replace(Subclass, "/", "/\n"))
amrfinder <- amrfinder %>%
  drop_na(`% Coverage of reference`, `Element symbol`, Subclass)


amrfinder$`X8` <- sub(" .*", "", amrfinder$`X8`)

#head(amrfinder)


amrfinder$X8[grepl("^C", amrfinder$X6)] <- "unclassified"
amrfinder$X8[grepl("^D", amrfinder$X6)] <- "unclassified"
amrfinder$X8[grepl("^F", amrfinder$X6)] <- "unclassified"
amrfinder$X8[grepl("^K", amrfinder$X6)] <- "unclassified"
amrfinder$X8[grepl("^P", amrfinder$X6)] <- "unclassified"
amrfinder$X8[grepl("^R", amrfinder$X6)] <- "unclassified"
amrfinder$X8[grepl("^O", amrfinder$X6)] <- "unclassified"



#str(amrfinder)

# Create the plot, mapping point size to the count
plot <- ggplot(amrfinder, aes(x = `% Coverage of reference`, y = `Element symbol`)) +
  geom_jitter(height = 0.30, alpha = 0.7, size = 1) +
  xlim(20, 100) +
  facet_grid(Subclass ~ X8, scales = "free", space = "free") + 
  theme_bw() +
  labs(title = "Antimicrobial resistance genes found in all reads", x = "AMR gene fraction found per Read", y = "Resistance gene name") +
  theme(strip.text.y = element_text(angle = 0, hjust = 0, size = 6))  +
  theme(strip.text.x = element_text(angle = 0, hjust = 0, size = 6))  +
  theme(panel.grid.minor = element_blank()) +
  labs(color = "Likely\ntaxonomic\nrank")  +
  theme(legend.position = "bottom") +
  #scale_color_brewer(palette = "Paired") +
  theme(legend.position = "none") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 6 ))
pdf(filout, height = max(6, length(unique(amrfinder$`Element symbol`)) / 3), width = max(8, length(unique(amrfinder$X8))))
plot
dev.off()

#ggsave(filout)