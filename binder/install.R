local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org"
  options(repos = r)
})

## non CRAN packages

install.packages("missSBM")     # SBM with missing data
install.packages("factoextra")  # Fancy plotting of factor-based methods
install.packages("FactoMineR")  # Factor analysis
install.packages("GGally")      # pairs plots
install.packages("kableExtra")  # fancy kable
install.packages("babynames")   # data in tutorials