configfile: 'config/config.yml'

ncores = config['ncores']
ml_methods = config['ml_methods']
seeds = range(100, 100 + config['nseeds'] + 1)

rule targets:
    input:
        expand("results/{type}_results.csv",
                type = ['performance', 'feature-importance'])

rule preprocess_data:
    input:
        R="code/preproc.R",
        csv="data/raw/otu_medium.csv"
    output:
        rds='data/processed/otu_medium.Rds'
    log:
        "log/preprocess_data.txt"
    benchmark:
        "benchmarks/preprocess_data.txt"
    resources:
        ncores=ncores,
        pmem_gb=1
    script:
        "code/preproc.R"

rule run_ml:
    input:
        R="code/ml.R",
        rds=rules.preprocess_data.output.rds
    output:
        model="results/runs/{method}_{seed}_model.Rds",
        perf="results/runs/{method}_{seed}_performance.csv",
        feat="results/runs/{method}_{seed}_feature-importance.csv"
    log:
        "log/runs/run_ml.{method}_{seed}.txt"
    benchmark:
        "benchmarks/runs/run_ml.{method}_{seed}.txt"
    params:
        method="{method}",
        seed="{seed}"
    resources:
        ncores=ncores,
        pmem_gb=4
    script:
        "code/ml.R"

rule merge_results:
    input:
        R="code/merge_results.R",
        csv=expand("results/runs/{method}_{seed}_{{type}}.csv", method = ml_methods, seed = seeds)
    output:
        csv='results/{type}_results.csv'
    log:
        "log/merge_results_{type}.txt"
    benchmark:
        "benchmarks/merge_results_{type}.txt"
    resources:
        ncores=ncores,
        pmem_gb=1
    script:
        "code/merge_results.R"

rule plot_performance:
    input:
        R="code/plot_perf.R",
        csv='results/performance_results.csv'
    output:
        png='figures/performance.png'
    log:
        "log/plot_performance.txt"
    script:
        "code/plot_perf.R"

rule render_report:
    input:
        Rmd='docs/report.Rmd',
        R='code/render.R',
        plot=rules.plot_performance.output.png
    output:
        doc='docs/report.md'
    log:
        "log/render_report.txt"
    script:
        'code/render.R'
