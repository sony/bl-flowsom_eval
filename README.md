# Evaluation of FlowSOM and BL-FlowSOM clustering result
BL-FlowSOM is an improved version of [FlowSOM](https://github.com/SofieVG/FlowSOM) that uses batch learning, which is available on [Sony’s Spectral Flow Analysis (SFA) - Life sciences Cloud Platform ](https://www.sonybiotechnology.com/us/instruments/sfa-cloud-platform/). This repository contains evaluation scripts for clustering result of FlowSOM and BL-FLowSOM. Part of our evaluation scripts were developed based on Lukas Weber's [cytometry-clustering-comparison](https://github.com/lmweber/cytometry-clustering-comparison). This repository also contains FP7000_34c dataset file acquired with Sony's FP7000 Spectral Cell Sorter which has similar optics to Sony's ID7000<sup>TM</sup> Spectral Cell Analyzer.

## Overview
Our scripts evaluate clustering result in terms of quality of clustering and consistency of clustering. The scripts compare the clustering result with manual gating results and calculate F1-score to evaluate the clustering quality. The scripts also calculate consistency score to evaluate the consistency of clustering results among multiple attempts independent of manually gated labels. Please note that the clustering result files (trained SOM vector and classified result of input events to SOM) are needed for BL-FlowSOM evaluation. These files can be obtained from [a proof-of-concept implementation of BL-FlowSOM](https://github.com/sony/bl-flowsom_poc). FlowSOM, on the other hand, is performed within the scripts to generate clustering result for evaluation.

## Requirements

To run the scripts of this repository, you need:
- Python 3.11.0 or later
- pip 25.0 or later
- Jupyter Notebook or simillar environment to execute ipynb file

## Setup

1. Clone this repository:
    ```bash
    git clone https://github.com/sony/bl-flowsom_eval
    ```

2. Move to the cloned directory:
    ```bash
    cd bl-flowsom_eval/
    ```

3. Install the required libraries:
    ```bash
    pip install -r requirements.txt
    ```
4. Install Jupyter Notebook or similar environment

## Data preparation
### FP7000_34c dataset
Pre-processed FP7000_34c.fcs dataset is divided due to its large size. It needs to be combined before script execution. This dataset contains manual gate labels for each events to calculate F1-score.
1. Move to FP7000_34c data directory:
    ```bash
    cd benchmark_data_sets/FP7000_34c/data/
    ```

2. Combine divided dataset file:
    ```bash
    (Linux)
    cat FP7000_34c_0* > FP7000_34c.fcs
    ```
    ```bash
    (Windows)
    copy /b FP7000_34c_0* FP7000_34c.fcs
    ```
### Weber's datasets
Weber's dataset files (Levine_32dim.fcs, Levine_13dim.fcs, Samusik_01.fcs, Samusik_all.fcs) are also used for clustering evaluation. These pre-processed dataset files are available from FlowRepository ([repository FR-FCM-ZZPH](https://flowrepository.org/id/FR-FCM-ZZPH)) and need to be downloaded and placed in following appropriate folders before script execution. These datasets also contain manual gate labels for F1-score calculation.
- benchmark_data_sets/Levine_32dim/data/
- benchmark_data_sets/Levine_13dim/data/
- benchmark_data_sets/Samusik_01/data/
- benchmark_data_sets/Samusik_all/data/

## Usage
Execute following ipynb files in sequence with Jupyter Notebook.
- [1.Generate_data.ipynb](1.Generate_data.ipynb)
  - Calculate F1-score for each number of meta-clusters
- [2.get_max_F.ipynb](2.get_max_F.ipynb)
  - Identify the number of meta-clusters with the best F1-score among all number of meta-clusters
- [3.jaccard-eval_table3.ipynb](3.jaccard-eval_table3.ipynb)
  - Calculate consistency score for cluster and meta-cluster
- [4.jaccard-eval_table4.ipynb](4.jaccard-eval_table4.ipynb)
  - Calculate consistency score with different order of data
- [5.Plot_fig4.ipynb](5.Plot_fig4.ipynb)
  - Generate figure for evaluation result of clustering quality
- [6.Plot_figS3.ipynb](6.Plot_figS3.ipynb)
  - Generate figure for relationship between the number of meta-clusters and the mean F1-score
- [7.Plot_figS4.ipynb](7.Plot_figS4.ipynb)
  - Generate figure for mean F1-score with different random seed 
- [8.PlotEachGate_F_fig5.ipynb](8.PlotEachGate_F_fig5.ipynb)
  - Generate heatmap of F1-scores at each manual gate and each number of meta-clusters

## License
The repository is licensed under the [MIT License](LICENSE).
