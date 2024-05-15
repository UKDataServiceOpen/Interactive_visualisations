FROM rocker/r-ver:4.2.1

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    && apt-get clean

# Install R packages
COPY install.r /tmp/
RUN Rscript /tmp/install.r

# Set environment variables for R
ENV UDUNITS2_INCLUDE=/usr/include/udunits2
ENV UDUNITS2_LIBS=/usr/lib
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Copy runtime.txt for Binder
COPY runtime.txt /tmp/