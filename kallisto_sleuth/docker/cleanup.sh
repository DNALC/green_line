#!/bin/bash

mkdir ks-downloadable-output
for i in $( ls kallisto_output ) 
	do 
	mv kallisto_output/${i}/*.tsv ks-downloadable-output/${i}_abundance.tsv
done

mv significant.csv ks-downloadable-output/
mv plots/ ks-downloadable-output/
mv *.bam ks-output/
mv *.bai ks-output/

tar czvf ks-downloadable-output.tar.gz ks-downloadable-output --remove-files
mv ks-downloadable-output.tar.gz ks-output/

ls | grep -vE '*.err$|envs|*.out$|^ks-output' | xargs rm -r


