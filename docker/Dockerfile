FROM rocker/rstudio:4.2.1

## In all rocker-images there is this magic folder with lots of predefined scripts for installing stuff
## like `shiny`, `quarto`, `python` including all necessarry system libraries:
## https://github.com/rocker-org/rocker-versioned2/tree/master/scripts
# RUN /rocker_scripts/install_shiny_server.sh

## In rstudio, this is already installed:
## (Source: https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/rstudio_4.2.1.Dockerfile)
## - pandoc
## - quarto

## Install some packages we need during this tutorial:
RUN install2.r --error --skipinstalled -n $NCPUS \
    fhircrackr \
    && rm -rf /tmp/downloaded_packages \
    && rm -rf /var/lib/apt/lists/*
