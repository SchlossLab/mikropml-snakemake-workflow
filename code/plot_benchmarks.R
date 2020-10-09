source("code/log_smk.R")
library(tidyverse)

dat <- read_csv('results/benchmarks_results.csv') %>%
  mutate(runtime_mins = s / 60,
         memory_gb = max_rss / 1024) %>%
  select(method, runtime_mins, memory_gb) %>%
  pivot_longer(-method, names_to = 'metric') %>%
  group_by(method)

#runtime_plot <- read_csv(snakemake@input[['csv']]) %>%
dat %>%
  ggplot(aes(method, value)) +
  geom_boxplot() +
  facet_wrap(metric ~ ., scales = 'free') +
  theme_classic() +
  labs(y = "", x = "") +
  coord_flip()
ggsave(snakemake@output[["plot"]], plot = runtime_plot)
