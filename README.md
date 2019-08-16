# nanopore-sv-evaluation

This is the code repository for the paper "Evaluating nanopore sequencing data processing pipelines for structure variation identification".

- scripts/download.sh: code for downloading the online data

- scripts/simulation.sh: code for genreating simulation datasets

- scripts/workflow.sh: code for running the aligners and SV callers

- scripts/integration.sh: code for consensus call set generation

- scripts/comparison.md: code for make call set and true set comparisons

- scripts/coverage.sh: code for subsetting the reads and coverages analysis

- scripts/ML/random_forest.py: code for the random forest classifier training, predicting, and evaluating

- scripts/ML/gen_label.sh: code for generating labels for the random forest classifier

