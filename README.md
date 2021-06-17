# Spatial RNA-Seq Tool
This R Shiny App allow to read spatial RNA-Seq data via a simple interface.
the following features are provided:

- charts about single genes:
  - map of barcodes expression
  - map of density of barcode expressing the gene
  - histogram of gene-expression ( expression vs barcode count having that level of expression)
- clustering with tSNE or UMAP
- dimensionality reduction chart with PCA and LSA dimensionality reduction
- map of barcodes cluster
- clustermarkers with map of marker-expressed per cluster


The data normalization algorithm used by this software is the GF-ICF (for references: https://www.frontiersin.org/articles/10.3389/fgene.2019.00734/full ).
Dimensionality reduction algorithms are the one provided with GF-ICF package (t-SNE, PCA).

Another feature is the capability to load tidymodels classifiers to make some prediction about the data (STILL IN DEVELOPEMENT)

#### analyzed tissue (human breast cancer):

<img src="https://i.imgur.com/4hetLdz.jpg" width=30% height=30% alt="breast cancer tissue image">

### marker cluster table and chart:
![marker cluster graph](https://i.imgur.com/j0HqnFY.png)

### breast cancer subtype classification using xgboost:
![classification tab](https://i.imgur.com/vMejlAT.png)

### dimensionality reduction chart and cluster map:
![dimensionality reduction chart](https://i.imgur.com/MUAXNL6.png)


## TO-DO:
- fixing model loading for custom labels
- inserting gene signature loading
