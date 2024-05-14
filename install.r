# Install regular R packages
install.packages("readr")
install.packages("dplyr")
install.packages("stringr")  # Note: it's 'stringr', not 'string'
install.packages("ggplot2")
install.packages("plotly")
install.packages("leaflet")
install.packages("sf")

# You might also need to set repository if automatic CRAN mirrors do not work
options(repos = c(CRAN = "https://cloud.r-project.org"))