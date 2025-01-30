#########################################################################################
# R script to run FlowSOM_pre and FlowSOM
#
# Lukas Weber, August 2016
#########################################################################################
#########################################################################################
# R script to run FlowSOM cluster and Meta clustering of FlowSOM
#
# Modified by Sony Corporation, January 2025
#########################################################################################
args <- commandArgs(trailingOnly = T)
in_file = args[1] # fcs
out_dir = args[2] # out dir
iter = as.integer(args[3])
seed = as.integer(args[4])
metak = as.integer(args[5])
sampleid = args[6] # Levine32/Levine13/Samusik_01/Samusik_all 
init_mode = args[7] # RAND or PCA

argcoluse = 5:36
if (is.na(sampleid)) {
    argcoluse = 5:36
} else if (sampleid == "Levine_32dim") {
    argcoluse = 5:36
} else if (sampleid == "Levine_13dim"){
    argcoluse = 1:13
} else if (sampleid == "Samusik_01" | sampleid == "Samusik_all" ){
    argcoluse = 9:47
}

initPCA = FALSE
if (!is.na(init_mode) && init_mode == "PCA") {
    initPCA = TRUE
}

library(flowCore)
library(FlowSOM)

myBuildSOM <- function(fsom, colsToUse=NULL, silent=FALSE, rlen = rlen,...){
    if(!"data" %in% names(fsom)){
        stop("Please run the ReadInput function first!")
    }
    
    if(!silent) message("Building SOM\n")
    cat("Buildsom", rlen, "start\n")

    if(is.null(colsToUse)){
        colsToUse <- seq_len(ncol(fsom$data))
    }
    
    fsom$map <- FlowSOM::SOM(fsom$data[, colsToUse], silent=silent, rlen = rlen,...)
    fsom$map$colsUsed <- colsToUse
    fsom
}


#################
### LOAD DATA ###
#################

# filenames

f <-  file.path(in_file)
ff <- flowCore::read.FCS(f, transformation = FALSE, truncate_max_range = FALSE)
param_filename = paste0(tools::file_path_sans_ext(in_file), "_param.csv")
if (file.exists(param_filename)) {
  param <- trimws(as.character(read.csv(param_filename, header = FALSE)))
  data <- ff@exprs[, param]
} else {
  data <- ff@exprs[, argcoluse]
}

#####################################################
### Run FlowSOM: clustering                       ###
#####################################################


set.seed(seed)
fSOM <- FlowSOM::ReadInput(data, transform = FALSE, scale = FALSE)
t <- system.time(fSOM <- myBuildSOM(fSOM, rlen= iter, init = initPCA, initf = Initialize_PCA))
message(sprintf("[TIME]convert: %f sec",t[3]))
fSOM <- FlowSOM::BuildMST(fSOM)
out  <- fSOM
out_pre_auto <- out

# save cluster labels
files_label <- paste0(out_dir, "/", "FlowSOM_labels_seed_", seed, "_iter_", iter, "_clust",".txt")

res_i <- data.frame(label = out$map$mapping[, 1])
write.table(res_i, file = files_label, row.names = FALSE, quote = FALSE, sep = "\t")
meta <- suppressMessages(
        ConsensusClusterPlus::ConsensusClusterPlus(t(out_pre_auto$map$codes), maxK = metak, seed = seed))

# specify meta cluster 
outm <- meta[[metak]]$consensusClass
clus <- outm[out_pre_auto$map$mapping[, 1]]
# save meta cluster labels
files_label <- paste0(out_dir, "/", "FlowSOM_labels_seed_", seed, "_iter_", iter, "_meta_", metak,".txt")
res_i <- data.frame(label = clus)
write.table(res_i, file = files_label, row.names = FALSE, quote = FALSE, sep = "\t")

cat("FlowSOM cluster", seed, iter, ": all runs complete\n")
