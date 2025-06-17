# Load required libraries
library(ape)
library(tidyverse)
library(ggtree)
library(ggtreeExtra)
library(ggnewscale)

# Set working directory
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree1_new")

# Load the tree
Tree1 <- read.tree("set.bionj.newick")

# Load prophage data
query.prophage <- read.csv("ids.csv", header = FALSE)
names(query.prophage) <- c("ID")

# Define groupings - here all IDs are assigned "Stx.prophage"
vec1 <- query.prophage$ID
group_assignments <- setNames(rep("Stx.prophage", length(vec1)), vec1)

# Create a data frame for tip groups with default "None"
tip_df <- data.frame(label = Tree1$tip.label,
                     group = group_assignments[Tree1$tip.label])
tip_df$group[is.na(tip_df$group)] <- "None"

# Build base tree (circular layout)
p <- ggtree(Tree1, layout = "circular") +
  geom_tree(size = 0.5) +
  theme_tree2() + 
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )+
  geom_treescale(fontsize = 4, linesize = 1, offset = 0.5, y = -1)

# Extract tree data for tip points
tree_data <- p$data
tree_data$group <- group_assignments[tree_data$label]
tree_data$group[is.na(tree_data$group)] <- "None"
# Add colored ring around tips using geom_fruit()
p <- p + 
  geom_fruit(
    data = tip_df,
    geom = geom_tile,
    mapping = aes(y = label, fill = group),
    width = 0.05,
    offset = 0.1
  ) +
  geom_tiplab(data = tree_data %>% filter(isTip),
              aes(label = label), size = 2, offset = 0.12) +
  scale_fill_manual(
    name = "Prophage Type",
    values = c("Stx.prophage" = "#3182BD", "None" = "#8E0152"),
    labels = c("Stx.prophage" = "Shiga toxin Prophage", "None" = "Representative Prophage")
  )

# Print the plot
print(p)
ggsave("Tree1.png", plot = last_plot(), width = 14, height =10)

#####Tree2
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/VipTree/Tree2_new")

# Load the tree
Tree2 <- read.tree("Tree2.newick")

# Load prophage data
query.prophage <- read.csv("ids.csv", header = FALSE)
names(query.prophage) <- c("ID")

# Define groupings - here all IDs are assigned "Stx.prophage"
vec1 <- query.prophage$ID
group_assignments <- setNames(rep("Stx.prophage", length(vec1)), vec1)

# Create a data frame for tip groups with default "None"
tip_df <- data.frame(label = Tree1$tip.label,
                     group = group_assignments[Tree1$tip.label])
tip_df$group[is.na(tip_df$group)] <- "None"

# Build base tree (circular layout)
p <- ggtree(Tree1, layout = "circular") +
  geom_tree(size = 0.5) +
  theme_tree2() + 
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )+
  geom_treescale(fontsize = 4, linesize = 1, offset = 0.5, y = -1)

# Extract tree data for tip points
tree_data <- p$data
tree_data$group <- group_assignments[tree_data$label]
tree_data$group[is.na(tree_data$group)] <- "None"
# Add colored ring around tips using geom_fruit()
p <- p + 
  geom_fruit(
    data = tip_df,
    geom = geom_tile,
    mapping = aes(y = label, fill = group),
    width = 0.05,
    offset = 0.1
  ) +
  geom_tiplab(data = tree_data %>% filter(isTip),
              aes(label = label), size = 2, offset = 0.12) +
  scale_fill_manual(
    name = "Prophage Type",
    values = c("Stx.prophage" = "#3182BD", "None" = "#8E0152"),
    labels = c("Stx.prophage" = "Shiga toxin Prophage", "None" = "Representative Prophage")
  )

# Print the plot
print(p)
ggsave("Tree1.png", plot = last_plot(), width = 14, height =10)
