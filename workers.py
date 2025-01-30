#########################################################################################
# workers of calculate jaccard index
#
# Copyright 2025 Sony Corporation
#########################################################################################
import os
import pandas as pd
import argparse
import numpy as np
import copy

def calc_jaccard_meta(Outdir, workdir, fold_num, div_num, sample_name):
    os.chdir(workdir)
    print(sample_name)
    base_path = os.path.join(Outdir,"FSOM",sample_name)

    df = [None] * fold_num
    df_cl = [None] * div_num * fold_num
    df_merge = [None] * div_num
    df_outer = [None] * div_num
    df_rate = [None] * div_num
    
    for fold in range(fold_num):
        fname = "fsom_%s_jaccard_%d_meta.csv"%(sample_name,fold+1)
        fpath = os.path.join(base_path, fname)
        df[fold] = pd.read_csv(fpath)

    for fold in range(fold_num):
        for clust in range(div_num):
            df_cl[fold * div_num + clust] = pd.DataFrame(df[fold][str(clust + 1)]).dropna()

    result_list = []
    for fold in range(fold_num): 
        print(fold)
        for n in range(div_num):
            compare = df_cl[fold * div_num + n]
            for fold2 in range(fold_num):
                if fold != fold2:
                    df_rate = [None] * div_num
                    for m in range(div_num):
                        new = df_cl[fold2 * div_num + m].rename(columns={str(m + 1):str(n + 1)})
                        df_merge[m] = pd.merge(new, compare).dropna()
                        df_outer[m] = pd.merge(new, compare, how='outer').dropna()
                        df_rate[m] = len(df_merge[m]) / len(df_outer[m])
                    res = [fold,n,fold2,df_rate.index(max(df_rate)),max(df_rate)]
                    result_list.append(res)
    result_df = pd.DataFrame(result_list)
    result_df.to_csv("%s_jaccard_fsom_meta.csv"%sample_name)
    result_df.describe()


def calc_jaccard_clust(Outdir, workdir, fold_num, div_num, sample_name):
    os.chdir(workdir)
    print(sample_name)
    base_path = os.path.join(Outdir,"FSOM",sample_name)

    df = [None] * fold_num
    df_cl = [None] * div_num * fold_num
    df_merge = [None] * div_num
    df_outer = [None] * div_num
    df_rate = [None] * div_num
    
    for fold in range(fold_num):
        fname = "fsom_%s_jaccard_%d_clust.csv"%(sample_name,fold+1)
        fpath = os.path.join(base_path, fname)
        df[fold] = pd.read_csv(fpath)

    for fold in range(fold_num):
        for clust in range(div_num):
            df_cl[fold * div_num + clust] = pd.DataFrame(df[fold][str(clust + 1)]).dropna()

    result_list = []
    for fold in range(fold_num): 
        print("top_fold")
        print(fold)
        for n in range(div_num):
            compare = df_cl[fold * div_num + n]
            for fold2 in range(fold_num):
                if fold != fold2:
                    df_rate = [None] * div_num
                    for m in range(div_num):
                        new = df_cl[fold2 * div_num + m].rename(columns={str(m + 1):str(n + 1)})
                        df_merge[m] = pd.merge(new, compare).dropna()
                        df_outer[m] = pd.merge(new, compare, how='outer').dropna()
                        df_rate[m] = len(df_merge[m]) / len(df_outer[m])
                    res = [fold,n,fold2,df_rate.index(max(df_rate)),max(df_rate)]
                    result_list.append(res)
    result_df = pd.DataFrame(result_list)
    result_df.to_csv("%s_jaccard_fsom_clust.csv"%sample_name)
    result_df.describe()

