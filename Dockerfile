# Use the Jupyter Docker Stacks image as the base
FROM jupyter/r-notebook:latest

# Install system dependencies
USER root
RUN apt-get update -qq && apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    && apt-get clean

# Switch back to jovyan user
USER jovyan

# Install R packages
COPY install.r /tmp/
RUN Rscript /tmp/install.r

# Copy environment.yml for Python dependencies
COPY environment.yml /tmp/
RUN conda env update -f /tmp/environment.yml && conda clean -a

# Set environment variables for R
ENV UDUNITS2_INCLUDE=/usr/include/udunits2
ENV UDUNITS2_LIBS=/usr/lib
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Run Jupyter Notebook by default
CMD ["start-notebook.sh"]