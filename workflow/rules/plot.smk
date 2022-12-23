rule plot_performance:
    input:
        csv="results/{dataset}/performance_results.csv",
    output:
        plot=report("figures/{dataset}/performance.png",
                    category="Results",
                    subcategory="{dataset}"),
    log:
        "log/{dataset}/plot_performance.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_performance.R"


if find_feature_importance:

    rule plot_feature_importance:
        input:
            csv="results/{dataset}/feature-importance_results.csv",
        output:
            plot=report("figures/{dataset}/feature_importance.png",
                        category="Results",
                        subcategory="{dataset}"),
        log:
            "log/{dataset}/plot_feature_importance.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/plot_feature_importance.R"


else:

    rule make_blank_feature_plot:
        output:
            plot=report("figures/{dataset}/feature_importance.png",
                        category="Results",
                        subcategory="{dataset}"),
        log:
            "log/{dataset}/make_blank_plot.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/make_blank_plot.R"


rule plot_hp_performance:
    input:
        rds="results/{dataset}/hp_performance_results_{method}.Rds",
    output:
        plot=report("figures/{dataset}/hp_performance_{method}.png",
                    category="Results",
                    subcategory="{dataset}"),
    log:
        "log/{dataset}/plot_hp_perf_{method}.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_hp_perf.R"


rule plot_benchmarks:
    input:
        csv="results/{dataset}/benchmarks_results.csv",
    output:
        plot=report("figures/{dataset}/benchmarks.png",
                    category="Results",
                    subcategory="{dataset}",
                    caption="../report/benchmarks.rst"),
    log:
        "log/{dataset}/plot_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_benchmarks.R"
