configfile: 'config/config.yml'

ncores = config['ncores']
ml_methods = config['ml_methods']
kfold = config['kfold']

nseeds = config['nseeds']
start_seed = 100
seeds = range(start_seed, start_seed + nseeds)

rule targets:
    input:
        'report.md'

rule preprocess_data:
    input:
        R="code/preproc.R",
        csv="data/otu_large.csv"
    output:
        rds='data/dat_proc.Rds'
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
        seed="{seed}",
        kfold=kfold
    resources:
        ncores=ncores
    script:
        "code/ml.R"

rule combine_results:
    input:
        R="code/combine_results.R",
        csv=expand("results/runs/{method}_{seed}_{{type}}.csv", method = ml_methods, seed = seeds)
    output:
        csv='results/{type}_results.csv'
    log:
        "log/combine_results_{type}.txt"
    benchmark:
        "benchmarks/combine_results_{type}.txt"
    script:
        "code/combine_results.R"

rule combine_benchmarks:
    input:
        R='code/combine_benchmarks.R',
        tsv=expand(rules.run_ml.benchmark, method = ml_methods, seed = seeds)
    output:
        csv='results/benchmarks_results.csv'
    log:
        'log/combine_benchmarks.txt'
    script:
        'code/combine_benchmarks.R'

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

rule plot_benchmarks:
    input:
        R='code/plot_benchmarks.R',
        csv=rules.combine_benchmarks.output.csv
    output:
        plot='figures/benchmarks.png'
    log:
        'log/plot_benchmarks.txt'
    script:
        'code/plot_benchmarks.R'

rule render_report:
    input:
        Rmd='report.Rmd',
        R='code/render.R',
        perf_plot=rules.plot_performance.output.plot,
        bench_plot=rules.plot_benchmarks.output.plot
    output:
        doc='report.md'
    log:
        "log/render_report.txt"
    params:
        nseeds=nseeds,
        ml_methods=ml_methods,
        ncores=ncores,
        kfold=kfold
    script:
        'code/render.R'
