generate_tree_plot <- function(tree_file, family_file, output_pdf) {
  library(ape)
  library(tidyverse)
  library(ggtree)
  library(ggtreeExtra)
  library(ggnewscale)
  library(RColorBrewer)
  library(scales)
  
  # Fix for trees with negative edge lengths
  options(ignore.negative.edge = TRUE)
  
  # Load the phylogenetic tree
  tree <- read.tree(tree_file)
  
  # Load prophage data
  query.prophage <- read.csv("rep.ids.csv", header = FALSE)
  colnames(query.prophage) <- "ID"
  group_assignments <- setNames(rep("rep.prophage", nrow(query.prophage)), query.prophage$ID)
  
  # Create tip group assignment
  tip_df <- data.frame(label = tree$tip.label,
                       group = group_assignments[tree$tip.label])
  tip_df$group[is.na(tip_df$group)] <- "None"
  
  # Load family/phylogroup data
  family_data <- read.csv(family_file, header = TRUE)
  family_data <- family_data[, c(-2, -3, -6)]
  colnames(family_data) <- c("ID", "Family", "STX", "Phylogroup")
  family_data$Family[family_data$Family == "not found"] <- "Not found"
  family_data$STX[family_data$STX == "not found"] <- "FALSE"
  
  family_df <- data.frame(label = tree$tip.label) %>%
    left_join(family_data, by = c("label" = "ID")) %>%
    mutate(
      Family = ifelse(is.na(Family), "Not Assigned", Family),
      Phylogroup = ifelse(is.na(Phylogroup), "Not Assigned", Phylogroup),
      STX = ifelse(is.na(STX), "Not Assigned", STX)
    )
  
  # Start plotting
  p <- ggtree(tree, layout = "circular") +
    geom_tree(size = 0.5) +
    geom_treescale(x = 1.3, y = 0, width = 0.1, fontsize = 4, linesize = 1) +
    annotate("text", x = 1.3, y = -15, label = "0.1", size = 3)+
    theme_tree2() +
    theme(panel.grid = element_blank(), axis.text = element_blank(), axis.ticks = element_blank())
  
  ring_width <- 0.05
  
  # ---- Prophage ring ----
  p <- p +
    geom_fruit(data = tip_df, geom = geom_tile,
               mapping = aes(y = label, fill = group),
               width = ring_width, offset = 0.06,
               color = "black", size = 0.2) +
    scale_fill_manual(name = "Prophage Type",
                      values = c("rep.prophage" = "#3182BD", "None" = "#8E0152"),
                      labels = c("rep.prophage" = "Representative Prophage", "None" = "Shiga Prophage")) +
    ggnewscale::new_scale_fill()
  
  # ---- Family ring ----
  
  all_families <- c(
    "Not found", "Pankowvirus", "Marienburgvirus", "Nesevirus", "Lambdavirus",
    "Hendrixvirinae", "Sepvirinae", "Oslovirus", "Glaedevirus", "Sawaravirus",
    "Jouyvirus", "Ravinvirus", "Alegriavirus", "Bievrevirus", "Radostvirus",
    "Gokushovirinae", "Tubulavirales", "Fiersviridae", "Bullavirinae",
    "Cleopatravirinae", "Grimontviridae", "Gordonclarkvirinae", "Slopekvirinae",
    "Autographiviridae", "Vequintavirinae", "Stephanstirmvirinae", "Ounavirinae",
    "Markadamsvirinae", "Tevenvirinae", "Straboviridae", "Aglimvirinae",
    "Asteriusvirus", "Seoulvirus", "Goslarvirus", "Schitoviridae", "Queuovirinae",
    "Halfdanvirus", "Rosemountvirus", "Xuquatrovirus", "Wifcevirus", "Dhillonvirus",
    "Drexlerviridae", "Guernseyvirinae", "Lederbergvirus", "Skarprettervirus",
    "Sortsnevirus", "Unverified", "Casjensviridae", "Punavirus", "Peduoviridae",
    "Liscvirinae", "Muvirus"
  )
  
  family_colors <- c("#fff7fb", "#fccde5", "#fa9fb5", "#f768a1", "#c51b8a", "#DE77AE", "#F1B6DA", "#FDE0EF", "#8E0152",
                     "#f2f0f7", "#cbc9e2", "#9e9ac8", "#756bb1", "#54278f", "#8c86be", "#8c68af", "#8948a0", "#84258b", "#730b6e",
                     "#3277ff", "#32b3ff", "#32efff", "#326aff", "#9ECAE1", "#6BAED6", "#3182BD", "#08519C", "#08306B", "#e6f0f7",
                     "#d1e1ee", "#bacfe4", "#a1bedb", "#92a4cd", "#E6F5D0", "#B8E186", "#7FBC41", "#4D9221", "#276419", "#eaf7fa",
                     "#daf1f1", "#c4e9e1", "#9ddacb", "#78cab1", "#59bb93", "#32ffa1", "#32ff64", "#3ef232", "#82c932", "#3fab72",
                     "#28914d", "#107a37", "#006227", "#feecd2", "#fedfb5", "#fdd09a", "#fdbd86", "#fc9e69", "#f77f53", "#ed6145",
                     "#db3926", "#c3150e", "#a50000", "#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#FFFFFF", "#E0E0E0",
                     "#BABABA", "#878787", "#4D4D4D", "#1A1A1A", "#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE090", "#FFFFBF",
                     "#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695", "#D9F0A3", "#A6D96A", "#66BD63", "#1A9850", "#006837",
                     "#9E0142", "#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD",
                     "#5E4FA2")
named_family_colors <- setNames(family_colors[1:length(all_families)], all_families)
  
  p <- p +
    geom_fruit(data = family_df, geom = geom_tile,
               mapping = aes(y = label, fill = Family),
               width = ring_width, offset = 0.12,
               color = "black", size = 0.2) +
    scale_fill_manual(name = "Phage Family", values = named_family_colors, na.value = "grey") +
    ggnewscale::new_scale_fill()
  
  # ---- Phylogroup ring ----
  phylo_levels <- na.omit(unique(family_df$Phylogroup))
  all_phylogroups <- c(
    "A", "E1", "G", "B2-2", "F", "D1", "D2", "B1", "C", "E",
    "B2-1", "D3", "Shig1", "Not found", "E2", "Host Unknown"
  )
  
phylo_colors <- c("#67001f","#980043","#ce1256","#e7298a",
                  "#df65b0","#c994c7","#e7e1ef","#49006a","#ae017e", 
                  "#f768a1","#fa9fb5","#fcc5c0","#fde0dd","#ece2f0",
                  "#fee6ce","#fdbb84")

named_phylo_colors <- setNames(phylo_colors[1:length(all_phylogroups)], all_phylogroups)
  p <- p +
    geom_fruit(data = family_df, geom = geom_tile,
               mapping = aes(y = label, fill = Phylogroup),
               width = ring_width, offset = 0.18,
               color = "black", size = 0.2) +
    scale_fill_manual(name = "Bacterial Phylogroup", values = named_phylo_colors, na.value = "grey") +
    ggnewscale::new_scale_fill()
  
  # ---- STX ring ----
  # Toxin ring
  STX_levels <- unique(family_df$STX)
  STX_colors <- setNames(
    c("#C0C0C0", "#202020", "#FFFFFF")[1:length(STX_levels)],
    STX_levels
  )
  
  p <- p +
    geom_fruit(data = family_df, geom = geom_tile,
               mapping = aes(y = label, fill = STX),
               width = ring_width, offset = 0.24,
               color = "black", size = 0.2) +
    scale_fill_manual(name = "Toxin presence-absence", values = STX_colors, na.value = "#FFFFFF")
  
  # ---- Add tip labels ----
  tree_data <- p$data
  tree_data$group <- group_assignments[tree_data$label]
  tree_data$group[is.na(tree_data$group)] <- "None"
  
  max_x <- max(tree_data$x, na.rm = TRUE)
offset_value <- max_x * 0.7
  
p <- p + geom_tiplab(data = tree_data %>% filter(isTip),
                       aes(label = label), size = 2, offset = offset_value, align = TRUE, linesize = 0.1)
  
  # Save and display
  print(p)
  ggsave(output_pdf, plot = p, dpi = 600, width = 20, height = 20)
}

# Create file lists
tree_files <- paste0("Tree", 1:17, ".newick")
family_files <- paste0("Tree", 1:17, "_with_family_best_match.csv")
output_files <- paste0("Tree", 1:17, ".new.pdf")

# Loop through and generate plots
for (i in seq_along(tree_files)) {
  generate_tree_plot(tree_files[i], family_files[i], output_files[i])
}

