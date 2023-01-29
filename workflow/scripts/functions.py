from collections.abc import Iterable
import itertools as it
import pandas as pd
import re
from snakemake.utils import Paramspace

def pattern_tame_wildcard(paramspace, wildcard):
    ''' Tame a wildcard in a pattern by doubling up curly braces on all other wildcards. This is useful for filling in values with expand().

    :param paramspace: a paramspace
    :type paramspace: class:`snakemake.utils.Paramspace` 
    :param wildcard: a wildcard in the paramspace
    :type wildcard: str

    :return: wildcard pattern from paramspace without the wildcard
    :rtype: str
    '''
    return re.sub(f"{{((?!{wildcard})[a-zA-Z_0-9]*)}}", "{{\\1}}", paramspace.wildcard_pattern)

def pattern_drop_wildcard(paramspace, wildcard):
    """ Remove a wildcard from the wildcard pattern

    :param paramspace: a paramspace
    :type paramspace: class:`snakemake.utils.Paramspace` 
    :param wildcard: a wildcard in the paramspace
    :type wildcard: str

    :return: wildcard pattern from paramspace without the wildcard
    :rtype: str
    """
    return re.sub(f"/{{0,1}}{wildcard}{paramspace.param_sep}{{{wildcard}}}", "", paramspace.wildcard_pattern).strip('/')

def instances_drop_wildcard(paramspace, wildcard):
    ''' Remove a wildcard from instance patterns
    
    :param paramspace: a paramspace
    :type paramspace: class:`snakemake.utils.Paramspace` 
    :param wildcard: a wildcard in the paramspace
    :type wildcard: str

    :return: set of instance patterns from paramspace without the wildcard
    :rtype: set
    '''
    return {re.sub(f"/{{0,1}}{wildcard}{paramspace.param_sep}[a-zA-Z_0-9]*", "", i).strip("/") for i in paramspace.instance_patterns}

def get_paramspace_from_config(config):
    ''' Prepare the parameter space based on the config dictionary

    :param config: configuration dictionary
    :type config: dict

    :return: parameter space
    :rtype: class:`snakemake.utils.Paramspace`
    '''
    # exclude certain config items from the Paramspace
    exclude_param_keys = config['exclude_param_keys'] if 'exclude_param_keys' in config and isinstance(config['exclude_param_keys'], Iterable) else list()
    for k in exclude_param_keys:
        config.pop(k, None)

    # get lists from config
    conf_lists = {k:v for k,v in config.items() if type(v) == list}
    # get a data frame with all-vs-all values in the lists.
    # this is analogous to `param.grid()` in R.
    params_df = pd.DataFrame(list(it.product(*[v for v in conf_lists.values()])), columns = conf_lists.keys())
    # add all non-list config items to the data frame.
    for k, v in config.items():
        if type(v) != list:
            params_df[k] = v
    # sort columns ascii-betically
    params_df = params_df[sorted(params_df.columns.tolist())]
    # build the paramspace with the data frame
    paramspace = Paramspace(params_df, param_sep = "-")
    return paramspace

def set_default(config, key, default):
    """ Get a value from config if the key exists,
    otherwise return the default value.

    :param config: configuration dictionary
    :type config: dict
    :param key: a key that may or may not be in the dictionary
    :type key: any hashable type
    :param default: the default value to return if the key is not in config
    :type default: any type
    :return: the value of the key if it's in config, otherwise the dfeault value
    """
    return config[key] if key in config else default