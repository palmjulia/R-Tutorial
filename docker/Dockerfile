FROM rocker/rstudio:4.2.2

## In all rocker-images there is this magic folder with lots of predefined scripts for installing stuff
## like `shiny`, `quarto`, `python` including all necessarry system libraries:
## https://github.com/rocker-org/rocker-versioned2/tree/master/scripts
# RUN /rocker_scripts/install_shiny_server.sh

## In rstudio, this is already installed:
## (Source: https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/rstudio_4.2.1.Dockerfile)
## - pandoc
## - quarto

## Install some system libraries we need
RUN apt-get update && apt-get install -y --no-install-recommends \
    # ca-certificates important for curl from https:
    ca-certificates \
    curl \
    libssl-dev \
    libxml2-dev && \
    ## Clear caches:
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /home/${USER}/.cache/pip/* && \
    apt-get clean all && \
    apt-get autoclean && \
    apt-get autoremove -y
    
    

## Install some packages we need during this tutorial:
RUN install2.r --error \
    fhircrackr \
    ggplot2 \
    htmltools \
    jsonlite \
    knitr \
    remotes \
    rmarkdown \
    && rm -rf /tmp/downloaded_packages \
    && rm -rf /var/lib/apt/lists/*

## Install newest version of fhircrackr from GitHub:
#RUN R -q -e 'remotes::install_github(repo = "POLAR-fhiR/fhircrackr", ref = "master")'
