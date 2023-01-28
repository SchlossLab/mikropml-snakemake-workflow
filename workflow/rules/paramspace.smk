
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Prepare Parameter Space
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
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

print("Wildcard pattern:", paramspace.wildcard_pattern)

wildcard_tame_seed = re.sub("{((?!seed)[a-zA-Z_0-9]*)}", "{{\\1}}", paramspace.wildcard_pattern)
wildcard_no_seed = re.sub("/seed-{seed}", "", paramspace.wildcard_pattern)
instances_no_seed = [re.sub("/seed-[a-zA-Z_0-9]*", "", i) for i in paramspace.instance_patterns]

print('tame seed', wildcard_tame_seed)
print('no seed', wildcard_no_seed)
print('instances no seed', instances_no_seed)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
