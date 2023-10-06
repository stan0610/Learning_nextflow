#!/usr/bin/env nextflow

params.input_files = 'data/*.txt'
files_ch = Channel.fromPath(params.input_files)

process READFILES {

    input:
    path inputFile
    
    output:
    stdout

    script:
    """
    cat ${inputFile}
    """
}

process UPPER {

    input:
    val x

    output:
    stdout

    script:
    """
    echo '${x}' | tr '[a-z]' '[A-Z]'
    """
}

workflow {
    READFILES(files_ch) //| UPPER
    READFILES.out.view()
    UPPER(READFILES.out)
    UPPER.out.view()
}