#!/bin/bash

input="genome-list"

while read -r accession; do
    echo "Downloading $accession..."
    
    datasets download genome accession "$accession" --include genome --filename "${accession}.zip"
    
    unzip -o "${accession}.zip" -d "${accession}" && rm "${accession}.zip"
    
    echo "Done with $accession. Waiting a bit before next..."
    sleep 5  # adjust if NCBI still kicks you out
done < "$input"

