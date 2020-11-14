source("code/log_smk.R")
library(tidyverse)

perf_plot <- snakemake@input[["csv"]] %>%
  read_csv() %>%
  mikropml::plot_model_performance() +
  theme_classic() +
  scale_color_brewer(palette = "Dark2") +
  coord_flip()
ggsave(snakemake@output[["plot"]], plot = perf_plot)
