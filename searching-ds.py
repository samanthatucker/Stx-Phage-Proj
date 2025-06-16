import pandas as pd

# Load the CSV files into DataFrames
all_df = pd.read_csv('all.presence_absence_matrix.csv')
stx_df = pd.read_csv('stx.presence_absence_matrix.csv')

print(all_df.head())
print(stx_df.head())

# Get system columns (skip the first column which is likely source names)
system_columns = all_df.columns[1:]

# Step 1: Systems present in at least one source in 'all'
present_in_any_all = [col for col in system_columns if all_df[col].eq(1).any()]

# Step 2: Systems never present in any source in 'stx'
never_in_stx = [col for col in present_in_any_all if col not in stx_df.columns or stx_df[col].eq(1).sum() == 0]

# Output the result
print("Systems present in at least one source in 'all' and never in 'stx':")
print(never_in_stx)

with open('putative.stx.protective.systems.txt', 'w') as f:
    for system in never_in_stx:
        f.write(system + '\n')
