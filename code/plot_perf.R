source("code/log_smk.R")
library(dplyr)
library(ggplot2)
perf_plot <- snakemake@input[["csv"]] %>%
  readr::read_csv() %>%
  mikropml::plot_performance() +
    theme_classic() +
    scale_color_brewer(palette = "Dark2") +
    coord_flip()
ggsave(snakemake@output[["plot"]], plot = perf_plot)
