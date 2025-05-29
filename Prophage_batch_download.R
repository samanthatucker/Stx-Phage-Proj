r

#Utilising Entrez to pull the information from ncbi
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage")
library(readr)
require(rentrez)
entrez_email <- ""

data1 <- read.csv("TABLE4_PHAGES.csv", header = TRUE)
View(data1)

#To write to individual fasta files
for (i in seq_len(nrow(data1))) {
  id <- data1$Nucleotide_id[i]
  seq_start <- data1$start[i]
  seq_stop <- data1$end[i]
  
  cat("Fetching", id, "from", seq_start, "to", seq_stop, "\n")
  
  try({
    seq <- entrez_fetch(db = "nuccore",
                        id = id,
                        rettype = "fasta",
                        retmode = "text",
                        seq_start = seq_start,
                        seq_stop = seq_stop,
                        strand = 1)
    
    # Clean ID for filename safety (optional)
    file_name <- paste0("hotspot_", id, "_", seq_start, "_", seq_stop, ".fasta")
    
    writeLines(seq, con = file_name)
  }, silent = TRUE)
}

####Download the Stx_positive phage from previous chapter####
data2 <- read.csv("TABLE_stx_positive.csv", header = TRUE)
View(data2)

#To write to individual fasta files
for (i in seq_len(nrow(data2))) {
  id <- data2$Nucleotide_id[i]
  seq_start <- data2$start[i]
  seq_stop <- data2$end[i]
  
  cat("Fetching", id, "from", seq_start, "to", seq_stop, "\n")
  
  try({
    seq <- entrez_fetch(db = "nuccore",
                        id = id,
                        rettype = "fasta",
                        retmode = "text",
                        seq_start = seq_start,
                        seq_stop = seq_stop,
                        strand = 1)
    
    # Clean ID for filename safety (optional)
    file_name <- paste0(id, "_", seq_start, "_", seq_stop, ".fasta")
    
    writeLines(seq, con = file_name)
  }, silent = TRUE)
}
