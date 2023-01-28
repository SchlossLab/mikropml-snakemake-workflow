''' Prepare the parameter space based on the config dictionary
'''
# exclude certain config items from the Paramspace
exclude_param_keys = config['exclude_param_keys']
for k in exclude_param_keys:
    config.pop(k, None)

# add list of seeds to config
config['seed'] = list(seeds)

# get lists from config
conf_lists = {k:v for k,v in config.items() if type(v) == list}
# get a dataframe with all vs all values in the list.
# this is analogous to `param.grid()` in R.
params_df = pd.DataFrame(list(it.product(*[v for v in conf_lists.values()])), columns = conf_lists.keys())
# add all non-list config items to the dataframe of dot products
for k, v in config.items():
    if type(v) != list:
        params_df[k] = v
# sort columns ascii-betically
params_df = params_df[sorted(params_df.columns.tolist())]
# build the paramspace with the dataframe
paramspace = Paramspace(params_df, param_sep = "-")

# wildcard pattern without seed. needed for rule `combine_hp_performance`
wildcard_no_seed = pattern_drop_wildcard(paramspace, 'seed')
# wildcard pattern with all wildcards _except_ seed having double curly braces for use by `expand()` in rule `combine_hp_performance`
wildcard_tame_seed = pattern_tame_wildcard(paramspace, 'seed')