# Load required libraries
library(circlize)
library(dendextend)
library(cluster)
library(factoextra)
library(NbClust)

#Chord diagram for Stx-converting & Stx-type prophage selected for the dataset#####
# Step 1: Load data
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/Fresh/clean_fasta/all_gffs/selected_gffs/lovis4u_2025_06_06-11_06")
df <- read.table("proteome_similarity_matrix.tsv", header = TRUE, sep = "\t", row.names = 1)
mat <- as.matrix(df)
mat[is.na(mat)] <- 0
diag(mat) <- 0

# Ensure square matrix
mat <- mat[intersect(rownames(mat), colnames(mat)), intersect(rownames(mat), colnames(mat))]

# Convert similarity to distance
dist_mat <- as.dist(1 - mat)

### ---- Method 1: Elbow Plot (Within-cluster sum of squares) ---- ###
wss <- numeric(20)
for (k in 2:20) {
  clusters <- cutree(hclust(dist_mat, method = "average"), k)
  wss[k] <- sum(sapply(1:k, function(i) {
    members <- names(clusters[clusters == i])
    submat <- mat[members, members, drop = FALSE]
    mean((1 - submat)^2)
  }))
}
plot(2:20, wss[2:20], type = "b", xlab = "Number of clusters (k)", ylab = "Within-cluster sum of squares", main = "Elbow Method")

### ---- Method 2: Silhouette Width ---- ###
sil_width <- numeric(20)
for (k in 2:20) {
  clusters <- cutree(hclust(dist_mat, method = "average"), k)
  sil <- silhouette(clusters, dist_mat)
  sil_width[k] <- mean(sil[, 3])
}

plot(2:20, sil_width[2:20], type = "b",
     xlab = "Number of clusters (k)",
     ylab = "Average Silhouette Width",
     main = "Silhouette Method",
     xaxt = "n")  # suppress x-axis so we can customize it
axis(1, at = 2:20)

#Decided on 18 cluster groups

# Step 2: Clean up matrix
diag(mat) <- 0  # Remove self-similarity
mat[is.na(mat)] <- 0  # Replace NAs with zero

# Step 3: Hierarchical clustering
# Convert similarity to distance (1 - similarity)
dist_mat <- as.dist(1 - mat)

# Perform clustering
hc <- hclust(dist_mat, method = "average")  # You can also try "ward.D2"

# Cut into groups (e.g., 10 groups)
num_groups <- 12
clusters <- cutree(hc, k = num_groups)

# Ensure matrix is square and row/column names match
mat <- mat[intersect(rownames(mat), colnames(mat)), intersect(rownames(mat), colnames(mat))]

# Perform clustering again on cleaned matrix
dist_mat <- as.dist(1 - mat)
hc <- hclust(dist_mat, method = "average")
clusters <- cutree(hc, k = num_groups)

# Create group-to-group similarity matrix
group_sim <- matrix(0, nrow = num_groups, ncol = num_groups,
                    dimnames = list(paste0("Group_", 1:num_groups), paste0("Group_", 1:num_groups)))

for (i in 1:num_groups) {
  for (j in 1:num_groups) {
    members_i <- names(clusters[clusters == i])
    members_j <- names(clusters[clusters == j])
    valid_members_i <- members_i[members_i %in% rownames(mat)]
    valid_members_j <- members_j[members_j %in% colnames(mat)]
    
    if (length(valid_members_i) > 0 && length(valid_members_j) > 0) {
      submat <- mat[valid_members_i, valid_members_j, drop = FALSE]
      vals <- submat[submat > 0]
      group_sim[i, j] <- ifelse(length(vals) > 0, mean(vals), 0)
    }
  }
}
# Replace NAs (from groups with no interactions) with 0
group_sim[is.na(group_sim)] <- 0

# Step 5: Plot the chord diagram
group_colors <- c(
  "Group_1" = "#1f77b4",
  "Group_2" = "#ff7f0e",
  "Group_3" = "#2ca02c",
  "Group_4" = "#d62728",
  "Group_5" = "#9467bd",
  "Group_6" = "#8c564b",
  "Group_7" = "#e377c2",
  "Group_8" = "#7f7f7f",
  "Group_9" = "#bcbd22",
  "Group_10" = "#17becf",
  "Group_11" = "#1B9E77FF",
  "Group_12" = "#D95F02FF",
)
chordDiagram(group_sim, grid.col = group_colors, transparency = 0.6)
