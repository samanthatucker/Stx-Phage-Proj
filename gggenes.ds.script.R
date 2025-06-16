# Load libraries
library(gggenes)
library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(tidyr)

# Read the single PADLOC file
setwd("/Users/samanthatucker/Documents/compiled_files")
padloc <- read.csv("for_gggenes.csv", stringsAsFactors = FALSE)
orientation = ifelse(padloc$strand == "+", TRUE, ifelse(padloc$strand == "-", FALSE, NA))

# Clean and prepare the dataset
GenesDF <- padloc %>%
  filter(!is.na(target.name)) %>%  # remove CRISPR rows without gene IDs
  transmute(
    Protein_ID = target.name,
    gene = protein.name,
    start = start,
    end = end,
    orientation = ifelse(strand == "+", TRUE, ifelse(strand == "-", FALSE, NA)),
    gene_type = system,
    molecule = seqid,
    system = system
  )


# Replace any missing gene names with Protein_ID
GenesDF$gene[GenesDF$gene == "" | is.na(GenesDF$gene)] <- GenesDF$Protein_ID

# Define a manual color palette (you can customize this)
manualcolors <- c(
  "#8E0152", "#C51B7D", "#DE77AE", "#F1B6DA", "#FDE0EF","#9ECAE1","#6BAED6",
  "#F7F7F7", "#3182BD", "#08519C","#08306B",
  "#E6F5D0", "#B8E186", "#7FBC41", "#4D9221", "#276419"
)

# Check if color palette is large enough
if (length(unique(GenesDF$system)) > length(manualcolors)) {
  stop("Not enough colors in 'manualcolors' for the number of unique systems.")
}

# Plot the gene map
g <- ggplot(GenesDF, aes(xmin = start, xmax = end, y = molecule, fill = system, forward = orientation)) +
  geom_gene_arrow(arrowhead_height = unit(4, "mm"), arrowhead_width = unit(4, "mm")) +
  facet_wrap(~ molecule, scales = "free", ncol = 1) +
  scale_fill_manual(values = manualcolors)+
  theme_genes() +
  theme(axis.title.y = element_blank(),
        axis.ticks.x = element_blank(),
        legend.direction = "vertical",
        legend.position = "right",
        panel.grid.major.y = element_blank()) +
  theme(axis.text.y = element_blank())+
  labs(fill = "Defense System")

# Adjust height based on number of regions
plot_height <- length(unique(GenesDF$molecule)) * 1.5
g
# Save plot
ggsave("protective_ds_figure.pdf", plot = g, width = 25, height = plot_height, units = "cm", limitsize = FALSE)

padlo2 <- read.csv("GCF_003146255.1_padloc.csv", stringsAsFactors = FALSE)
orientation = ifelse(padlo2$strand == "+", TRUE, ifelse(padlo2$strand == "-", FALSE, NA))

# Clean and prepare the dataset
GenesDF <- padlo2 %>%
  filter(!is.na(target.name)) %>%  # remove CRISPR rows without gene IDs
  transmute(
    Protein_ID = target.name,
    gene = protein.name,
    start = start,
    end = end,
    orientation = ifelse(strand == "+", TRUE, ifelse(strand == "-", FALSE, NA)),
    gene_type = system,
    molecule = seqid,
    system = system
  )


# Replace any missing gene names with Protein_ID
GenesDF$gene[GenesDF$gene == "" | is.na(GenesDF$gene)] <- GenesDF$Protein_ID

# Define a manual color palette (you can customize this)
manualcolors <- c('black','forestgreen', 'red2', 'orange', 'cornflowerblue', 
                  'magenta', 'darkolivegreen4', 'indianred1', 'tan4', 'darkblue', 
                  'mediumorchid1','firebrick2',  'yellowgreen', 'lightsalmon','chartreuse', 'tan3',
                  "tan1",'purple', 'wheat4', '#DDAD4B', 
                  'seagreen1', 'moccasin', 'mediumvioletred', 'seagreen','cadetblue1',
                  "darkolivegreen1" ,"tan2" ,   "tomato3" , "#7CE3D8","white","#FFF7BC","#8C6BB1","cyan","#CB181D","yellow",
                  "limegreen","#F16913","#762A83","tan1","blue","firebrick1","firebrick4","pink","pink3")

# Check if color palette is large enough
if (length(unique(GenesDF$system)) > length(manualcolors)) {
  stop("Not enough colors in 'manualcolors' for the number of unique systems.")
}

# Plot the gene map
g <- ggplot(GenesDF, aes(xmin = start, xmax = end, y = molecule, fill = system, forward = orientation)) +
  geom_gene_arrow(arrowhead_height = unit(4, "mm"), arrowhead_width = unit(4, "mm")) +
  facet_wrap(~ molecule, scales = "free", ncol = 1) +
  scale_fill_manual(values = manualcolors) +
  theme_genes() +
  theme(axis.title.y = element_blank(),
        axis.ticks.x = element_blank(),
        legend.direction = "vertical",
        legend.position = "right",
        panel.grid.major.y = element_blank()) +
  scale_y_discrete(expand = expansion(mult = c(1, 6)))

# Adjust height based on number of regions
plot_height <- length(unique(GenesDF$molecule)) * 1.5
g
# Save plot
ggsave("practice_single_file.pdf", plot = g, width = 25, height = plot_height, units = "cm", limitsize = FALSE)

