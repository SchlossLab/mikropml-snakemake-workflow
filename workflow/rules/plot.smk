rule plot_performance:
    input:
        R="workflow/scripts/plot_performance.R",
        csv="results/performance-results.csv",
    output:
        plot="figures/performance.png",
    log:
        "log/plot_performance.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_performance.R"


if find_feature_importance:

    rule plot_feature_importance:
        input:
            R="workflow/scripts/plot_feature_importance.R",
            csv="results/feature_importance-results.csv",
        output:
            plot="figures/feature_importance.png",
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
        R="workflow/scripts/plot_hp_perf.R",
        rds="results/hp_performance_results_{method}.Rds",
    output:
        plot="figures/hp_performance_{method}.png",
    log:
        "log/plot_hp_perf_{method}.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_hp_perf.R"


rule plot_benchmarks:
    input:
        R="workflow/scripts/plot_benchmarks.R",
        csv="results/benchmarks-results.csv",
    output:
        plot="figures/benchmarks.png",
    log:
        "log/plot_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/plot_benchmarks.R"

rule write_graphviz:
    output:
        txt='figures/graphviz_{cmd}.dot'
    conda: '../envs/smk.yml'
    shell:
        '''
        snakemake --{wildcards.cmd} --configfile config/test.yml > {output.txt}
        '''    

rule dot_to_png:
    input:
        txt='figures/graphviz_{cmd}.dot'
    output:
        png='figures/graphviz_{cmd}.png'
    conda: '../envs/smk.yml'
    shell:
        '''
        cat {input.txt} | dot -T png > {output.png}
        '''

rule make_graph_figures:
    input:
        'figures/graphviz_dag.png', 'figures/graphviz_rulegraph.png'

