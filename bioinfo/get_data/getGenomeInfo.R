# Esta es una forma de obtener las regiones codificantes de los exones e ignorar los UTRs
## Posibles problemas: Quizas no tenga en cuenta todas las posibles variantes de transcriptos
install.packages("ExomeDepth")
library("ExomeDepth")
data("exons.hg19")
data("exons.hg19.X")
# Chequear las tablas que cargue

##################################################################
# Pruebas
##################################################################

source("http://bioconductor.org/biocLite.R")
# Install BSgenome package
biocLite("BSgenome")

# Install Genomic Features packages
biocLite("GenomicFeatures")
library("GenomicFeatures")

# Check available genomes
available.genomes()

# Install Hsapiens hg19 from UCSC
biocLite("BSgenome.Hsapiens.UCSC.hg19")
library("BSgenome.Hsapiens.UCSC.hg19")

biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

# Cargo las anotaciones
txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene
txdb
columns(txdb)


GR_cds <- cds(txdb)
cds(TxDb.Hsapiens.UCSC.hg19.knownGene, columns=c('CDSID', 'GENEID'))


## Esto es otra forma de obtener los CDs
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
txdb.cds <- select(txdb, keys = keys(txdb, "GENEID"),columns=c("GENEID","CDSID","CDSNAME","CDSCHROM","CDSSTRAND","CDSSTART", "CDSEND"),keytype = "GENEID")

