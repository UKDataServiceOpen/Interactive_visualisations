# install.r

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# List of packages to install
packages <- c("plotly", "sf", "leaflet", "units", "raster", "terra")

# Install each package if not already installed
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

# Ensure all packages are loaded
lapply(packages, library, character.only = TRUE)