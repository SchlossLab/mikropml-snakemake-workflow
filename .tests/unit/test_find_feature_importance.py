import os
import sys

import subprocess as sp
from tempfile import TemporaryDirectory
import shutil
from pathlib import Path, PurePosixPath

sys.path.insert(0, os.path.dirname(__file__))

import common


def test_find_feature_importance():

    with TemporaryDirectory() as tmpdir:
        workdir = Path(tmpdir) / "workdir"
        data_path = PurePosixPath(".tests/unit/find_feature_importance/data")
        expected_path = PurePosixPath(".tests/unit/find_feature_importance/expected")

        # Copy data to the temporary workdir.
        shutil.copytree(data_path, workdir)

        # dbg
        print("results/otu-mini-bin/runs/glmnet_100_feature-importance.csv", file=sys.stderr)

        # Run the test job.
        sp.check_output([
            "python",
            "-m",
            "snakemake", 
            "results/otu-mini-bin/runs/glmnet_100_feature-importance.csv",
            "-f", 
            "-j1",
            "--keep-target-files",
            "--configfile",
            /Users/sovacool/projects/schloss-lab/mikropml-snakemake-workflow/config/test.yml
    
            "--use-conda",
            "--directory",
            workdir,
        ])

        # Check the output byte by byte using cmp.
        # To modify this behavior, you can inherit from common.OutputChecker in here
        # and overwrite the method `compare_files(generated_file, expected_file), 
        # also see common.py.
        common.OutputChecker(data_path, expected_path, workdir).check()
