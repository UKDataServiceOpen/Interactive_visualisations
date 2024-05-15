# Use the Jupyter Docker Stacks image as the base
FROM jupyter/r-notebook:latest

# Install system dependencies needed for R packages
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

# Install mamba for faster package management
RUN conda install -c conda-forge mamba && conda clean -a

# Copy environment file and create the conda environment
COPY environment.yml /tmp/environment.yml
RUN mamba env create -f /tmp/environment.yml && conda clean -a

# Activate the environment and ensure conda environment is used
ENV PATH /opt/conda/envs/myenv/bin:$PATH

# Set environment variables for R
ENV UDUNITS2_INCLUDE=/usr/include/udunits2
ENV UDUNITS2_LIBS=/usr/lib
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Switch back to jovyan user
USER jovyan

# Copy directories into the image
COPY Data /home/jovyan/Data
COPY Images /home/jovyan/Images
COPY Python_code /home/jovyan/Python_code
COPY R_code /home/jovyan/R_code
COPY Shapefiles /home/jovyan/Shapefiles

# Copy and install R packages
COPY install.r /tmp/install.r
RUN Rscript /tmp/install.r

# Run Jupyter Notebook by default
CMD ["start-notebook.sh"]
