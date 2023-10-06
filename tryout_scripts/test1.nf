#!/usr/bin/env nextflow

// Declare syntax version
nextflow.enable.dsl=2

/*
Channels are a key data structure of Nextflow that allows the implementation 
of reactive-functional oriented computational workflows based on the Dataflow programming paradigm.

They are used to logically connect tasks to each other 
or to implement functional style data transformations.
*/

// Channel of creates a queue channel
ch = Channel.of(1, 2, 3)
//ch.view{ "value: $it" }

// channel value creates a value channel
// value channel can be processed multiple times
ch2 = Channel.value('testing some things out')
ch3 = Channel.value([15, 30, 45, 60, 75])
ch3.view()

