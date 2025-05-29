awk -F'\t' '{ n = $0; sub(/.*[[:space:]]/, "", n); sub(/\/1000$/, "", n); print n "\t" $0 }' msh_output.csv | sort -nr | head -n 15000 | cut -f2- > msh_ordered_15000.csv
