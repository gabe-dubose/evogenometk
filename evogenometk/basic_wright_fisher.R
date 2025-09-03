#!/usr/bin/env Rscript

# Load argparse
if (!requireNamespace("argparse", quietly = TRUE)) {
  install.packages("argparse", repos = "https://cloud.r-project.org")
}

library(argparse)

# -------------------------------
# Functions
# -------------------------------

# Function to generate a nucleotide sequence
generate.sequence <- function(length, nucleotides=c('A', 'T', 'G', 'C'), start.codon = TRUE, stop.codon = TRUE){
  sequence <- sample(nucleotides, length, replace=TRUE)
  # assign start codon if specified
  if (start.codon == TRUE) {
    sequence[1:3] <- c("A", "T", "G")
  }
  # assign stop codon if specified
  if (stop.codon == TRUE) {
    sequence[(length(sequence)-2):length(sequence)] <- c("T", "A", "G")
  }
  
  return(sequence)
}

# Function to mutate nucleotide sequence
mutate <- function(sequence, mutation.rate, mean.mutation.effect, stdev.mutation.effect){
  # get number of mutations
  n.mut <- rpois(1, lambda = mutation.rate)
  # initialize default null mutational effect vector
  mutation.effects <- rep(0, length(sequence))
  
  # if mutation is to be issued, do so
  if (n.mut > 0){
    # get position(s)
    positions <- sample(seq_along(sequence), n.mut, replace = FALSE)
    # iterate through positions
    for (position in positions) {
      # get current nucleotide
      current <- sequence[position]
      nucleotides <- c("A","T","G","C")
      # sample new nucleotide and update
      new.nucleotide <- sample(nucleotides[nucleotides != current], 1)
      sequence[position] <- new.nucleotide
      # assign mutational effect
      mutation.effects[position] <- rnorm(1, mean = mean.mutation.effect, sd = stdev.mutation.effect)
    }
  }
  return(list(sequence = sequence, effects = mutation.effects))
}

# Function to evolve nucelotide sequence using basic Wright-Fisher simulation
sim.wright.fisher <- function(sequence, mutation.rate, mean.mutation.effect,
                              stdev.mutation.effect, population.size, generations) {
  
  # Step 1: initialize data structures
  genotypes <- matrix(rep(sequence, population.size), nrow = population.size, byrow = TRUE)
  seq.length <- length(sequence)
  fitness.effects <- matrix(0, nrow = population.size, ncol = seq.length)
  
  # Step 2: start evolutionary loop
  for (g in 1:generations){
    
    # Step 3: mutation (vectorized over individuals)
    muts <- lapply(1:population.size, function(i) {
      mutate(genotypes[i, ], mutation.rate, mean.mutation.effect, stdev.mutation.effect)
    })
    
    # update genotypes and accumulate fitness effects
    genotypes <- do.call(rbind, lapply(muts, `[[`, "sequence"))
    fitness.effects <- fitness.effects + do.call(rbind, lapply(muts, `[[`, "effects"))
    
    # Step 4: selection
    # multiplicative fitness
    fitness <- apply(fitness.effects, 1, function(x) prod(1 + x))
    relative.fitness <- fitness / sum(fitness)
    
    parents <- sample(seq_len(population.size), size = population.size,
                      replace = TRUE, prob = relative.fitness)
    
    # offspring inherit parental genotypes & cumulative fitness effects
    genotypes <- genotypes[parents, , drop = FALSE]
    fitness.effects <- fitness.effects[parents, , drop = FALSE]
  }
  
  return(genotypes)
}

write.fasta <- function(matrix, file) {
  n.ind <- nrow(matrix)
  con <- file(file, open = "w")
  for (i in 1:n.ind) {
    seq.name <- paste0(">individual_", i)
    seq.string <- paste(matrix[i, ], collapse = "")
    writeLines(c(seq.name, seq.string), con)
  }
  close(con)
}

# -------------------------------
# Command-line interface
# -------------------------------

parser <- ArgumentParser(description='Simulate nucleotide sequence evolution using Wright-Fisher model')
parser$add_argument('-l', '--length', type='integer', default=1000, help='Sequence length')
parser$add_argument('--mutation_rate', type='double', default=1, help='Mutation rate (substitutions/individual/generation)')
parser$add_argument('--mean_effect', type='double', default=0, help='Mean mutational effect')
parser$add_argument('--stdev_effect', type='double', default=0.01, help='Std dev of mutational effect')
parser$add_argument('-N', '--population_size', type='integer', default=1000, help='Population size')
parser$add_argument('-g', '--generations', type='integer', default=100, help='Number of generations')
parser$add_argument('-o', '--output', type='character', default='evolved_sequences.fasta', help='Output file')

# parse arguments
args <- parser$parse_args()

# run simulations
sequence <- generate.sequence(args$length)
evolved <- sim.wright.fisher(sequence, args$mutation_rate, args$mean_effect,
                             args$stdev_effect, args$population_size, args$generations)

# write to file
write.fasta(evolved, args$output)
