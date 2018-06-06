FROM rocker/verse:latest
MAINTAINER "Sandeep Chitta" "chittasandeep@gmail.com"
ENV REFRESHED_AT 2017-06-10

# Make ~/.R
RUN mkdir -p $HOME/.R


# Install ggplot extensions like ggstance and ggrepel
# Install ed, since nloptr needs it to compile.
# Install all the dependencies needed by rstanarm and friends
# Install multidplyr for parallel tidyverse magic
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get -y --no-install-recommends install \
    ed \
    clang  \
    ccache \
    libiomp-dev \
    libpoppler-cpp-dev \
    build-essential \
    unixodbc \
    libgdal-dev \
    libgeos-dev \
    libfuse-dev \
    libudunits2-0 \
    libudunits2-dev \
    gdebi-core \
    libcurl4-gnutls-dev \
    curl \
    gnupg \
    pandoc \
    pandoc-citeproc \
    libxt-dev \
    whois



RUN install2.r --error \  
        reticulate DT stringr shiny tidyverse\
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
		&& rm -rf /var/lib/apt/lists/*


## Download and install Shiny Server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O shiny-server-latest.deb && \
    gdebi -n shiny-server-latest.deb && \
    rm -f version.txt shiny-server-latest.deb


RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

RUN mkdir /home/rstudio/ShinyApps/

RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /home/rstudio/ShinyApps/

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

EXPOSE 3838

RUN mkdir -p /var/log/shiny-server
RUN chown shiny.shiny /var/log/shiny-server

#RUN export ADD=shiny && bash /etc/cont-init.d/add

RUN apt-get -qq update && \
	apt-get -y dist-upgrade
RUN apt-get install -y --no-install-recommends \
	fonts-dejavu \
	gfortran \
	gcc 
RUN apt-get -y install python3 python3-pip
#RUN apt-get -y install pandoc texlive texlive-latex-extra texlive-xetex
RUN apt-get autoclean

RUN pip3 install --upgrade pip

# Fundamentals
RUN pip3 install --upgrade jupyter  \
	numpy \
	scipy \
	pandas \
	pillow \
        termcolor \
        google.cloud




# Plotting and Visualization
RUN pip3 install --upgrade matplotlib \
	bokeh \
	ggplot \
	plotly \
	seaborn

# profilers 
RUN pip3 install --upgrade line_profiler memory_profiler




