""" Plot ML results
"""


rule plot_performance:
    input:
        csv="results/performance-results.csv",
    output:
        plot=report(
            "figures/performance.png",
            category="Performance",
            subcategory="Model Performance",
        ),
    log:
        "log/plot_performance.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_performance.R"


if find_feature_importance:

    rule plot_feature_importance:
        input:
            csv="results/feature_importance-results.csv",
        output:
            plot=report(
                "figures/feature_importance.png",
                category="Feature Importance",
            ),
        params:
            top_n=5,
        log:
            "log/plot_feature_importance.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/plot_feature_importance.R"

else:

    rule make_blank_feature_plot:
        output:
            plot="figures/feature_importance.png",
        log:
            "log/make_blank_plot.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/make_blank_plot.R"


rule plot_hp_performance:
    input:
        rds=f"results/{wildcard_no_seed}/hp_performance_results.Rds",
    output:
        plot=report(
            f"figures/{wildcard_no_seed}/hp_performance.png",
            category="Performance",
            subcategory="Hyperparameter Tuning",
        ),
    log:
        f"log/{wildcard_no_seed}/plot_hp_perf.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_hp_perf.R"


rule plot_benchmarks:
    input:
        csv="results/benchmarks-results.csv",
    output:
        plot=report(
            "figures/benchmarks.png",
            category="Performance",
            subcategory="Runtime & Memory Usage",
            caption="../report/benchmarks.rst",
        ),
    log:
        "log/plot_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_benchmarks.R"


rule plot_roc_curves:
    input:
        csv="results/sensspec-results.csv",
    output:
        plot="figures/roc_curves.png",
    log:
        "log/plot_roc_curves.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_roc_curves.R"


rule write_graphviz:
    output:
        dot="figures/graphviz/{cmd}.dot",
    log:
        "log/graphviz/write_graphviz_{cmd}.txt",
    conda:
        "../envs/smk.yml"
    params:
        config_path=config_path,
    shell:
        """
        snakemake --{wildcards.cmd} --configfile {params.config_path} 2> {log} > {output.dot}
        """


rule dot_to_png:
    input:
        dot=rules.write_graphviz.output.dot,
    output:
        png="figures/graphviz/{cmd}.png",
    log:
        "log/graphviz/dot_to_png_{cmd}.txt",
    conda:
        "../envs/graphviz.yml"
    shell:
        """
        cat {input.dot} | dot -T png 2> {log} > {output.png}
        """


rule make_graph_figures:
    input:
        "figures/graphviz/dag.png",
        "figures/graphviz/rulegraph.png",
