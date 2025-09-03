# evogenometk
Tool kit for my evolutionary genomic class

## Installation
Within a conda environment, run:

```pip3 install git+https://github.com/gabe-dubose/evogenometk.git```

## Commands
### basic-wright-fisher

```
basic-wright-fisher -h

usage: basic-wright-fisher [-h] [-l LENGTH] [--mutation_rate MUTATION_RATE] [--mean_effect MEAN_EFFECT] [--stdev_effect STDEV_EFFECT]
                           [-N POPULATION_SIZE] [-g GENERATIONS] [-o OUTPUT]

Python wrapper for basic Wright-Fisher R script

options:
  -h, --help            show this help message and exit
  -l LENGTH, --length LENGTH
                        Sequence length
  --mutation_rate MUTATION_RATE
                        Mutation rate (substitutions/individual/generation)
  --mean_effect MEAN_EFFECT
                        Mean mutational effect
  --stdev_effect STDEV_EFFECT
                        Std dev of mutational effect
  -N POPULATION_SIZE, --population_size POPULATION_SIZE
                        Population size
  -g GENERATIONS, --generations GENERATIONS
                        Number of generations
  -o OUTPUT, --output OUTPUT
                        Output file

Example:
basic-wright-fisher --length 1000 --mutation_rate 1 --mean_effect 0 --stdev_effect 0.1 --population_size 1000 --generations 100 --output evolved_sequences.fasta

```
