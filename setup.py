from setuptools import setup
from glob import glob

setup(
    name='evogenometk',
    version='2025.09.03',
    description='Command-line tool kit for my evolutionary genomics class',
    author='Gabe DuBose',
    packages=[],
    py_modules=[],
    scripts=['basic-wright-fisher'],
    include_package_data=True,
)