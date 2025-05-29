for file in hotspot_*.gff; do
    newname="${file#hotspot_}"
    mv "$file" "$newname"
done

