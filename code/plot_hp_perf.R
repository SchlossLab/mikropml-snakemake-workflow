source("code/log_smk.R")

hp_perf <- readRDS(snakemake@input[["rds"]])
hp_plot_list <- lapply(hp_perf$params, function(param){
  mikropml::plot_hp_performance(hp_perf$dat, !!rlang::sym(param), !!rlang::sym(hp_perf$metric)) + ggplot2::theme_classic() + ggplot2::scale_color_brewer(palette = "Dark2") + ggplot2::labs(title=unique(hp_perf$method))
})
hp_plot <- cowplot::plot_grid(plotlist = hp_plot_list)
ggplot2::ggsave(snakemake@output[["plot"]])
