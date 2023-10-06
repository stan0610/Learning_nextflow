#!/usr/bin/env nextflow

params.reads = "$projectDir/data/sample_*_{1,2}.txt"

reads_ch = Channel.fromFilePairs(params.reads)
reads_ch.view()




