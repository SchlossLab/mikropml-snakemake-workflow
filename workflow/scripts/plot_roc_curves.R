schtools::log_snakemake()
library(patchwork)
library(tidyverse)


dat <- read_csv(snakemake@input[["csv"]])

calc_mean_perf <- function(sensspec_dat,
                           group_var = specificity,
                           sum_var = sensitivity,
                           custom_group_vars = NULL) {
    specificity <- sensitivity <- sd <- NULL
    dat_round <- sensspec_dat %>%
        dplyr::mutate({{ group_var }} := round({{ group_var }}, 2))
    if (!is.null(custom_group_vars)) {
        dat_grouped <- dat_round %>%
            dplyr::group_by({{ group_var }}, !!rlang::sym(custom_group_vars))
    } else {
        dat_grouped <- dat_round %>%
            dplyr::group_by({{ group_var }})
    }
    return(
    dat_grouped %>%
        dplyr::summarise(
            mean = mean({{ sum_var }}),
            sd = stats::sd({{ sum_var }})
        ) %>%
        dplyr::mutate(
            upper = mean + sd,
            lower = mean - sd,
            upper = dplyr::case_when(
                upper > 1 ~ 1,
                TRUE ~ upper
            ),
            lower = dplyr::case_when(
                lower < 0 ~ 0,
                TRUE ~ lower
            )
        ) %>%
        dplyr::rename(
            "mean_{{ sum_var }}" := mean,
            "sd_{{ sum_var }}" := sd
        )
    )
}

calc_mean_roc <- function(sensspec_dat, custom_group_vars = NULL) {
    specificity <- sensitivity <- NULL
    return(calc_mean_perf(sensspec_dat,
                          group_var = specificity,
                          sum_var = sensitivity,
                          custom_group_vars = custom_group_vars
    ))
}

calc_mean_prc <- function(sensspec_dat, custom_group_vars = NULL) {
    sensitivity <- recall <- precision <- NULL
    return(calc_mean_perf(
        sensspec_dat %>%
            dplyr::rename(recall = sensitivity),
        group_var = recall,
        sum_var = precision,
        custom_group_vars = custom_group_vars
    ))
}

shared_ggprotos <- function(colorvar) {
    return(list(
        ggplot2::geom_ribbon(aes(fill = {{ colorvar }}), alpha = 0.5),
        ggplot2::geom_line(aes(color = {{ colorvar }})),
        ggplot2::coord_equal(),
        ggplot2::scale_y_continuous(expand = c(0, 0), limits = c(-0.01, 1.01)),
        ggplot2::theme_bw(),
        ggplot2::theme(legend.title = ggplot2::element_blank())
    ))
}

plot_mean_roc <- function(dat) {
    specificity <- mean_sensitivity <- lower <- upper <- NULL
    dat %>%
        ggplot2::ggplot(ggplot2::aes(
            x = specificity, y = mean_sensitivity,
            ymin = lower, ymax = upper
        )) +
        shared_ggprotos(colorvar = method) +
        ggplot2::geom_abline(intercept = 1, slope = 1,
                             linetype = "dashed", color = "grey50") +
        ggplot2::scale_x_reverse(expand = c(0, 0), limits = c(1.01, -0.01)) +
        ggplot2::labs(x = "Specificity", y = "Mean Sensitivity")
}

plot_mean_prc <- function(dat, baseline_precision = NULL) {
    recall <- mean_precision <- lower <- upper <- NULL
    prc_plot <- dat %>%
        ggplot2::ggplot(ggplot2::aes(
            x = recall, y = mean_precision,
            ymin = lower, ymax = upper
        )) +
        shared_ggprotos(colorvar = method) +
        ggplot2::scale_x_continuous(expand = c(0, 0), limits = c(-0.01, 1.01)) +
        ggplot2::labs(x = "Recall", y = "Mean Precision")
    if (!is.null(baseline_precision)) {
        prc_plot <- prc_plot +
            ggplot2::geom_hline(
                yintercept = baseline_precision,
                linetype = "dashed", color = "grey50"
            )
    }
    return(prc_plot)
}
p <- (dat %>%
        calc_mean_roc(custom_group_vars = 'method') %>%
        plot_mean_roc()) +
    (dat %>%
        calc_mean_prc(custom_group_vars = 'method') %>%
        plot_mean_prc() +
        theme(legend.position = 'none'))

ggsave(
  filename = snakemake@output[["plot"]],
  plot = p,
  device = "png",
  height = 4,
  width = 6
)
