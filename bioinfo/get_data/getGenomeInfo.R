# Esta es una forma de obtener las regiones codificantes de los exones e ignorar los UTRs
## Posibles problemas: Quizas no tenga en cuenta todas las posibles variantes de transcriptos
install.packages("ExomeDepth")
library("ExomeDepth")
data("exons.hg19")
data("exons.hg19.X")
# Chequear las tablas que cargue

##################################################################
# Otra forma
##################################################################

## Cargo el manager de paquetes de bioconductor
source("http://bioconductor.org/biocLite.R")

# Install BSgenome package
biocLite("BSgenome")
library("BSgenome")

# Install Genomic Features packages
biocLite("GenomicFeatures")
library("GenomicFeatures")

# Check available genomes
available.genomes()

# Install Hsapiens hg19 from UCSC
biocLite("BSgenome.Hsapiens.UCSC.hg19")
library("BSgenome.Hsapiens.UCSC.hg19")

# Instalar las anotaciones de refseq para hg19
biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
txdb
columns(txdb)
txdb.cds <- select(txdb, keys = keys(txdb, "GENEID"),columns=c("GENEID","TXID","TXNAME","CDSID","CDSNAME","CDSCHROM","CDSSTRAND","CDSSTART", "CDSEND"),keytype = "GENEID")
# 629183 rows

cds<-cdsBy(txdb,"tx")

# Guardo los datos
setwd("~/Proyectos/INDEAR/Parseos/Illumina_Exome")
write.table(txdb.cds,file="CDS_hg19_refseq.tsv",sep="\t")


# GRange to bed
fiveUTRs <- fiveUTRsByTranscript(txdb)
gr <- GRanges(seqnames = Rle(c("chr1", "chr2", "chr1", "chr3"), c(1, 3, 2, 4)),
              ranges = IRanges(1:10, end = 7:16, names = head(letters, 10)),
              strand = Rle(strand(c("-", "+", "*", "+", "-")), c(1, 2, 2, 3, 2)))

##################################################################
# Pruebas
##################################################################


# Cargo las anotaciones
GR_cds <- cds(txdb)
cds(TxDb.Hsapiens.UCSC.hg19.knownGene, columns=c('CDSID', 'GENEID'))

library(dplyr)
brca2 <- filter(txdb.cds,GENEID=="675")
