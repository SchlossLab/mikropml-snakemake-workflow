
rule combine_results:
    input:
        R="workflow/scripts/combine_results.R",
        logR='workflow/scripts/log_smk.R',
        csv=expand("results/runs/{method}_{seed}_{{type}}.csv", method = ml_methods, seed = seeds)
    output:
        csv='results/{type}_results.csv'
    log:
        "log/combine_results_{type}.txt"
    benchmark:
        "benchmarks/combine_results_{type}.txt"
    conda: '../envs/Rtidy.yml'
    script:
        "../scripts/combine_results.R"

rule combine_hp_performance:
    input:
        R='workflow/scripts/combine_hp_perf.R',
        logR='workflow/scripts/log_smk.R',
        rds=expand('results/runs/{{method}}_{seed}_model.Rds', seed=seeds)
    output:
        rds='results/hp_performance_results_{method}.Rds'
    log:
        "log/combine_hp_perf_{method}.txt"
    benchmark:
        "benchmarks/combine_hp_perf_{method}.txt"
    resources:
        mem_mb = MEM_PER_GB * 16
    conda: '../envs/Rtidy.yml'
    script:
        "../scripts/combine_hp_perf.R"

rule combine_benchmarks:
    input:
        R='workflow/scripts/combine_benchmarks.R',
        logR='workflow/scripts/log_smk.R',
        tsv=expand(rules.run_ml.benchmark, method = ml_methods, seed = seeds)
    output:
        csv='results/benchmarks_results.csv'
    log:
        'log/combine_benchmarks.txt'
    conda: '../envs/Rtidy.yml'
    script:
        '..scripts/combine_benchmarks.R'
