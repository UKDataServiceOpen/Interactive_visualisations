install.packages(c("readr", "sf", "leaflet", "dplyr","stringr", "ggplot2", "geojsonio", "plotly", "IRkernel"))
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec()
IRkernel::installspec(name = 'ir33', displayname = 'R 3.3')