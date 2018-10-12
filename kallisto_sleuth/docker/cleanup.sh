#!/bin/bash

mkdir ks-downloadable-output
for i in $( ls kallisto_output ) 
	do 
	mv kallisto_output/${i}/*.tsv ks-output/${i}_abundance.tsv
	mv kallisto_output/${i}/run_info.json ks-downloadable-output/${i}_run_info.json
done

if [[ "${pseudobam}" == "1" ]]
then
	mv *.bam ks-output/
	mv *.bai ks-output/
fi

tar czvf ks-downloadable-output.tar.gz ks-downloadable-output --remove-files
mv ks-downloadable-output.tar.gz ks-output/

rm *fastq.gz
rm transcriptome_annotation.gtf.gz
rm transcriptome.fa.gz
rm kallisto_output_info.txt
rm index.idx
rm gene_bd

