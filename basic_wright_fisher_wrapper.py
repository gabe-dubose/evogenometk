#!/usr/bin/env python3
import subprocess
import pkg_resources
import sys

def main():
    # locate the R script inside site-packages
    r_script = pkg_resources.resource_filename(__name__, "basic_wright_fisher.R")
    subprocess.run(["Rscript", r_script] + sys.argv[1:])