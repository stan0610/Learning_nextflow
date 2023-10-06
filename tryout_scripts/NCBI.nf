#!/usr/bin/env nextflow

/*
this script is a test for using the NCBI api to get access to the SRA archive and getting the FASTQ files
*/

params.ncbi_api = '131cd2a12de60c3716bdc5f338dfc3371e09'
params.id = ['ERR908507']

/*
Channel
    .fromSRA(params.id, apiKey: params.ncbi_api)
    .view()
*/

process FASTQC {
    input:
    tuple val(sample), path(reads_file)

    output:
    path('fastqc_${sample}')

    script:
    """
    mkdir fastqc_${sample}
    fastqc -o fastqc_${sample} -f fastq -q ${reads_file}
    """
}

workflow {
    reads = Channel.fromSRA(params.id, apiKey: params.ncbi_api)
    FASTQC(reads)
}

