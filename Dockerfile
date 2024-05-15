# Use the Jupyter Docker Stacks image as the base
FROM jupyter/r-notebook:latest

# Install system dependencies
USER root
RUN apt-get update -qq && apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libheif-dev \
    libpoppler-cpp-dev \
    libjson-c-dev \
    libfreexl-dev \
    libqhull-dev \
    libgeos-c1v5 \
    libkml-dev \
    libxerces-c-dev \
    && apt-get clean

# Install conda dependencies
COPY environment.yml /tmp/
RUN conda env update -f /tmp/environment.yml && conda clean -a

# Switch back to jovyan user
USER jovyan

# Install R packages
COPY install.r /tmp/
RUN Rscript /tmp/install.r

# Set environment variables for R
ENV UDUNITS2_INCLUDE=/usr/include/udunits2
ENV UDUNITS2_LIBS=/usr/lib
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Run Jupyter Notebook by default
CMD ["start-notebook.sh"]