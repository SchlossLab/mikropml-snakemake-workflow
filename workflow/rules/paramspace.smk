''' Prepare the parameter space based on the config dictionary
'''
exclude_param_keys = config['exclude_param_keys']
for k in exclude_param_keys:
    config.pop(k, None)
config['seed'] = list(seeds)
conf_lists = {k:v for k,v in config.items() if type(v) == list}
params_df = pd.DataFrame(list(it.product(*[v for v in conf_lists.values()])), columns = conf_lists.keys())
for k in conf_lists.keys():
    config.pop(k)
for k, v in config.items():
    params_df[k] = v

params_df = params_df[sorted(params_df.columns.tolist())]
paramspace = Paramspace(params_df, param_sep = "-")

wildcard_no_seed = pattern_drop_wildcard(paramspace, 'seed')
wildcard_tame_seed = pattern_tame_wildcard(paramspace, 'seed')