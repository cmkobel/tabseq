FROM rocker/tidyverse

RUN Rscript -e "install.packages('devtools'); devtools::install_github('cmkobel/tabseq'); library(tabseq)"


# TODO: Incorporate littler?
