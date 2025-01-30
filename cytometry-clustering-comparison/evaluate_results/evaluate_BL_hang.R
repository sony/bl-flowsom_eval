#########################################################################################
# R script to load and evaluate results for FlowSOM
#
# Lukas Weber, August 2016
# Modified by Sony Corporation, January 2025
#########################################################################################


library(flowCore)
library(clue)

#args[1] ground truth fcs file
#args[2] input cluster id
#args[3] output file

args <- commandArgs(trailingOnly = T)

fcs_file = args[1]
result_file = args[2]
out_file = args[3]

# helper functions to match clusters and evaluate
source("../helpers/helper_match_evaluate_multiple.R")

data_truth_i <- flowCore::exprs(flowCore::read.FCS(fcs_file, transformation = FALSE, truncate_max_range = FALSE))
clus_truth<- data_truth_i[, "label"]


############################
### load results         ###
############################

clus <- read.table(result_file, header = F, stringsAsFactors = FALSE)[, "V1"]

# contingency tables
# (excluding FlowCAP data sets since population IDs are not consistent across samples)
print(table(clus, clus_truth))


###################################
### match clusters and evaluate ###
###################################

# see helper function scripts for details on matching strategy and evaluation

res<- helper_match_evaluate_multiple(clus, clus_truth)

# store named object (for plotting scripts)

res_FlowSOM <- res
cat("hangmeanF1= ",res$mean_F1,"\n")

out_file <- out_file
out_file_each <- paste0(out_file,"_each.csv")

write.table(res$mean_F1, out_file, quote=F, sep=",", row.names=F, col.names=F)
write.table(res$F1 ,out_file_each,quote=F, sep=",", row.names=F, col.names=F) 

