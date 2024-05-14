packages <- c("plotly", "ggplot2", "dplyr", "leaflet", "sf", "readr")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    print(paste("Installing", pkg))
    install.packages(pkg, dependencies = TRUE)
    if (!require(pkg, character.only = TRUE)) {
      cat(sprintf("FAILED TO INSTALL %s.\n", pkg))
    } else {
      print(paste(pkg, "INSTALLED SUCCESFFULLYY"))
    }
  } else {
    print(paste(pkg, "ALREADY INSTALLED"))
  }
}