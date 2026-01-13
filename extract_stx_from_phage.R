#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  cat("Usage: Rscript extract_from_lists.R lists.txt sequences_dir output_dir [ext]\n")
  quit(status = 1)
}

lists_path <- args[1]
seq_dir    <- args[2]
out_dir    <- args[3]
ext        <- if (length(args) >= 4) args[4] else ".fna"

dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

read_sequence <- function(path) {
  x <- readLines(path, warn = FALSE)
  x <- x[!grepl("^\\s*>", x)]               # ignore FASTA headers
  seq <- gsub("\\s+", "", paste(x, collapse = ""))
  seq <- toupper(seq)
  if (nchar(seq) == 0) stop("No sequence content found in file: ", path)
  seq
}

tbl <- read.delim(lists_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)

stopifnot(all(c("phage", "start", "stop") %in% names(tbl)))

for (i in seq_len(nrow(tbl))) {
  phage_id <- trimws(tbl$phage[i])
  s <- as.integer(tbl$start[i])
  e <- as.integer(tbl$stop[i])

  if (is.na(s) || is.na(e) || s < 1 || e < 1 || e < s) {
    warning("Skipping row ", i, " invalid start/stop: ", phage_id)
    next
  }

  in_path <- file.path(seq_dir, paste0(phage_id, ext))
  if (!file.exists(in_path)) {
    warning("File not found: ", in_path)
    next
  }

  seq <- read_sequence(in_path)
  L <- nchar(seq)

  s2 <- min(max(1, s), L)
  e2 <- min(max(1, e), L)
  if (e2 < s2) {
    warning("After clipping, stop < start for: ", phage_id)
    next
  }

  subseq <- substr(seq, s2, e2)

  out_path <- file.path(out_dir, sprintf("%s_%d_%d.fna", phage_id, s, e))
  writeLines(c(paste0(">", phage_id, "_", s, "_", e), subseq), out_path)

  message("Wrote: ", out_path)
}
