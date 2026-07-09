"
Select one representative seqid per cluster.

Reads a cluster-membership CSV (columns: seqid,cluster) and writes one
representative sequence per unique cluster to an output CSV.

Usage:
    python select_representatives.py [input.csv] [output.csv]

Defaults:
    input  = seqid_clusters_by_threshold0.5.csv
    output = Duplodno-representatives50.csv
"""

import csv
import sys

def select_representatives(input_path, output_path):
    seen = set()          # cluster ids already assigned a representative
    representatives = []   # (seqid, cluster) rows, in first-seen cluster order

    with open(input_path, newline="") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames is None or "seqid" not in reader.fieldnames \
                or "cluster" not in reader.fieldnames:
            raise ValueError(
                f"Expected columns 'seqid' and 'cluster'; got {reader.fieldnames}"
            )

        for row in reader:
            cluster = row["cluster"]
            seqid = row["seqid"]
            # Take the first seqid we encounter for each cluster.
            if cluster not in seen:
                seen.add(cluster)
                representatives.append((seqid, cluster))

    with open(output_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["seqid", "cluster"])
        writer.writerows(representatives)

    return len(representatives)


def _cli_args():
    """Return command-line args, but ignore Jupyter/IPython kernel args.

    In a notebook, sys.argv looks like ['ipykernel_launcher.py', '-f',
    '.../kernel.json'], which would otherwise be misread as filenames.
    """
    if any("ipykernel" in a or a == "-f" for a in sys.argv):
        return []
    return sys.argv[1:]


def main():
    args = _cli_args()
    input_path = args[0] if len(args) > 0 else "Duplodnaviria/seqid_clusters_by_threshold0.5.csv"
    output_path = args[1] if len(args) > 1 else "Duplodnaviria/Duplodno-representatives50.csv"

    n = select_representatives(input_path, output_path)
    print(f"Wrote {n} representatives (one per cluster) to {output_path}")


if __name__ == "__main__":
    main()
