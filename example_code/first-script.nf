#!/usr/bin/env nextflow

nextflow.enable.dsl = 1

params.str = 'Hello world!'

process convertToUpper {
    output:
    stdout result
    """
    printf '${params.str}' | tr '[a-z]' '[A-Z]'
    """
}

result.view { it }
