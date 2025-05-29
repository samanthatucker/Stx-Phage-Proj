#!/bin/bash

# Enable strict mode
set -euo pipefail

# Loop through all files starting with 'hotspot'
for file in *.fasta; do
  # Check if it's a regular file
  if [[ -f "$file" ]]; then
    echo "Processing $file..."
    stxtyper -n "$file" --output "${file%.fasta}.stxtyper.csv"
  fi
done

#The above script classifies the Stx protein class and subclass using ncbi-stxtyper
