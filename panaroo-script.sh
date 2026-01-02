panaroo \
  -i gff_list.txt \
  -o panaroo_results \
  --clean-mode moderate \
  --remove-invalid-genes \
  -a core \
  --codons \
  --core_threshold 0.5 \
  --aligner mafft \
  -t 1

