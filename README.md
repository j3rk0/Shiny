# Spatial scRNA-Seq Tool
This R Shiny App allow to read spatial RNA-Seq data via a simple interface.
the following features are provided:

-graphs about single genes:
  --map of barcodes expression
  --map of density of barcode expressing the gene
  --histogram of gene-expression ( expression vs barcode count having that expression)
-clustering with tSNE or UMAP
-dimensionality reduction chart with PCA and LSA dimensionality reduction
-map of barcodes cluster
-clustermarkers with map of marker-expressed per cluster


The data normalization algorithm used by this software is the GF-ICF (for references: https://www.frontiersin.org/articles/10.3389/fgene.2019.00734/full ).
Dimensionality reduction algorithms are the one provided with GF-ICF package (t-SNE, PCA).

Another feature is the capability to load tidymodels classifiers to make some prediction about the data

#TO-DO:
- fixing model loading for custom labels
- inserting gene signature loading
