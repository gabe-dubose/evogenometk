from setuptools import setup
from pathlib import Path
import os

here = Path(__file__).parent.resolve()
r_script = here / "basic_wright_fisher.R"

setup(
    name='evogenometk',
    version='0.1.0',
    description='Command-line tool kit for my evolutionary genomics class',
    author='Gabe DuBose',
    packages=[],
    include_package_data=True,
    package_data={'': ['basic_wright_fisher.R']},
    entry_points={
        'console_scripts': [
            'basic-wright-fisher=basic_wright_fisher_wrapper:main',
        ],
    },
)
