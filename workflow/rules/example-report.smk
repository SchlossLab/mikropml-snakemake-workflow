
rule copy_example_figures:
    input:
        figs=[
            f"figures/{dataset}/performance.png",
            f"figures/{dataset}/feature_importance.png",
            f"figures/{dataset}/benchmarks.png",
            f"figures/{dataset}/roc_curves.png",
            expand(
                "figures/{dataset}/hp_performance_{method}.png",
                method=ml_methods,
                dataset=dataset,
            ),
        ],
    output:
        perf_plot="figures/example/performance.png",
        feat_plot="figures/example/feature_importance.png",
        bench_plot="figures/example/benchmarks.png",
        hp_plot=expand("figures/example/hp_performance_{method}.png", method=ml_methods),
        roc_plot="figures/example/roc_curves.png"
    log:
        "log/copy_example_figures.txt",
    params:
        outdir=lambda wildcards, output: os.path.split(output[0])[0],
    conda:
        "envs/smk.yml"
    shell:
        """
        for f in {input.figs}; do
            cp $f {params.outdir}
        done
        """

rule make_example_report:
    input:
        perf_plot=rules.copy_example_figures.output.perf_plot,
        feat_plot=rules.copy_example_figures.output.feat_plot,
        hp_plot=rules.copy_example_figures.output.hp_plot,
        bench_plot=rules.copy_example_figures.output.bench_plot,
        roc_plot=rules.copy_example_figures.output.roc_plot
    output:
        doc="report-example.md",
    log:
        "log/example/render_report.txt",
    params:
        dataset=dataset,
        nseeds=nseeds,
        ml_methods=ml_methods,
        ncores=ncores,
        kfold=kfold,
    conda:
        "envs/mikropml.yml"
    script:
        "scripts/report.Rmd"
