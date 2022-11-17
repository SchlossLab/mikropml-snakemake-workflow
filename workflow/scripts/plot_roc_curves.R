schtools::log_snakemake()
library(tidyverse)

blues <- RColorBrewer::brewer.pal(name = "Blues", n = 9)
greens <- RColorBrewer::brewer.pal(name = "Greens", n = 9)

# TODO: use tidy eval to make one function each for calc_mean_[roc/prc] and plot_[auroc/auprc]
calc_mean_roc <- function(sens_dat) {
  sens_dat %>%
    mutate(specificity = round(specificity, 2)) %>%
    group_by(specificity) %>%
    summarise(
      mean_sensitivity = mean(sensitivity),
      sd_sensitivity = sd(sensitivity)
    ) %>%
    mutate(
      upper = mean_sensitivity + sd_sensitivity,
      lower = mean_sensitivity - sd_sensitivity
    ) %>%
    mutate(
      upper = case_when(
        upper > 1 ~ 1,
        TRUE ~ upper
      ),
      lower = case_when(
        upper < 0 ~ 0,
        TRUE ~ lower
      )
    )
}

calc_mean_prc <- function(sens_dat) {
  sens_dat %>%
    rename(recall = sensitivity) %>%
    mutate(recall = round(recall, 2)) %>%
    group_by(recall) %>%
    summarise(
      mean_precision = mean(precision),
      sd_precision = sd(precision)
    ) %>%
    mutate(
      upper = mean_precision + sd_precision,
      lower = mean_precision - sd_precision
    ) %>%
    mutate(
      upper = case_when(
        upper > 1 ~ 1,
        TRUE ~ upper
      ),
      lower = case_when(
        upper < 0 ~ 0,
        TRUE ~ lower
      )
    )
}

# sensitivity vs specificity
plot_roc <- function(roc_dat) {
  roc_dat %>%
    ggplot(aes(
      x = specificity, y = mean_sensitivity,
      ymin = lower_sens, ymax = upper_sens
    )) +
    geom_ribbon(fill = blues[3]) +
    geom_line(color = blues[9]) +
    coord_equal() +
    geom_abline(intercept = 1, slope = 1, linetype = "dashed", color = "grey50") +
    scale_y_continuous(expand = c(0, 0), limits = c(-0.01, 1.01)) +
    scale_x_reverse(expand = c(0, 0), limits = c(1.01, -0.01)) +
    labs(x = "Specificity", y = "Sensitivity") +
    theme_bw() +
    theme(
      plot.margin = unit(x = c(2, 8, 0, 0), units = "pt"),
      legend.title = element_blank()
    )
}

calc_baseline_precision <- function(metadat) {
    # TODO: generalize this function for any outcome
    cdiff_tally <- metadat %>% group_by(pos_cdiff_d1) %>% tally()
    npos <- cdiff_tally %>% filter(pos_cdiff_d1 == 'yes') %>% pull(n)
    ntot <- cdiff_tally %>% pull(n) %>% sum()
    baseline_prec <- npos / ntot
    return(baseline_prec)
}

# precision vs recall
plot_prc <- function(prc_dat, baseline_precision) {
  prc_dat %>%
    ggplot(aes(
      x = recall, y = mean_precision,
      ymin = lower, ymax = upper
    )) +
    geom_ribbon(fill = greens[3]) +
    geom_line(color = greens[9]) +
    coord_equal() +
    geom_hline(yintercept = baseline_precision, linetype = "dashed", color = "grey50") +
    scale_y_continuous(expand = c(0, 0), limits = c(-0.01, 1.01)) +
    scale_x_continuous(expand = c(0, 0), limits = c(-0.01, 1.01)) +
    labs(x = "Recall", y = "Precision") +
    theme_bw() +
    theme(
      plot.margin = unit(x = c(2, 5, 0, 0), units = "pt"),
      legend.position = "none"
    )
}

# TODO: plot roc curves
ggsave(
  filename = snakemake@output[["plot"]],
  plot = ggplot() +
    theme_void(),
  height = 0.1, width = 0.1,
  device = "png"
)
