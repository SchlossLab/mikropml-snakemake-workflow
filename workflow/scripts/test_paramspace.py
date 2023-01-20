from itertools import product
import pandas as pd
from snakemake.utils import Paramspace
import yaml

with open('config/robust.yml', 'r') as infile:
    config = yaml.load(infile, Loader=yaml.Loader)

ignore_keys = ['dataset_csv', 'outcome_colname', 'hyperparams', 'find_feature_importance', 'ncores', 'nseeds']
for k in ignore_keys:
    config.pop(k, None)

config['seed'] = list(range(100, 102))
conf_lists = {k:v for k,v in config.items() if type(v) == list}
params_df = pd.DataFrame(list(product(*[v for v in conf_lists.values()])), columns = conf_lists.keys())
for k in conf_lists.keys():
    config.pop(k)
for k, v in config.items():
    params_df[k] = v

paramspace = Paramspace(params_df, param_sep = "_")
print('paramspace.wildcard_pattern:\t', paramspace.wildcard_pattern)
print('paramspace.instance_patterns:\t', [i for i in paramspace.instance_patterns])