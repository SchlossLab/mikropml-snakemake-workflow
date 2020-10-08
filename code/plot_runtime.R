source("code/log_smk.R")
library(tidyverse)

read_bench <- function(filename) {
  filename %>%
    read_tsv() %>%
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

runtime_plot <- dat %>%
  group_by(method) %>%
  ggplot(aes(method, s)) +
  geom_boxplot() +
  theme_classic() +
  labs(y = "seconds", x = "", title = "Runtime") +
  coord_flip()
ggsave(snakemake@output[["plot"]], plot = runtime_plot)
