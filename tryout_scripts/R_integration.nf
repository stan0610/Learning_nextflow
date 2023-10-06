#!/usr/bin/env nextflow

// file to read in
params.csv = 'data/pigs-diets-weight.csv' 

process INTEGRATION {
    //publishDir './output/', mode: 'copy'

    input:
    val X

    output:
    stdout

    script:
    """
    data_vis.R ${X}
    """
}

workflow {
    file = file(params.csv)

    INTEGRATION(file)
}









