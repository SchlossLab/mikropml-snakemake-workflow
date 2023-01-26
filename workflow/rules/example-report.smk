rule copy_example_figures:
    input:
        figs=[
            rules.plot_performance.output.plot,
            rules.plot_feature_importance.output.plot,
            expand(rules.plot_hp_performance.output.plot, 
                   ml_method=ml_methods),
            rules.plot_benchmarks.output.plot,
            rules.plot_roc_curves.output.plot,
            "figures/graphviz/rulegraph.png",
        ],
    output:
        perf_plot="figures/example/performance.png",
        feat_plot="figures/example/feature_importance.png",
        bench_plot="figures/example/benchmarks.png",
        hp_plot=expand("figures/example/hp_performance_{ml_method}.png",       
                        ml_method=ml_methods),
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
        done
        """


rule make_example_report:
    input:
        perf_plot=rules.copy_example_figures.output.perf_plot,
        feat_plot=rules.copy_example_figures.output.feat_plot,
        hp_plot=rules.copy_example_figures.output.hp_plot,
        bench_plot=rules.copy_example_figures.output.bench_plot,
        roc_plot=rules.copy_example_figures.output.roc_plot,
        rulegraph=rules.copy_example_figures.output.rulegraph,
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
