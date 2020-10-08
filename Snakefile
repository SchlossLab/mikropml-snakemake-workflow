configfile: 'config/config.yml'

ncores = config['ncores']
ml_methods = config['ml_methods']
start_seed = 100
seeds = range(start_seed, start_seed + config['nseeds'])

rule targets:
    input:
        'report.md'

rule preprocess_data:
    input:
        R="code/preproc.R",
        csv="data/raw/otu_large.csv"
    output:
        rds='data/processed/otu_large.Rds'
    log:
        "log/preprocess_data.txt"
    benchmark:
        "benchmarks/preprocess_data.txt"
    resources:
        ncores=ncores
    script:
        "code/preproc.R"

rule run_ml:
    input:
        R="code/ml.R",
        rds=rules.preprocess_data.output.rds
    output:
        model="results/runs/{method}_{seed}_model.Rds",
        perf=temp("results/runs/{method}_{seed}_performance.csv"),
        feat=temp("results/runs/{method}_{seed}_feature-importance.csv")
    log:
        "log/runs/run_ml.{method}_{seed}.txt"
    benchmark:
        "benchmarks/runs/run_ml.{method}_{seed}.txt"
    params:
        method="{method}",
        seed="{seed}"
    resources:
        ncores=ncores
    script:
        "code/ml.R"

rule bind_results:
    input:
        R="code/bind_results.R",
        csv=expand("results/runs/{method}_{seed}_{{type}}.csv", method = ml_methods, seed = seeds)
    output:
        csv='results/{type}_results.csv'
    log:
        "log/bind_results_{type}.txt"
    benchmark:
        "benchmarks/bind_results_{type}.txt"
    script:
        "code/bind_results.R"

rule plot_performance:
    input:
        R="code/plot_perf.R",
        csv='results/performance_results.csv'
    output:
        plot='figures/performance.png'
    log:
        "log/plot_performance.txt"
    script:
        "code/plot_perf.R"

rule plot_runtime:
    input:
        R='code/plot_runtime.R',
        tsv=expand(rules.run_ml.benchmark, method = ml_methods, seed = seeds)
    output:
        plot='figures/runtime.png',
        csv='results/runtime_results.csv'
    log:
        'log/plot_runtime.txt'
    script:
        'code/plot_runtime.R'

rule render_report:
    input:
        Rmd='report.Rmd',
        R='code/render.R',
        perf_plot=rules.plot_performance.output.plot,
        runtime_plot=rules.plot_runtime.output.plot
    output:
        doc='report.md'
    log:
        "log/render_report.txt"
    params:
        nseeds=config['nseeds'],
        ml_methods=ml_methods
    script:
        'code/render.R'
