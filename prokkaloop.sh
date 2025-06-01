for file in *.fasta; do

  [ -e "$file" ] || continue  # Skip if no .fasta files found

  awk '/^>/ {print substr($0, 1, 20); next} {print}' "$file" > "clean_fasta/$file"

  echo "Processed $file -> clean_fasta/$file"

done

ls *.fasta | parallel -verbose "prokka {} --prefix {.}-out"
