schtools::log_snakemake()
library(ggplot2)
message("making a blank plot")
ggsave(
  filename = snakemake@output[["plot"]],
  plot = ggplot(),
  device = "png"
)
