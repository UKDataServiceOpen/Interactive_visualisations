# Use the Rocker image for R and add Conda for Python dependencies
FROM rocker/r-ver:4.2.1

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    wget \
    && apt-get clean

# Install Miniconda for managing Python dependencies
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy

# Add Conda to PATH
ENV PATH=/opt/conda/bin:$PATH

# Copy environment.yml file and install Python dependencies
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && conda clean -a

# Activate the environment, and ensure these commands run:
RUN echo "source activate myenv" > ~/.bashrc
ENV PATH /opt/conda/envs/myenv/bin:$PATH

# Install R packages
COPY install.r /tmp/
RUN Rscript /tmp/install.r

# Set environment variables for R
ENV UDUNITS2_INCLUDE=/usr/include/udunits2
ENV UDUNITS2_LIBS=/usr/lib
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Set the default command to launch R
CMD ["R"]