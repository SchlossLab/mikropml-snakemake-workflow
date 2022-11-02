rule plot_performance:
    input:
        R="workflow/scripts/plot_performance.R",
        csv="results/{dataset}/performance_results.csv",
    output:
        plot="figures/{dataset}/performance.png",
    log:
        "log/{dataset}/plot_performance.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_performance.R"


if find_feature_importance:

    rule plot_feature_importance:
        input:
            R="workflow/scripts/plot_feature_importance.R",
            csv="results/{dataset}/feature-importance_results.csv",
        output:
            plot="figures/{dataset}/feature_importance.png",
        log:
            "log/{dataset}/plot_feature_importance.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/plot_feature_importance.R"


else:

    rule make_blank_feature_plot:
        output:
            plot="figures/{dataset}/feature_importance.png",
        log:
            "log/{dataset}/make_blank_plot.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/make_blank_plot.R"


rule plot_hp_performance:
    input:
        R="workflow/scripts/plot_hp_perf.R",
        rds="results/{dataset}/hp_performance_results_{method}.Rds",
    output:
        plot="figures/{dataset}/hp_performance_{method}.png",
    log:
        "log/{dataset}/plot_hp_perf_{method}.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_hp_perf.R"


rule plot_benchmarks:
    input:
        R="workflow/scripts/plot_benchmarks.R",
        csv="results/{dataset}/benchmarks_results.csv",
    output:
        plot="figures/{dataset}/benchmarks.png",
    log:
        "log/{dataset}/plot_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_benchmarks.R"
