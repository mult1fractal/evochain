#!/usr/bin/env Rscript

library(purrr)
library(highcharter)
library(tidyr)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
filein <- args[1]
filout <- args[2]
taxfilter <- args[3]        # S, D, C etc. see kraken out
abundancecutoff <- args[4]  # 0.5
countcutoff <- args[5]     # 100

df <- read.delim(filein, sep="\t",header = FALSE)

colnames(df) <- c("name", "Abundance", "count", "assigned", "rank", "taxid", "taxonomy")

df_cleaned <- df %>% filter(count> countcutoff,
                      Abundance > abundancecutoff
                      )                  

head(df_cleaned)

fig <- highchart() %>%
hc_add_series(data = df_cleaned[df_cleaned$rank==taxfilter,],
         type = "column",
         hcaes(x = name, y = Abundance, group = taxonomy),
         stacking = "percent")  %>%
  hc_chart(
    scrollablePlotArea = list(minWidth = 1000),
    zoomType = "y"
  ) %>%
    hc_xAxis(
    categories = unique(df_cleaned$name)
    ) %>%
    hc_size(height = 1200)


# render html with libs
htmltools::save_html(fig, file = "fig_tmp.html")

#convert to complete html
htmlwidgets:::pandoc_self_contained_html("fig_tmp.html", filout)