import pandas as pd
import glob
import os

# Path to the folder containing the CSV files
folder_path = '/Users/samanthatucker/Documents/compiled_files'
all_files = glob.glob(os.path.join(folder_path, "*.csv"))

# List to hold DataFrames
dfs = []

for file in all_files:
    df = pd.read_csv(file)
    df['source_file'] = os.path.basename(file)  # Add a column with the file name
    dfs.append(df)

# Combine all data into a single DataFrame
combined_df = pd.concat(dfs, ignore_index=True)

# Optional: save the result
combined_df.to_csv('combined_output.csv', index=False)
