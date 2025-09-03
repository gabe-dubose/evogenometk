#!/usr/bin/env python3
import subprocess
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description="Python wrapper for basic Wright-Fisher R script")
    parser.add_argument('-l', '--length', type=int, default=1000, help='Sequence length')
    parser.add_argument('--mutation_rate', type=float, default=1.0, help='Mutation rate (substitutions/individual/generation)')
    parser.add_argument('--mean_effect', type=float, default=0.0, help='Mean mutational effect')
    parser.add_argument('--stdev_effect', type=float, default=0.01, help='Std dev of mutational effect')
    parser.add_argument('-N', '--population_size', type=int, default=1000, help='Population size')
    parser.add_argument('-g', '--generations', type=int, default=100, help='Number of generations')
    parser.add_argument('-o', '--output', type=str, default='evolved_sequences.fasta', help='Output file')

    args = parser.parse_args()

    # Build Rscript command
    cmd = [
        "Rscript",
        "basic_wright_fisher.R",
        "-l", str(args.length),
        "--mutation_rate", str(args.mutation_rate),
        "--mean_effect", str(args.mean_effect),
        "--stdev_effect", str(args.stdev_effect),
        "-N", str(args.population_size),
        "-g", str(args.generations),
        "-o", args.output
    ]

    # Execute Rscript
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print("Error running R script:", e)
        sys.exit(1)

if __name__ == "__main__":
    main()