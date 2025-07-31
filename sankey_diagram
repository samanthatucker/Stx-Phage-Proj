library(dplyr)
library(networkD3)
library(RColorBrewer)
library(readr)
library(htmlwidgets)

# Set working directory
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/Stx_discovery/clean_fasta/all_gffs/selected_gffs/lovis4u_2025_06_06-11_06")

# Load your data (adjust path and filename as needed)
data <- read_tsv("2feature_annotation_table.tsv", show_col_types = FALSE)

# Filter out 'hypothetical protein' and count occurrences per name-id pair
filtered_data <- data %>%
  filter(name != "hypothetical protein") %>%
  count(name, id, name = "value")

# Get top 40 names by total counts
top_names <- filtered_data %>%
  group_by(name) %>%
  summarise(total = sum(value)) %>%
  arrange(desc(total)) %>%
  slice_head(n = 40) %>%
  pull(name)

# Filter for top names and keep up to 3 top ids per name
filtered_data <- filtered_data %>%
  filter(name %in% top_names) %>%
  group_by(name) %>%
  slice_max(order_by = value, n = 3, with_ties = FALSE) %>%
  ungroup()

# Create nodes: unique ids first, then names
nodes <- data.frame(
  name = c(unique(filtered_data$id), unique(filtered_data$name))
)
nodes$id <- seq_len(nrow(nodes)) - 1  # zero-indexing for networkD3

# Create links, map source = id, target = name
links <- filtered_data %>%
  mutate(
    source = match(id, nodes$name) - 1,
    target = match(name, nodes$name) - 1
  ) %>%
  select(source, target, value, id)

# Prepare colors for sources (IDs) using RColorBrewer Set3 palette
unique_ids <- unique(links$id)
n_colors <- length(unique_ids)

# Get palette (max 12 colors in Set3)
palette_colors <- brewer.pal(min(max(n_colors, 3), 12), "Set3")

# Repeat colors if needed
if (n_colors > length(palette_colors)) {
  palette_colors <- rep(palette_colors, length.out = n_colors)
}

# Name colors by source IDs
names(palette_colors) <- unique_ids

# Assign colors to links based on source id
links <- links %>%
  mutate(colour = palette_colors[id])

# Create JS color scale for LinkGroup argument
unique_colors <- unique(links$colour)
colourScale <- paste0(
  'd3.scaleOrdinal() .domain([',
  paste0('"', unique_colors, '"', collapse = ','),
  ']) .range([',
  paste0('"', unique_colors, '"', collapse = ','),
  '])'
)

# Plot Sankey diagram with colored links by source id
p <- sankeyNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  Value = "value",
  NodeID = "name",
  LinkGroup = "colour",     # column that defines link colors
  colourScale = colourScale, 
  fontSize = 10,
  nodeWidth = 40,
  sinksRight = FALSE
)

# Save as HTML
saveWidget(p, "sankey_diagram.html", selfcontained = TRUE)
