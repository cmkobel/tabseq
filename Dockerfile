FROM rocker/tidyverse

RUN Rscript -e "if (!requireNamespace("devtools", quietly = TRUE)) { install.packages("devtools") }; devtools::install_github("cmkobel/tabseq"); library(tabseq)"


# TODO: Incorporate littler?
