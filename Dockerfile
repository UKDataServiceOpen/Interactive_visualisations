# Use the official R-base image as the base image
FROM r-base:4.4.0

# Add the R Project repository key and repository
RUN apt-get update && \
    apt-get install -y gnupg2 software-properties-common && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B8F25A8A73EACF41 && \
    gpg --export --armor B8F25A8A73EACF41 | tee /etc/apt/trusted.gpg.d/cran_debian_key.asc && \
    add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran40/' && \
    apt-get update

# Install necessary packages without libglib2.0-0
RUN apt-get install -y \
    libglib2.0-bin \
    gir1.2-girepository-2.0

# Install Python 3 and necessary libraries
RUN apt-get install -y \
    python3 python3-pip python3-venv python3-dev \
    libudunits2-dev libgdal-dev libgeos-dev libproj-dev \
    libsqlite3-dev build-essential librsvg2-dev libcairo2-dev sudo

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

# Clean up package lists to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to /home/jovyan (default for Binder)
WORKDIR /home/jovyan

# Copy all contents of the repository into the working directory
COPY . /home/jovyan

# Debug step: List contents of /home/jovyan
RUN ls -la /home/jovyan

# Change ownership and permissions of the /home/jovyan directory
RUN chown -R jovyan:jovyan /home/jovyan && chmod -R 775 /home/jovyan

# Expose the port Jupyter will run on
EXPOSE 8888

# Switch to jovyan user
USER jovyan

# Set a default command to run JupyterLab with the virtual environment activated
CMD ["/bin/bash", "-c", ". /opt/venv/bin/activate && exec jupyter lab --ip=0.0.0.0 --port=8888 --notebook-dir=/home/jovyan --no-browser --allow-root"]




