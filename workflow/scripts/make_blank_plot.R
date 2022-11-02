schtools::log_snakemake()
library(ggplot2)
message("making a blank plot")
ggsave(
  filename = snakemake@output[["plot"]],
  plot = ggplot() +
    theme_void(),
  height = 0.1, width = 0.1,
  device = "png"
)
