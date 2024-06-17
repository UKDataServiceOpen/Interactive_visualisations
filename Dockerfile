# Use the official R-base image as the base image
FROM r-base:4.4.0

# Install system libraries required by the 'sf' package and other dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran40/' && \
    apt-get update && \
    apt-get install -y --allow-downgrades \
    libglib2.0-0=2.80.2-2 \
    libglib2.0-bin=2.80.2-2 \
    gir1.2-glib-2.0=2.80.2-2 && \
    apt-get install -y libudunits2-dev libgdal-dev libgeos-dev libproj-dev \
    python3 python3-pip python3-venv python3-dev \
    libsqlite3-dev build-essential librsvg2-dev libcairo2-dev sudo \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create jovyan user and home directory
RUN useradd -m -s /bin/bash jovyan

# Create and activate a virtual environment, then install additional Python packages
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install jupyter ipykernel pyarrow pandas geopandas folium plotly statsmodels && \
    /opt/venv/bin/python -m ipykernel install --name=venv --user

# Ensure the virtual environment is used for subsequent commands
ENV PATH="/opt/venv/bin:$PATH"

# Install R packages including IRkernel which allows R to run on Jupyter Notebook
RUN R -e "install.packages(c('leaflet', 'readr', 'dplyr', 'ggplot2', 'plotly', 'sf', 'IRkernel', 'Cairo', 'rsvg'), dependencies=TRUE, repos='https://cloud.r-project.org/')" && \
    R -e "IRkernel::installspec(user = FALSE)"

# Set the working directory to /home/jovyan/work
WORKDIR /home/jovyan/work

# Copy all contents of the repository into the working directory
COPY . /home/jovyan/work

# Change ownership and permissions of the /home/jovyan/work directory
RUN chown -R jovyan:jovyan /home/jovyan/work && chmod -R 775 /home/jovyan/work

# Expose the port Jupyter will run on
EXPOSE 8888

# Switch to jovyan user
USER jovyan

# Set a default command to run JupyterLab with the virtual environment activated
CMD ["/bin/bash", "-c", ". /opt/venv/bin/activate && exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]