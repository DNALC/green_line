#!/bin/bash

hisat2_exec_str="-i ${hisat2_index}"
hisat2_exec_str="$hisat2_exec_str -t $threads"

if $pair_ended
	then
	hisat2_exec_str="$hisat2_exec_str -p"
fi

stringtie_exec_str="-g $genes"
stringtie_exec_str="$stringtie_exec_str -t $threads"

run-hisat2.sh ${hisat2_exec_str} $file_info
run-stringtie.sh $stringtie_exec_str
run-ballgown.r
