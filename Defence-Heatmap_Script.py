import pandas as pd
import os
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import LogNorm,PowerNorm

df = pd.read_csv('combined.filtered_output.csv')

df.head()

# Create the presence-absence matrix
presence_absence_matrix = pd.crosstab(df['source'], df['system'])

# Convert values >0 to 1 (indicating presence)
presence_absence_matrix = (presence_absence_matrix > 0).astype(int)

# Set the figure size
plt.figure(figsize=(220, 120))  # Adjust dimensions as needed

plt.figure(figsize=(len(presence_absence_matrix.columns) * 0.3, 10)) 
presence_absence_heatmap =sns.heatmap(presence_absence_matrix,cmap='crest',cbar=True, linewidths=0.5, linecolor='black')

# Add labels and title
plt.xlabel('Defence System')
plt.ylabel('Sequence ID')

# Display the heatmap
plt.tight_layout()
plt.savefig('presence_absence_heatmap2.png', dpi =600,bbox_inches='tight')
plt.show()

# Optional: Save the matrix to a new CSV file
presence_absence_matrix.to_csv('all.presence_absence_matrix.csv')

df = pd.read_csv('stx.combined.filtered_output.csv')
df.head()

# Create the presence-absence matrix
presence_absence_matrix = pd.crosstab(df['source'], df['system'])

# Convert values >0 to 1 (indicating presence)
presence_absence_matrix = (presence_absence_matrix > 0).astype(int)

# Set the figure size
plt.figure(figsize=(220, 120))  # Adjust dimensions as needed

plt.figure(figsize=(len(presence_absence_matrix.columns) * 0.3, 10)) 
presence_absence_heatmap =sns.heatmap(presence_absence_matrix,cmap='crest',cbar=True, linewidths=0.5, linecolor='black')

# Add labels and title
plt.xlabel('Defence System')
plt.ylabel('Sequence ID')

# Display the heatmap
plt.tight_layout()
plt.savefig('stx.presence_absence_heatmap.png', dpi =600,bbox_inches='tight')
plt.show()

# Optional: Save the matrix to a new CSV file
presence_absence_matrix.to_csv('stx.presence_absence_matrix.csv')
