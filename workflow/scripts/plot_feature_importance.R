schtools::log_snakemake()
library(dplyr)
library(ggplot2)
library(schtools)

feat_df <- readr::read_csv(snakemake@input[["csv"]])
top_n <- as.numeric(snakemake@params[['top_n']])

top_feats <- feat_df %>%
  group_by(method, names) %>%
  summarize(median_diff = median(perf_metric_diff)) %>%
  slice_max(order_by = median_diff, n = top_n)

feat_plot <- feat_df %>%
  right_join(top_feats, by = c("method", "names")) %>%
  mutate(features = factor(names, levels = unique(top_feats$names))) %>%
  ggplot(aes(x = perf_metric_diff, y = features, color = method)) +
  geom_boxplot() +
  facet_wrap(~method) +
  theme_sovacool()

ggsave(
  filename = snakemake@output[["plot"]],
  plot = feat_plot,
  device = "png"
)
