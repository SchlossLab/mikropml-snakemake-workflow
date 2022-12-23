Machine learning algorithms used were: {{ snakemake.config['ml_methods'] }}.
Models were trained with {{ snakemake.config['nseeds'] }} 
different random partitions of the 
{{ snakemake.config['dataset_name'] }} dataset 
into training and testing sets using 
{{ snakemake.config['kfold'] }}-fold cross validation.
