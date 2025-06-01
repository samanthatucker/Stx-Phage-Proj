#!/bin/bash

# Create the destination directory if it doesn't exist
mkdir -p PROKKA_results

# Loop through matching directories
for dir in *_*-out; do
    # Only act on directories
    [ -d "$dir" ] || continue

    # Move the directory
    mv "$dir" PROKKA_results/
    echo "Moved: $dir → PROKKA_results/"
done

