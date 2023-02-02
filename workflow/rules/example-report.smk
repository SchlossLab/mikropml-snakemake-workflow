""" Create an example report
"""

rule copy_hp_plot:
    input:
        plot=f"figures/{wildcard_no_seed}/hp_performance.png"
    output:
        plot=f"figures/example/{wildcard_no_seed}/hp_performance.png"
    log:
        f"log/{wildcard_no_seed}/copy_hp_plot.txt",
    conda:
        "../envs/smk.yml"
    shell:
        """
        cp {input.plot} {output.plot} &> {log}
        """

rule copy_example_figures:
    input:
        figs=[
            f"figures/dataset-{dataset}/performance.png",
            f"figures/dataset-{dataset}/feature_importance.png",
            f"figures/dataset-{dataset}/benchmarks.png",
            f"figures/dataset-{dataset}/roc_curves.png",
            "figures/graphviz/rulegraph.png",
        ],
    output:
        perf_plot="figures/example/performance.png",
        feat_plot="figures/example/feature_importance.png",
        bench_plot="figures/example/benchmarks.png",
        roc_plot="figures/example/roc_curves.png",
        rulegraph="figures/example/rulegraph.png",
    log:
        "log/copy_example_figures.txt",
    params:
        outdir=lambda wildcards, output: os.path.split(output[0])[0],
    conda:
        "../envs/smk.yml"
    shell:
        """
        for f in {input.figs}; do
            cp $f {params.outdir}
        done &> {log}
        """


rule make_example_report:
    input:
        perf_plot=rules.copy_example_figures.output.perf_plot,
        feat_plot=rules.copy_example_figures.output.feat_plot,
        bench_plot=rules.copy_example_figures.output.bench_plot,
        roc_plot=rules.copy_example_figures.output.roc_plot,
        rulegraph=rules.copy_example_figures.output.rulegraph,
        hp_plot=expand("figures/example/{params}/hp_performance.png",
                        params = instances_drop_wildcard(paramspace, "seed"))
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
        find_feature_importance=find_feature_importance,
        config_path=config_path,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/report.Rmd"
