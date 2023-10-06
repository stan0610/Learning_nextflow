#!/usr/bin/env nextflow
/******************************************************************************/ 
/* Use DSL version 2 */
nextflow.enable.dsl = 2
/******************************************************************************/ 
/* Input parameters */
params.mainfolder = '/home/bit/Documents/nextflow-examples/'
// params.scripts = '/home/bit/Documents/nextflow-examples/00-scripts'
params.threads = '2'
/* Output folders */
params.fastq_files = params.mainfolder + '01-sra/*.fastq.gz'
params.fastqc_folder = params.mainfolder + '02-fastqc/'
params.multiqc_folder = params.mainfolder + '03-multiqc/'
/* 
trimming_folder = params.mainfolder + '03-trimming/'
fastqc2_folder = params.mainfolder + '04-fastqc2/'
multiqc2_folder = params.mainfolder + '04-multiqc2/'
mapping_folder = params.mainfolder + '05-mapping/'
samtools_folder = params.mainfolder + '06-samtools/'
counting_folder = params.mainfolder + '07-counting/'
*/
/******************************************************************************/ 
log.info """\

R N A S E Q    P I P E L I N E    
==============================
main folder  : ${params.mainfolder}
threads      : ${params.threads}
samples      : ${params.fastq_files}
fastqc       : ${params.fastqc_folder}
"""
/******************************************************************************/
process runFastQC {
    publishDir params.fastqc_folder, mode: 'copy'
     
    input:
    path fastq_file
    
    output:
    path "*_fastqc.{zip,html}"
    
    script:
    """
    mkdir -p ${params.fastqc_folder}
    fastqc ${fastq_file} -t ${params.threads} --extract
    """
}
process multiqc {
    publishDir params.multiqc_folder, mode: 'copy'

    input:
    path fastqc_out

    output:
    path "*multiqc_report.html"
    path "*_data"

    script:
    """
    mkdir -p ${params.multiqc_folder}
    multiqc ${fastqc_out} -m fastqc
    """
}
/******************************************************************************/
/* Define the workflow */
workflow {
    fastq_ch = Channel.fromPath(params.fastq_files)
    runFastQC(fastq_ch)
    //multiqc_ch = Channel.fromPath(params.fastqc_folder)
    multiqc(runFastQC.out.collect())
}
/******************************************************************************/