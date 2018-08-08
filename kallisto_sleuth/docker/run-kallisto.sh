#!/bin/bash

prinseq=false
output_dir=kallisto_output
execstr=""

if [ -z ${fragment_length} ] || [ -z ${standard_deviation} ]
then
	echo "Fragment length and standard deviation will be calculated"
	prinseq=true
fi


if [[ "${bias}" == "1" ]]
	then
	execstr="$execstr --bias"
fi

if [[ "${plain_text}" == "1" ]]
	then
	execstr="$execstr --plain-text"
fi

if [[ "${fusion}" == "1" ]]
	then
	execstr="$execstr --fusion"
fi

if [[ "${fr}" == "1" ]]
	then
	execstr="$execstr --fr-stranded"
fi

if [[ "${rf}" == "1" ]]
	then
	execstr="$execstr --rf-stranded"
fi


if [ ! -d $output_dir ]
then
	mkdir $output_dir
fi

echo -e "sample\tpath\tcondition" > kallisto_output_info.txt

kallisto index -i index.idx $transcriptome

file_info=$( echo ${file_info} | sed 's/[{|}]/ /g' )

if [[ "${single_end}" == "1" ]]
then	
	for file in ${file_info}
	do
		file=($( echo ${file} | sed 's/,/ /g' ))
		file_name=${file[0]}
		sample_name=${file[1]}
		condition=${file[2]}

		## might not make sense to check if its compressed for *all* cases. Maybe only for not pseudobam...
		if file $file_name | grep -q "gzip compressed"
			then
			if $prinseq
				then
				res=$(perl /usr/local/bin/prinseq-lite.pl -fastq <(zcat $file_name) -stats_len)
				res=( $res )
				fragment_length=${res[5]}
				standard_deviation=${res[23]}
				if [ $standard_deviation == 0.00 ]
					then
					standard_deviation=0.05
				fi
			fi
			kallisto quant -i index.idx -o $output_dir/$sample_name -b $bootstrap -t $threads --genomebam --gtf $transcriptome_annotation ${execstr} --single -l $fragment_length -s $standard_deviation $file_name
			echo -e "$sample_name\t$output_dir/$sample_name\t$condition\t$condition2" >> kallisto_output_info.txt
			mv $output_dir/$sample_name/pseudoalignments.bam ${sample_name}.bam
			mv $output_dir/$sample_name/pseudoalignments.bam.bai ${sample_name}.bam.bai
		else
			echo "fastq files must be gzipped compressed"
			exit 1
		fi
	done 
else
	for file in ${file_info}
	do
		file=($( echo ${file} | sed 's/,/ /g' ))
		file_1=${file[0]}
		file_2=${file[1]}
		sample_name=${file[2]}
		condition=${file[3]}
		if file $file_1 | grep -q "gzip compressed" && file $file_2 | grep -q "gzip compressed"
			then
			kallisto quant -i index.idx -o $output_dir/$sample_name -b $bootstrap -t $threads --genomebam --gtf $transcriptome_annotation ${execstr} $file_1 $file_2
			echo -e "$sample_name\t$output_dir/$sample_name\t$condition\t$condition2" >> kallisto_output_info.txt
			mv $output_dir/$sample_name/pseudoalignments.bam ${sample_name}.bam
			mv $output_dir/$sample_name/pseudoalignments.bam.bai ${sample_name}.bam.bai
		else
			echo "fastq files must be gzipped compressed"
			exit 1
		fi
	done 
fi

exit 0
