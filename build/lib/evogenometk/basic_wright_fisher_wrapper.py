#!/usr/bin/env python3
import subprocess
import sys
import argparse
import importlib.resources

def main():
    parser = argparse.ArgumentParser(description="Python wrapper for basic Wright-Fisher R script")
    parser.add_argument('-l', '--length', type=int, default=1000)
    parser.add_argument('--mutation_rate', type=float, default=1.0)
    parser.add_argument('--mean_effect', type=float, default=0.0)
    parser.add_argument('--stdev_effect', type=float, default=0.01)
    parser.add_argument('-N', '--population_size', type=int, default=1000)
    parser.add_argument('-g', '--generations', type=int, default=100)
    parser.add_argument('-o', '--output', type=str, default='evolved_sequences.fasta')
    args = parser.parse_args()

    # Locate R script inside installed package
    try:
        with importlib.resources.path('evogenometk', 'basic_wright_fisher.R') as r_script_path:
            cmd = [
                "Rscript",
                str(r_script_path),
                "-l", str(args.length),
                "--mutation_rate", str(args.mutation_rate),
                "--mean_effect", str(args.mean_effect),
                "--stdev_effect", str(args.stdev_effect),
                "-N", str(args.population_size),
                "-g", str(args.generations),
                "-o", args.output
            ]
            subprocess.run(cmd, check=True)
    except FileNotFoundError:
        print("Error: basic_wright_fisher.R not found in package.")
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print("Error running R script:", e)
        sys.exit(1)

if __name__ == "__main__":
    main()
