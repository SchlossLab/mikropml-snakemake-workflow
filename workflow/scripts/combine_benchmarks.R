source("code/log_smk.R")
library(tidyverse)

read_bench <- function(filename) {
    read_tsv(filename) %>%
        mutate(
            method = str_replace(filename, "^benchmarks/runs/run_ml.(.*)_(.*).txt", "\\1"),
            seed = str_replace(filename, "^benchmarks/runs/run_ml.(.*)_(.*).txt", "\\2")
        )
}

dat <- snakemake@input[["tsv"]] %>%
    lapply(read_bench) %>%
    bind_rows()
head(dat)
write_csv(dat, snakemake@output[['csv']])
