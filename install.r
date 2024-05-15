# Set CRAN repository
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install R packages
install.packages(c("plotly", "sf", "leaflet", "tmap", "sp"))

# Load required packages and install if not already installed
required_packages <- c("plotly", "sf", "leaflet", "tmap", "sp")
installed_packages <- rownames(installed.packages())

for (pkg in required_packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}