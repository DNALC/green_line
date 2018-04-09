#!/bin/bash

# copy index and samples to current working directory

cp $kallisto_index .

mkdir samples

first=true
while IFS=$'\t' read -r -a line
	do
		if $first
			then
			echo -e "sample\t${line[1]}\tpath" > file_info.txt
			first=false
		else
			sample_name="${line[0]}"
			identifier="${line[1]}"
			file_1="${line[2]}"
			file_2="${line[3]}"
			cp $file_1 samples/
			str="${sample_name}\t${identifier}\tsamples/$(basename $file_1)"
			if [ ! -z ${file_2} ]
				then
				cp $file_2 samples/
				str="${str}\tsamples/$(basename $file_2)"
			fi
			echo -e $str >> file_info.txt
		fi
	done < $file_info

echo "kallisto_index=$(basename ${kallisto_index})" > envs # required
echo "pair_ended=${pair_ended:-false}" >> envs # optional 
echo "sample_fragment_length=${sample_fragment_length}" >> envs # optional 
echo "output_folder=${output_folder}" >> envs #optional
echo "sample_standard_deviation=${sample_standard_deviation}" >> envs # optional
echo "threads=${threads}" >> envs # optional
echo "file_info=file_info.txt" >> envs # required

docker run --rm --env-file envs --entrypoint run-ks.sh -v $PWD:/root:Z gl-ks
