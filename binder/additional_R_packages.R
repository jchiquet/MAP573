local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org"
  options(repos = r)
})

## non CRAN packages

library(knitr)       # R notebook export and formatting 
install.packages("factoextra")  # Fancy plotting of FactoMineR outputs
install.packages("FactoMineR")  # Factor analysis
install.packages("GGally") # paris plots
