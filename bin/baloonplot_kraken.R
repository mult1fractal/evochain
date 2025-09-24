#!/usr/bin/env Rscript

library(tidyverse)
library(dplyr)


args <- commandArgs(trailingOnly = TRUE)
filein <- args[1]
filout <- args[2]
taxfilter <- args[3]        # S, D, C etc. see kraken out
abundancecutoff <- args[4]  # 0.5
countcutoff <- args[5]     # 100

df <- read.delim(filein, sep="\t",header = FALSE)
colnames(df) <- c("name", "Abundance", "count", "assigned", "data1", "data2", "rank", "taxid", "taxonomy")


df_cleaned <- df %>% filter(count> as.numeric(countcutoff),
                      rank==taxfilter
                      )
                      
head(df_cleaned)

plot <-	ggplot(df_cleaned,
		       aes(x = str_to_title(name), 
			   y = str_to_title(taxonomy),
			   colour = (Abundance),
			   size = Abundance)) +
		  geom_point() +
		  geom_text(aes(label = Abundance), 
			    colour = "white", 
			    size = 3) +

		  coord_cartesian(clip = "off") +
		  scale_size_continuous(range = c(8, 25)) + # Adjust as required.
		  scale_colour_gradient(low = "#1C3144BF", high = "#DB2B39BF") +
		  labs(x = NULL, y = NULL) +
		  theme(legend.position = "none",
			panel.background = element_blank(),
			axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),		
			panel.grid = element_line(colour = "#121F2B1A"),
			panel.grid.major.x = element_blank(),
			plot.margin = margin(0.5,0.2,0.2,0.2, "cm"))
        
        
pdf(filout, height = max(5, length(unique(df_cleaned$taxonomy)) / 2), width = max(5, length(unique(df_cleaned$name))))
plot
dev.off()