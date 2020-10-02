source('code/log_smk.R')
library(dplyr)
snakemake@input[['csv']] %>%
  mikropml::plot_performance() %>%
  ggplot2::ggsave(snakemake@output[['png']])
