schtools::log_snakemake()
library(tidyverse)

dat <- read_csv(snakemake@input[["csv"]],
  col_types = cols(
    s = col_double(),
    `h:m:s` = col_time(format = "%H:%M:%S"),
    max_rss = col_double(),
    max_vms = col_double(),
    max_uss = col_double(),
    max_pss = col_double(),
    io_in = col_double(),
    io_out = col_double(),
    mean_load = col_double(),
    cpu_time = col_double(),
    method = col_character(),
    seed = col_double()
  )
) %>%
  mutate(
    runtime_mins = s / 60,
    memory_gb = max_rss / 1024
  ) %>%
  select(method, runtime_mins, memory_gb) %>%
  pivot_longer(-method, names_to = "metric") %>%
  mutate(value = round(value, 2)) %>%
  group_by(method)

bench_plot <- dat %>%
  ggplot(aes(method, value)) +
  geom_boxplot() +
  facet_wrap(metric ~ ., scales = "free") +
  theme_classic() +
  labs(y = "", x = "") +
  coord_flip()
ggsave(snakemake@output[["plot"]], plot = bench_plot)