def calc_jaccard_meta_table4(Outdir, workdir, fold_num, div_num):
    os.chdir(workdir)
    base_path = os.path.join(Outdir,)

    df = [None] * fold_num
    df_cl = [None] * div_num * fold_num
    df_merge = [None] * div_num
    df_outer = [None] * div_num
    df_rate = [None] * div_num
    
    for fold in range(fold_num):
        fname = "fsom_samsik_all_head%d_jaccard_meta.csv"%(fold+1)
        #fname = "fsom_%s_jaccard_%d_meta.csv"%(sample_name,fold+1)
        fpath = os.path.join(base_path, fname)
        df[fold] = pd.read_csv(fpath)

    for fold in range(fold_num):
        for clust in range(div_num):
            df_cl[fold * div_num + clust] = pd.DataFrame(df[fold][str(clust + 1)]).dropna()

    result_list = []
    for fold in range(fold_num): 
        print(fold)
        for n in range(div_num):
            compare = df_cl[fold * div_num + n]
            for fold2 in range(fold_num):
                if fold != fold2:
                    df_rate = [None] * div_num
                    for m in range(div_num):
                        new = df_cl[fold2 * div_num + m].rename(columns={str(m + 1):str(n + 1)})
                        df_merge[m] = pd.merge(new, compare).dropna()
                        df_outer[m] = pd.merge(new, compare, how='outer').dropna()
                        df_rate[m] = len(df_merge[m]) / len(df_outer[m])
                    res = [fold,n,fold2,df_rate.index(max(df_rate)),max(df_rate)]
                    result_list.append(res)
    result_df = pd.DataFrame(result_list)
    result_df.to_csv("samsik_reorder_jaccard_fsom_meta_table4.csv")
    result_df.describe()


def calc_jaccard_clust_table4(Outdir, workdir, fold_num, div_num):
    os.chdir(workdir)
    base_path = os.path.join(Outdir)
    df = [None] * fold_num
    df_cl = [None] * div_num * fold_num
    df_merge = [None] * div_num
    df_outer = [None] * div_num
    df_rate = [None] * div_num
    
    for fold in range(fold_num):
        fname = "fsom_samsik_all_head%d_jaccard_clust.csv"%(fold+1)
        fpath = os.path.join(base_path, fname)
        df[fold] = pd.read_csv(fpath)

    for fold in range(fold_num):
        for clust in range(div_num):
            df_cl[fold * div_num + clust] = pd.DataFrame(df[fold][str(clust + 1)]).dropna()

    result_list = []
    for fold in range(fold_num): 
        print("top_fold")
        print(fold)
        for n in range(div_num):
            compare = df_cl[fold * div_num + n]
            for fold2 in range(fold_num):
                if fold != fold2:
                    df_rate = [None] * div_num
                    for m in range(div_num):
                        new = df_cl[fold2 * div_num + m].rename(columns={str(m + 1):str(n + 1)})
                        df_merge[m] = pd.merge(new, compare).dropna()
                        df_outer[m] = pd.merge(new, compare, how='outer').dropna()
                        df_rate[m] = len(df_merge[m]) / len(df_outer[m])
                    res = [fold,n,fold2,df_rate.index(max(df_rate)),max(df_rate)]
                    result_list.append(res)
    result_df = pd.DataFrame(result_list)
    result_df.to_csv("samsik_reorder_jaccard_fsom_clust_table4.csv")
    result_df.describe()

def get_rawnum(sample_id, event, df):
    d = df[df["sample"] == sample_id]
    #print(d)
    c = d[d["event"] == event]["Unnamed: 0"].iloc[0]
    return c


def save_trans_result(ref_df, clust_fname, table_fname, out_fname):
    
    cdf = pd.read_csv(clust_fname)    
    dest = copy.deepcopy(cdf)
    table_df = pd.read_csv(table_fname)

    idx = 0
    for row in table_df.itertuples():
        if idx %100000 == 0:
            print(idx)
        sample_id = row.sample
        event = row.event
        row = get_rawnum(sample_id,event, ref_df) -1
        label_id  = cdf["label"][idx]
        dest["label"][row] = label_id
        idx = idx +1
    dest.to_csv(out_fname, index=False)
    

