packages <- c("plotly", "ggplot2", "dplyr", "leaflet", "sf", "readr")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    if (!require(pkg, character.only = TRUE)) {
      cat(sprintf("Failed to install %s.\n", pkg))
    }
  }
}
