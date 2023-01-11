schtools::log_snakemake()
library(cowplot)
library(mikropml)
library(tidyverse)

dat <- read_csv(snakemake@input[['csv']])
p <- plot_grid(
    dat %>% calc_mean_roc() %>% plot_mean_roc(),
    dat %>% calc_mean_prc() %>% plot_mean_prc()
)

ggsave(
  filename = snakemake@output[["plot"]],
  plot = p,
  device = "png"
)
