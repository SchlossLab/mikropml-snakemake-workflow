import os
import sys

import subprocess as sp
from tempfile import TemporaryDirectory
import shutil
from pathlib import Path, PurePosixPath

sys.path.insert(0, os.path.dirname(__file__))

import common


def test_run_ml():

    with TemporaryDirectory() as tmpdir:
        workdir = Path(tmpdir) / "workdir"
        data_path = PurePosixPath(".tests/unit/run_ml/data")
        expected_path = PurePosixPath(".tests/unit/run_ml/expected")

        # Copy data to the temporary workdir.
        shutil.copytree(data_path, workdir)

        # dbg
        print("results/otu-mini-bin/runs/glmnet_100_model.Rds results/otu-mini-bin/runs/glmnet_100_performance.csv results/otu-mini-bin/runs/glmnet_100_test-data.csv", file=sys.stderr)

        # Run the test job.
        sp.check_output([
            "python",
            "-m",
            "snakemake", 
            "results/otu-mini-bin/runs/glmnet_100_model.Rds results/otu-mini-bin/runs/glmnet_100_performance.csv results/otu-mini-bin/runs/glmnet_100_test-data.csv",
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
