source("code/log_smk.R")
library(tidyverse)

dat <- read_csv(snakemake@input[['csv']]) %>%
  mutate(runtime_mins = s / 60,
         memory_gb = max_rss / 1024) %>%
  select(method, runtime_mins, memory_gb) %>%
  pivot_longer(-method, names_to = 'metric') %>%
  group_by(method)

bench_plot <- dat %>%
  ggplot(aes(method, value)) +
  geom_boxplot() +
  facet_wrap(metric ~ ., scales = 'free') +
  theme_classic() +
  labs(y = "", x = "") +
  coord_flip()
ggsave(snakemake@output[["plot"]], plot = bench_plot)
