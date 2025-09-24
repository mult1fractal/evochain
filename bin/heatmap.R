#!/usr/bin/env Rscript

library(readr)
library(ggplot2)
library(dplyr)
library(reshape2)
library(viridis)

# File locations
matrix_file_loc <- "matrix_input.txt"
samplenames_file_loc <- "samplename_input.txt"
heatmaptitle <- "beta diversity"

matrix <-  read_delim(matrix_file_loc, 
                      delim = "\t", escape_double = FALSE, 
                      col_names = FALSE, trim_ws = TRUE, skip = 1)

samplenames <- read_table(samplenames_file_loc,col_names = FALSE)
samplenames$X2 <- sapply (strsplit(samplenames$X2 , '.bracken' ), `[` , 1)

samplenames$X1<- gsub("^.{0,1}", "", samplenames$X1)
matrix_proc <- merge(matrix, samplenames[,1:2], by.x ="X1", by.y ="X1" )
rownames(matrix_proc)<- matrix_proc$X2.y
matrix_proc$X1 <- NULL
matrix_proc$X2.y <- NULL
colnames(matrix_proc) <- rownames(matrix_proc)


matrix_proc[matrix_proc == "x.xxx"] <- NA
matrix_proc <- sapply( matrix_proc, as.numeric )
matrix_proc[lower.tri(matrix_proc)] <- t(matrix_proc)[lower.tri(matrix_proc)]
rownames(matrix_proc) <- colnames(matrix_proc)
melted_matrix_proc <- melt(matrix_proc, na.rm = TRUE)

#Plot
plot <- ggplot(melted_matrix_proc, aes(x = Var2, y = Var1, fill=value)) + 
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "inferno",direction = -1,limits = c(0,1), name="") + 
  theme(
    panel.background = element_blank(),
    axis.text.x = element_text(angle = 45,, hjust=1),
    axis.text.y = element_text(vjust = 0.5, hjust=1), 
    plot.title = element_text(hjust = 0.5)) +
  labs(x="", y="", title = heatmaptitle)



svg("heatmap_beta-diversity.svg", height = 6, width = 6)
plot
dev.off()