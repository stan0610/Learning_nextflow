#!/usr/bin/env nextflow

// this script takes a fastq file and will perform fastqc on it

params.reads = "$projectDir/../dummy_fastqs/Sample_R{1,2}_001.fastq.gz"
params.fastqc = "$projectDir/fastqc"
params.outdir = "$projectDir/data/"

log.info """\
    F A S T Q C ------- P I P E L I N E
    ===================================
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """
    .stripIndent()

reads_ch = Channel.fromFilePairs(params.reads)

process FASTQC {
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(reads_file)

    output:
    path "fastqc_${sample_id}"

    script:
    """
    mkdir fastqc_${sample_id}
    fastqc -o fastqc_${sample_id} -f fastq -q ${reads_file}
    """
}

workflow {
    FASTQC(reads_ch)
}
