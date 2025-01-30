#########################################################################################
# R script to reordering samusik_all by sampleID
#
# Copyright 2025 Sony Corporation
#########################################################################################

library(flowCore)

#reorder order
vec1 <- c(1,2,3,4,5,6,7,8,9,10)
vec2 <- c(2,3,4,5,6,7,8,9,10,1)
vec3 <- c(3,4,5,6,7,8,9,10,1,2)
vec4 <- c(4,5,6,7,8,9,10,1,2,3)
vec5 <- c(5,6,7,8,9,10,1,2,3,4)
vec6 <- c(6,7,8,9,10,1,2,3,4,5)
vec7 <- c(7,8,9,10,1,2,3,4,5,6)
vec8 <- c(8,9,10,1,2,3,4,5,6,7)
vec9 <- c(9,10,1,2,3,4,5,6,7,8)
vec10 <- c(10,1,2,3,4,5,6,7,8,9)

#1st arg dataframe of fcs
#2nd arg sort order
make_sorted_frame <- function(df, sort_vec) {
    selected_rows <- df[df$sample %in% sort_vec, , drop = FALSE]  
    sortdf <- selected_rows[order(match(selected_rows$sample, sort_vec)), ] 
    return(sortdf)
}

# main
run <- function(fcs_fname, out_path){
    if (!file.exists(out_path)){
        dir.create(out_path, recursive =TRUE)
    }
    #input fcs data
    fcs_data <- read.FCS(fcs_fname, truncate_max_range=FALSE)
    mat <- fcs_data@exprs # matrix
    desc <- fcs_data@description #store description
    param <- fcs_data@parameters #store paramters
    df <- as.data.frame(mat) #to dataframe
    #reorder sample order
    for ( i in 1:10){
        vec_name <- paste("vec", i , sep = "")
        vec <- get(vec_name)
        sorted_df <- make_sorted_frame(df,vec)
        flow_frame <- flowFrame(exprs = as.matrix(sorted_df),description= desc, parameters=param)
        out_fname <- paste("samsik_all_head", i , ".fcs", sep="")
        out_file <- file.path(out_path, out_fname) 
        cat(out_file)
        write.FCS(flow_frame, file = out_file)
    }
}

#main
args <- commandArgs(trailingOnly = T)
message(sprintf("args1 %s",args[1]))
samusikallfcs = args[1] # samusik_all fcs_file
out_path = args[2] #output path

run(samusikallfcs, out_path)

q()
