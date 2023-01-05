schtools::log_snakemake()
library(tidyverse)

wildcard_names <- snakemake@wildcards %>%
    names() %>%
    Filter(function(x) {nchar(x) > 0}, .)
wildcards <- snakemake@wildcards[wildcard_names] %>%
    as_tibble() %>%
    mutate(seed = as.numeric(seed))

read_tsv(snakemake@input[['tsv']]) %>%
  bind_cols(wildcards) %>%
  write_csv(snakemake@output[['csv']])
