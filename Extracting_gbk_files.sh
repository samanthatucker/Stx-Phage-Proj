#!/bin/bash

# Define file paths
txt_file="Table5_Stx_prophage.txt"
gbk_dir="."  # Top-level directory to search
output_dir="matched_gbk"

# Create output folder if it doesn't exist
mkdir -p "$output_dir"

# Extract seqid values from the first column (skip header)
awk 'NR > 1 {print $1}' "$txt_file" | tr -d '\r' | while read -r seqid; do
    # Use find to search recursively for .gbk files
    find "$gbk_dir" -type f -name "*.gbk" | while read -r gbk_file; do
        if grep -qw "$seqid" "$gbk_file"; then
            cp "$gbk_file" "$output_dir/"
            echo "Copied: $gbk_file (matched $seqid)"
            break
        fi
    done
done

echo "Done. Matching .gbk files copied to $output_dir"
