# Shiny-scRNA-Seq
This R Shiny App allow to read single-cell RNA-Seq data via a simple interface. 

This software let you plot graph about RNA concentration and cell's information.
The data normalization algorithm used by this software is the GF-ICF (for references: https://www.frontiersin.org/articles/10.3389/fgene.2019.00734/full ).

Dimensionality reduction algorithms are the one provided with GF-ICF package (t-SNE, PCA).
Another feature is the capability to load tidymodels classifiers to make some prediction about the data
