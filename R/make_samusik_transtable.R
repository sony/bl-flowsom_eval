#########################################################################################
# R script to reordering samusik_all by sampleID
#
# Copyright 2025 Sony Corporation
#########################################################################################

library(flowCore)


#1st arg dataframe of original FCS file
#2nd arg sort order
make_sorted_frame <- function(df, sort_vec) {
    selected_rows <- df[df$sample %in% sort_vec, , drop = FALSE]  
    sortdf <- selected_rows[order(match(selected_rows$sample, sort_vec)), ]  # sort with sort_vec
    return(sortdf)
}

# main
run <- function(in_path, out_path){
    colmn_list <- c("sample","event","label")

    for ( i in 1:10){
        fcs_name <- paste0("samsik_all_head", i ,".fcs")
        fcs_file <- file.path(in_path, fcs_name) 
        #input fcs file
        print(fcs_file)
        fcs_data <- read.FCS(fcs_file, truncate_max_range=FALSE)
        mat <- fcs_data@exprs # matrix
        data_selected <- mat[, colmn_list]

        ofname <- paste0("samusik_table_fold", i, ".csv")
        out_fname <- file.path(out_path, ofname)
        write.csv(data_selected,out_fname)
        rm(mat)
        rm(fcs_data)
    }
    fcs_name <- "samsik_all_head1.fcs"
    fcs_file <- file.path(in_path, fcs_name)
    fcs_data <- read.FCS(fcs_file, truncate_max_range=FALSE)
    mat <- fcs_data@exprs # matrix
    data_selected <- mat[, colmn_list]

    #save fold1's data as reference
    ofname <- "samusik_table_reference.csv"
    out_fname <- file.path(out_path, ofname)
    write.csv(data_selected,out_fname)
}

#main
args <- commandArgs(trailingOnly = T)
message(sprintf("args1 %s",args[1]))
in_path = args[1] #path to samsik_all_head*.fcs
out_path = args[2] #output path

run(in_path, out_path)

q()
