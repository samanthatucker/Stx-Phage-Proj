library(rentrez)
library(xml2)
library(readr)

# Set working directory and read accession list
setwd("/Users/samanthatucker/Library/CloudStorage/OneDrive-UniversityofGlasgow/Giusy_SamTucker-Project/Prophage/Stx_discovery")


# Define the function
fetch_biosample_package <- function(term) {
  # Step 1: Search the assembly database
  search_result <- entrez_search(db = "assembly", term = term)
  
  if (length(search_result$ids) == 0) {
    warning(paste("No results found for term:", term))
    return(NULL)
  }
  
  uid <- search_result$ids[1]
  
  # Step 2: Fetch the assembly summary
  taxize_summ <- entrez_summary(db = "assembly", id = uid)
  
  # Step 3: Fetch the biosample summary using the BioSample ID
  biosample_id <- taxize_summ$biosampleid
  summary <- entrez_summary(db = "biosample", id = biosample_id)
  
  # Step 4: Extract the 'package' field
  return(summary$package)
}

# Example usage on a list of terms
terms_df <- read_csv("Accessions.csv", col_names = FALSE)
terms <- terms_df[[1]] 
results <- lapply(terms, fetch_biosample_package)

# Named results
names(results) <- terms
results

# Convert the named list to a data frame
cleaned_results <- lapply(results, function(x) {
  if (is.null(x)) {
    return("unknown")
  } else {
    return(x)
  }
})
results_df <- data.frame(
  Accession = names(cleaned_results),
  Package = unlist(cleaned_results, use.names = FALSE),
  stringsAsFactors = FALSE
)

# Now write to CSV
write_csv(results_df, "samplesource.csv")
