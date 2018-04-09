#!/bin/bash
threads=1

while getopts g:t: opt
do
	case "$opt" in
		g) genes=$OPTARG ;;
		t) threads=$OPTARG ;;
	esac
done

if [ -z ${genes+x} ]
	then
	echo "A gtf or gff3 genome annotation file is required"
	exit 1
fi

bam_files=$(ls *.bam)

for file in $bam_files
do
	output_file="$(basename $file .bam).gtf"
	stringtie -p $threads -G $genes -o $output_file $file
	echo $output_file >> mergelist.txt
done

stringtie --merge -p $threads -G $genes -o stringtie_merged.gtf mergelist.txt

bam_files=$(ls *.bam)

for file in $bam_files
do
	output_file="$(basename $file .bam)"
	stringtie -e -B -p $threads -G stringtie_merged.gtf -o ballgown/$output_file/"$output_file".gtf $file
done
