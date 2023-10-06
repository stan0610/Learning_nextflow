#!/usr/bin/env nextflow
/******************************************************************************/ 
/* To download test samples use:
   fastq-dump --gzip -X 100000 -O sra/ SRR5222977 SRR5222978 SRR5222979 SRR5222980 SRR5222981 SRR5222982 SRR5222983 SRR5222984 
/******************************************************************************/ 
/* Finally run the nexflow pipeline script
   nextflow run basic-pipeline.nf --mainfolder /home/bit/Documents/nextflow-test/ --threads 4
/******************************************************************************/
/* Set input parameters
/******************************************************************************/
params.mainfolder = '/home/guest/Documents/nextflow-examples/'
params.threads = '2'

/******************************************************************************/
/* Set output folders 
/******************************************************************************/
fastq_files = params.mainfolder + '01-sra/*.fastq.gz'
fastqc_folder = params.mainfolder + '02-fastqc/'
multiqc_folder = params.mainfolder + '03-multiqc/'

/******************************************************************************/
/* Show info 
/******************************************************************************/
log.info """\

R N A S E Q    P I P E L I N E    
==============================
main folder  : ${params.mainfolder}
threads      : ${params.threads}
samples      : ${fastq_files}
fastqc       : ${fastqc_folder}
multiqc      : ${multiqc_folder}

"""

/******************************************************************************/
/* Get fastq.gz files in "fastq_ch" Channel
/* fastq_ch = Channel.fromPath( fastq_files )
/******************************************************************************/
Channel
    .fromPath( fastq_files )
    .ifEmpty { error "Cannot find any fastq.gz files: $fastq_files" }
    .set { fastq_ch }

/******************************************************************************/
/* 2nd process: run FastQC on all fastq.gz files
/******************************************************************************/
process runFastQC {
    
    publishDir fastqc_folder, mode:'copy'

    input:
    file fastq from fastq_ch

    output:
    file("fastqc_${fastq}") into fastqc_ch

    script:
    """
    mkdir fastqc_${fastq}
    fastqc -t ${params.threads} -o fastqc_${fastq} ${fastq}
    """

}

/******************************************************************************/
/* 3rd process: run MultiQC on FastQC results 
/******************************************************************************/
process runMultiQC {

    publishDir multiqc_folder, mode:'copy'

    input:
    file('fastqc*/*') from fastqc_ch

    output:
    file('multiqc_report.html')

    script:
    """
    mkdir -p ${multiqc_folder}
    multiqc ${fastqc_folder}
    """

}

/******************************************************************************/
/* Show result "Done" or "Oops" on completion
/******************************************************************************/
workflow.onComplete {
	log.info ( workflow.success ? "\nDone!\n" : "Oops something went wrong!" )
}