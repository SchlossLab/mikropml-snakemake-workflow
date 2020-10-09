source("code/log_smk.R")
library(tidyverse)

runtime_plot <- read_csv(snakemake@input[['csv']]) %>%
  group_by(method) %>%
  ggplot(aes(method, s)) +
  geom_boxplot() +
  theme_classic() +
  labs(y = "seconds", x = "") +
  coord_flip()
ggsave(snakemake@output[["plot"]], plot = runtime_plot)
