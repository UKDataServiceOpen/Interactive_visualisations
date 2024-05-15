# Set a CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of packages to install
packages <- c("plotly", "ggplot2", "dplyr", "leaflet", "sf", "readr")

# Install the packages
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    print(paste("Installing", pkg))
    install.packages(pkg, dependencies = TRUE)
    if (!require(pkg, character.only = TRUE)) {
      cat(sprintf("FAILED TO INSTALL %s.\n", pkg))
    } else {
      print(paste(pkg, "INSTALLED SUCCESSFULLY"))
    }
  } else {
    print(paste(pkg, "ALREADY INSTALLED"))
  }
}