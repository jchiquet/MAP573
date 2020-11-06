local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org"
  options(repos = r)
})

## R packages not available on conda
install.packages("missSBM")     # SBM with missing data
install.packages("factoextra")  # Fancy plotting of factor-based methods
install.packages("FactoMineR")  # Factor analysis
install.packages("GGally")      # pairs plots
install.packages("kableExtra")  # fancy kable
install.packages("babynames")   # data in tutorials
install.packages("fields")      # spatial tools
install.packages("ggsci")       # fancy plotting
install.packages("ggpubr")      # fancy plotting
install.packages("ggrepel")     # fancy plotting
install.packages("cowplot")     # more fancy plotting
install.packages("simputation") # imputation
install.packages("RANN")        # fast nearest neighbors
install.packages("Rtsne")       # tSNE implementation in R
install.packages("umap")        # umap implementation in R
install.packages("missSBM")     # SBM + data for French political blogosphere
install.packages("mixtools")    # simple mixture models
