ML Results
================
2020-10-02

    library(here)
    library(knitr)

Models were trained using rf, regLogistic with 2 different random
partitions of the data into training and testing sets.

Model Performance
-----------------

    include_graphics(here(snakemake@input[['plot']]))

![](/home/sovacool/smk-mikRopML-workflow/figures/performance.png)<!-- -->
