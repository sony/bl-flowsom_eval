#########################################################################################
# R script to Meta-clustering from clustering result.
#
# Copyright 2025 Sony Corporation
#########################################################################################

library(FlowSOM)

My_MetaClustering <-function(codes, k=10)
{
    meta_clus <- metaClustering_consensus(codes,k=k,seed=12345)
    meta_clus
} 

run <- function(clust_file, codes_file, meta_k, out_fname)
{
    message("[START]read_files")
    clust_res <- read.csv(clust_file,header=FALSE)
    codes <- read.csv(codes_file,header = FALSE)
    message("[END]read_files")

    # metaclustering using codes
    message("[START]MetaClustering")
    meta_cl <- as.factor(My_MetaClustering(codes, meta_k))
    message("[END]MetaClustering")

    meta_res <- meta_cl[clust_res[,1]]

    write.table(meta_res,out_fname, quote=F, sep=",",row.names=F, col.names=F)
    message("[END]outputFile")

}

###################################################################################
###################################################################################
#main
args <- commandArgs(trailingOnly = T)

#parse argment
clust_file = args[1] # clustering result file (.csv)
codes_file = args[2] # codes file (.csv) 
meta_k     = as.numeric(args[3]) # meta_k
out_fname  = args[4] #output fname

message("*********************************")
message("*run all                       **")
message("*********************************")
t<- system.time(run(clust_file=clust_file, codes_file= codes_file, meta_k = meta_k, out_fname=out_fname))
message(sprintf("[TIME]run all(with output file IO / without input file IO ): %f sec",t[3]))
message(sprintf("[MEM]run all = %f MB\n",memory.size(T)))

q()
