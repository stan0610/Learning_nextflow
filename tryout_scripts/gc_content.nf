#!/usr/bin/env nextflow

// input file
params.input = 'data/cds.fasta'
params.output = 'data/'

// use python code to parse and analyse the data
process GC_CONTENT {
    input:
    path fasta_file

    output:
    stdout

    script:
    """
    #!/usr/bin/env python

    import sys

    with open("${fasta_file}") as fasta:
        counter = 0
        gc = 0

        for line in fasta:
            if line.startswith(">"):
                continue
            else:
                for nt in line:
                    counter += 1
                    if nt == "G" or nt == "C":
                        gc += 1
        
        print('The GC-content of the fasta file --> {}%'.format(round((gc/counter)*100,2)))

    """
}


workflow {
    fasta = file(params.input)

    content = GC_CONTENT(fasta)

    content.view()
}

