#!/usr/bin/env Rscript


library(ggplot2)
library(readr)
library(tidyr)
library(scales)

INPUTS = commandArgs(trailingOnly=TRUE)

cov_file <-  read_delim(INPUTS[1], 
                      delim = "\t", escape_double = FALSE, 
                      col_names = FALSE, trim_ws = TRUE)

tax_file <-  read_delim(INPUTS[2], 
                      delim = "\t", escape_double = FALSE, 
                      col_names = TRUE, trim_ws = TRUE)                  

colnames(cov_file)           

colnames(tax_file)    

# Merges the two dataframes together but fills it in based on taxonomic id
# this way we get the correct species names behind each taxon id
df_merged <- merge(cov_file,tax_file,by.y ="tax_id",by.x = "X4")
# Create a unique colum for the  plot titles
df_merged$melted_columns <- paste(df_merged$species,"[ Mapped reads =",df_merged$X5,"]")

# Plotting

plot <- ggplot(data = df_merged, aes(x=X2, y=X3, col= melted_columns)) + geom_line() +
	facet_wrap(~melted_columns, scales='free', ncol = 3) + 
    	xlab("Position in basepairs") + ylab("Coverage") + 
    	theme(legend.position="none") + theme(panel.background = element_blank(), panel.border = element_rect(colour = "lightgrey", fill=NA, size=1)) +
        scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x), labels = trans_format("log10", math_format(10^.x)))

# autoscaling the image on the y axis
number_of_plots <- floor(length(unique(df_merged$X4))+2/3) * 1


#svg(INPUTS[3], height = number_of_plots, width = 15)
svg(paste0(INPUTS[3],".svg"), height = 4, width = 8)
plot
dev.off()

png(paste0(INPUTS[3],".png"), height = 400, width = 800, res = 200)
plot
dev.off()