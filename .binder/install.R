install.packages(c("readr", "sf", "leaflet", "dplyr","stringr", "ggplot2", "geojsonio", "plotly"))

# Check if IRkernel is already installed
if (!requireNamespace("IRkernel", quietly = TRUE)) {
    # Install IRkernel from GitHub
    devtools::install_github('IRkernel/IRkernel')
    IRkernel::installspec(user = FALSE)
} else {
    # Print message if IRkernel is already installed
    cat("IRkernel is already installed at:\n")
    cat(system.file(package = "IRkernel"), "\n")
    IRkernel::installspec(user = FALSE)
}

