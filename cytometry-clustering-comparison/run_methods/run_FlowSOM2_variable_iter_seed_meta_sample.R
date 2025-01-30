#########################################################################################
# R script to run FlowSOM_pre and FlowSOM
#
# Lukas Weber, August 2016
# Modified by Sony Corporation, January 2025
#########################################################################################

args <- commandArgs(trailingOnly = T)
in_file = args[1] # fcs
out_dir = args[2] # out dir
iter = as.integer(args[3])
seed = as.integer(args[4])
metak = as.integer(args[5])
sampleid = args[6] # Levine32/Levine13/Samusik_01/Samusik_all/ etc 
init_mode = args[7]
argcoluse = 5:36

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
    #fsom <- myUpdateDerivedValues(fsom)
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

###########################################################
### Run FlowSOM: with specified number of meta clusters ###
###########################################################

# run FlowSOM with default number of clusters for dataset

set.seed(seed)
fSOM <- FlowSOM::ReadInput(data, transform = FALSE, scale = FALSE)
t <- system.time(fSOM <- myBuildSOM(fSOM, rlen= iter, init = initPCA, initf = Initialize_PCA))
message(sprintf("[TIME]convert: %f sec",t[3]))
fSOM <- FlowSOM::BuildMST(fSOM)
out  <- fSOM
  # store output and runtimes for meta-clustering step below
out_pre_auto <- out

cat("FlowSOM", seed, iter, ": runs complete\n")

meta <- suppressMessages(
    ConsensusClusterPlus::ConsensusClusterPlus(t(out_pre_auto$map$codes), maxK = metak, seed = seed))

#take spscified meta cluster
outm <- meta[[metak]]$consensusClass
cat("data set", ": run complete\n")

clus <- outm[out_pre_auto$map$mapping[, 1]]
files_label <- paste0(out_dir, "/", "FlowSOM_labels_seed_", seed, "_iter_", iter, "_meta_", metak,".txt")
res_i <- data.frame(label = clus)
write.table(res_i, file = files_label, row.names = FALSE, quote = FALSE, sep = "\t")


