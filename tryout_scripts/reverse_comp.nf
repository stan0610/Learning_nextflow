#!/usr/bin/env nextflow

// input file
params.input = 'data/cds.fasta'
params.output = 'data/'

// uses the transeq function from EMBOSS package
process REVERSE {

    publishDir params.output, mode: 'copy'

    input:
    path fasta_file

    output:
    path "reverse.fasta"

    script:
    """
    seqtk seq -r ${fasta_file} > reverse.fasta
    """
}


workflow {
    fasta = file(params.input)

    REVERSE(fasta)
}

