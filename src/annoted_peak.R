
library(dplyr)
library(ggplot2)

workDir <- "/home/rstudio/mydatalocal/Arabidocontratac/Annotation"
setwd(workDir)
sample <- "2019_006_S6"
distance_threshold <- 50


annotated_peaks <- read.table(file = paste0(sample, ".annotatedPeaks"), h = F)

annotated_peaks <- annotated_peaks %>% mutate(pos = ifelse(abs(V15) < distance_threshold, "overlap", ifelse(V14 < 0, "upstream", "downstream") )) 

annotate_overlap <- function(x){
  if ( x[16] == "overlap" ) {
    
    if ( x[14] == "+" ) { # forward gene
      if ( as.numeric(x[2]) < as.numeric(x[11]) ) { # the peak overlaps the start of the gene
        if ( as.numeric(x[3]) < as.numeric(x[12]) ) { 
          out <- "overlap_TSS" } else { out <- "full_overlap" } }
      
      else { 
        if ( as.numeric(x[3]) < as.numeric(x[12]) ) { 
          out <- "inclusion" } else { out <- "overlap_TES" } }
    }
    
    
    else { # x[14] == "-" # reverse gene
      if ( as.numeric(x[2]) < as.numeric(x[11]) ) { # the peak overlaps the stop of the gene
        if ( as.numeric(x[3]) < as.numeric(x[12]) ) { 
          out <- "overlap_TES" } else { out <- "full_overlap" } }
      
      else { 
        if ( as.numeric(x[3]) < as.numeric(x[12]) ) { 
          out <- "inclusion" } else { out <- "overlap_TSS" } }
    }
    
  } else { out <- NA }
  return(out)
}

annotated_peaks$type <- apply(annotated_peaks, 1, annotate_overlap)