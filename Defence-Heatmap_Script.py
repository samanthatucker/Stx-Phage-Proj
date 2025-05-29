import pandas as pd
import networkx as nx
import seaborn as sns

# Load similarity matrix
file_path = "proteome_similarity_matrix.tsv"
df = pd.read_csv(file_path, sep='\t', index_col=0)

# Define similarity threshold
similarity_threshold = 0.8  # Change this as needed

# Build graph: connect nodes with similarity >= threshold (excluding self-links)
G = nx.Graph()
seqids = df.index.tolist()
G.add_nodes_from(seqids)

for i in range(len(seqids)):
    for j in range(i + 1, len(seqids)):
        sim = df.iloc[i, j]
        if sim >= similarity_threshold:
            G.add_edge(seqids[i], seqids[j])

# Find connected components as clusters
components = list(nx.connected_components(G))
seqid_to_cluster = {
    seqid: cluster_id
    for cluster_id, component in enumerate(components)
    for seqid in component
}

# Create DataFrame with cluster assignments
cluster_df = pd.DataFrame({
    'seqid': df.index,
    'cluster': [seqid_to_cluster.get(seqid, -1) for seqid in df.index]  # -1 for unconnected nodes
})

# Save to CSV
cluster_df.to_csv("seqid_clusters_by_threshold0.8.csv", index=False)
print(cluster_df.sort_values(by='cluster'))
print("Saved to seqid_clusters_by_threshold0.8.csv")

import matplotlib.pyplot as plt

# Reorder the DataFrame based on cluster assignments
sorted_seqids = cluster_df.sort_values(by='cluster')['seqid'].tolist()
df_sorted = df.loc[sorted_seqids, sorted_seqids]

# Create a heatmap
plt.figure(figsize=(12, 10))
sns.heatmap(df_sorted, cmap='viridis', xticklabels=True, yticklabels=True)
plt.title(f"Clustered Similarity Heatmap (threshold ≥ {similarity_threshold})")
plt.tight_layout()
plt.savefig("clustered_similarity_heatmap0.8.png", dpi=300)
plt.show()
