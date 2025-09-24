#!/usr/bin/env Rscript
library(tidyverse)

args <- commandArgs(trailingOnly = TRUE)
filein <- args[1]
filout <- args[2]
taxfilter <- args[3]        # S, D, C etc. see kraken out
abundancecutoff <- args[4]  # 0.5
countcutoff <- args[5]      # 100
highlight <- args[6]      # Homo or homosapiens

df <- read.delim(filein, sep = "\t", header = FALSE)
colnames(df) <- c("name", "Abundance", "count", "assigned", "rank", "taxid", "taxonomy")

df_cleaned <- df %>% filter(
    count > as.numeric(countcutoff),
    Abundance > as.numeric(abundancecutoff),
    rank == taxfilter
)
#Change to "Homo sapiens" if white space problem will be eliminated
df_cleaned$h_sapiens <- as.factor(ifelse(df_cleaned$taxonomy == paste0(" ", highlight), TRUE, FALSE))

head(df_cleaned)

plot <- ggplot(
    df_cleaned,
    aes(
        x = name,
        y = taxonomy,
        colour = (Abundance),
        size = Abundance
    )
) +
    geom_point() +
    geom_text(aes(label = Abundance),
        colour = "white",
        size = 3
    ) +
    coord_cartesian(clip = "off") +
    scale_size_continuous(range = c(8, 25)) +
    scale_colour_gradient(low = "#1C3144BF", high = "#DB2B39BF") +
    labs(x = NULL, y = NULL) +
    theme(
        legend.position = "none",
        panel.background = element_blank(),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        panel.grid = element_line(colour = "#121F2B1A"),
        panel.grid.major.x = element_blank(),
        plot.margin = margin(1, 0.2, 0.2, 1, "cm"),   # top right bottom left
        strip.text = element_blank()
    ) +
    facet_grid(rows = vars(fct_rev(h_sapiens)), scales = 'free', space = 'free') +
    scale_y_discrete(limits=rev)

pdf(filout, height = max(6, length(unique(df_cleaned$taxonomy)) / 2), width = max(5, length(unique(df_cleaned$name))))
plot
dev.off()