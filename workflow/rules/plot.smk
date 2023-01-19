rule plot_performance:
    input:
        csv="results/{dataset}/performance_results.csv",
    output:
        plot=report(
            "figures/{dataset}/performance.png",
            category="Performance",
            subcategory="Model Performance",
        ),
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
            plot=report(
                "figures/{dataset}/feature_importance.png",
                category="Feature Importance",
            ),
        params:
            top_n=5,
        log:
            "log/{dataset}/plot_feature_importance.txt",
        conda:
            "../envs/mikropml.yml"
        script:
            "../scripts/plot_feature_importance.R"

else:

    rule make_blank_feature_plot:
        output:
            plot="figures/{dataset}/feature_importance.png"
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
        plot=report(
            "figures/{dataset}/hp_performance_{method}.png",
            category="Performance",
            subcategory="Hyperparameter Tuning",
        ),
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
        plot=report(
            "figures/{dataset}/benchmarks.png",
            category="Performance",
            subcategory="Runtime & Memory Usage",
            caption="../report/benchmarks.rst",
        ),
    log:
        "log/{dataset}/plot_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_benchmarks.R"


rule plot_roc_curves:
    input:
        csv="results/{dataset}/sensspec_results.csv"
    output:
        plot="figures/{dataset}/roc_curves.png",
    log:
        "log/{dataset}/plot_roc_curves.txt",
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
    shell:
        """
        snakemake --{wildcards.cmd} --configfile config/test.yml > {output.dot}
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
        cat {input.dot} | dot -T png > {output.png}
        """

rule make_graph_figures:
    input:
        "figures/graphviz/dag.png",
        "figures/graphviz/rulegraph.png",
