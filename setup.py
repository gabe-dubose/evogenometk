from setuptools import setup, find_packages
import os

setup(
    name='evogenometk',
    version='2025.09',
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'basic-wright-fisher=evogenometk.basic_wright_fisher_wrapper:main',
        ],
    },
    package_data={
        'evogenometk': ['../basic_wright_fisher.R'],
    },
)