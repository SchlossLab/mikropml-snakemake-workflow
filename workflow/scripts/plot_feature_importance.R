schtools::log_snakemake()
library(dplyr)
library(ggplot2)
library(schtools)

feat_df <- read_csv(snakemake@input[["csv"]])

top_feats <- feat_df %>%
  group_by(method, names) %>%
  summarize(median_diff = median(perf_metric_diff)) %>%
  slice_min(order_by = median_diff, n = 5)

feat_plot <- feat_df %>%
  right_join(top_feats, by = c("method", "names")) %>%
  mutate(features = factor(names, levels = rev(unique(top_feats$names)))) %>%
  ggplot(aes(x = perf_metric_diff, y = features, color = method)) +
  geom_boxplot() +
  facet_wrap(~method) +
  theme_sovacool()

ggsave(
  filename = snakemake@output[["plot"]],
  plot = feat_plot,
  device = "png"
)
