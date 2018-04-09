#!/bin/bash

execstr=""

indexes=( $(ls $index) )
indexes=$(printf "%s\n" "${indexes[@]}" | sed -e '$!{N;s/^\(.*\).*\n\1.*$/\1\n\1/;D;}')
indexes=${indexes%.*}
index="${index}/${indexes}"

case "$file_type" in 
	f) execstr="$execstr -f" ;;
	r) execstr="$execstr -r" ;;
	qseq) execstr="$execstr --qseq" ;;
	*) ;;
esac

if [ ! -z ${skip} ]
	then
	execstr="$execstr -s ${skip}"
fi

if [ ! -z ${upto} ]
	then
	execstr="$execstr -u ${upto}"
fi

if [ ! -z ${trim5} ]
	then
	execstr="$execstr -5 ${trim5}"
fi

if [ ! -z ${trim3} ]
	then
	execstr="$execstr -3 ${trim3}"
fi

if [[ "${phred64}" == "1" ]]
	then
	execstr="$execstr --phred64"
fi

if [[ "${intquals}" == "1" ]]
	then
	execstr="$execstr --int-quals"
fi

if [ ! -z ${nceil} ]
	then
	execstr="$execstr --n-ceil $nceil"
fi

if [[ "${ignorequals}" == "1" ]]
	then
	execstr="$execstr --ignore-quals"
fi

if [[ "${nofw}" == "1" ]]
	then
	execstr="$execstr --nofw"
fi

if [[ "${norc}" == "1" ]]
	then
	execstr="$execstr --norc"
fi

if [ ! -z ${pencansplice} ]
	then
	execstr="$execstr --pen-cansplice ${pencansplice}"
fi

if [ ! -z ${pennoncansplice} ]
	then
	execstr="$execstr --pen-noncansplice ${pennoncansplice}"
fi

if [ ! -z ${pencanintrolen} ]
	then
	execstr="$execstr --pen-canintronlen ${pencanintrolen}"
fi

if [ ! -z ${pennoncanintrolen} ]
	then
	execstr="$execstr --pen-noncanintronlen ${pennoncanintrolen}"
fi

if [ ! -z ${minintrolen} ]
	then
	execstr="$execstr --min-intronlen ${minintrolen}"
fi

if [ ! -z ${maxintrolen} ]
	then
	execstr="$execstr --max-intronlen ${maxintrolen}"
fi

if [[ "${reportnovelsplice}" == "1" ]]
	then
	execstr="$execstr --novel-splicesite-outfile novel-splicesite-${sample_name}"
fi

if [ ! -z ${rnastrandness} ]
	then
	execstr="$execstr --rna-strandness ${rnastrandness}"
fi

if [[ "${notempsplicesite}" == "1" ]]
	then
	execstr="$execstr --no-temp-splicesite"
fi

if [[ "${nosplicedalign}" == "1" ]]
	then
	execstr="$execstr --no-spliced-alignment"
fi

if [[ "${tmo}" == "1" ]]
	then
	execstr="$execstr --tmo"
fi

if [[ "${templatelenadjust}" == "0" ]]
	then
	execstr="$execstr --no-templatelen-adjustment"
fi

if [ ! -z ${mp_1} ] && [ ! -z ${mp_2} ]
	then
	execstr="$execstr --mp ${mp_1},${mp_2}"
fi

if [ ! -z ${sp_1} ] && [ -z ${sp_2} ]
	then
	execstr="$execstr --sp ${sp_1},${sp_2}"
fi

if [[ "${softclip}" == "0" ]]
	then
	execstr="$execstr --no-softclip"
fi

if [ ! -z ${np} ]
	then
	execstr="$execstr --np ${np}"
fi

if [ ! -z ${rdg_1} ] && [ ! -z ${rdg_2} ]
	then
	execstr="$execstr --rdg ${rdg_1},${rdg_2}"
fi

if [ ! -z ${rfg_1} ] && [ ! -z ${rfg_2} ]
	then
	execstr="$execstr --rfg ${rfg_1},${rfg_2}"
fi

if [ ! -z ${scoremin} ]
	then
	execstr="$execstr --score-min ${scoremin}"
fi

if [ ! -z ${k} ]
	then
	execstr="$execstr -k ${k}"
fi

if [ ! -z ${minins} ]
	then
	execstr="$execstr -I ${minins}"
fi

if [ ! -z ${maxins} ]
	then
	execstr="$execstr -X ${maxins}"
fi

case "$align" in
	rf) execstr="$execstr --rf" ;;
	ff) execstr="$execstr --ff" ;;
	*) ;;
esac

if [[ "${mixed}" == "0" ]]
	then
	execstr="$execstr --no-mixed"
fi

if [[ "${discordant}" == "0" ]]
	then
	execstr="$execstr --no-discordant"
fi

if [[ "${time}" == "1" ]]
	then
	execstr="$execstr -t"
fi

if [[ "${un}" == "1" ]]
	then
	execstr="$execstr --un unpaired-unaligned-reads-${sample_name}.gz"
fi

if [[ "${al}" == "1" ]]
	then
	execstr="$execstr --al unpaired-aligned-reads-${sample_name}.gz"
fi

if [[ "${unconc}" == "1" ]]
	then
	execstr="$execstr --un-conc unpaired-unaligned-concordantly-reads-${sample_name}.gz"
fi

if [[ "${alconc}" == "1" ]]
	then
	execstr="$execstr --al-conc unpaired-aligned-concordantly-reads-${sample_name}.gz"
fi

if [[ "${metfile}" == "1" ]]
	then
	execstr="$execstr --met-file metrics-file-${sample_name}"
fi

if [[ "${reorder}" == "1" ]]
	then
	execstr="$execstr --reorder"
fi

if [[ "${qcfilter}" == "1" ]]
	then
	execstr="$execstr --qc-filter"
fi

if [ ! -z ${seed}]
	then
	execstr="$execstr --seed ${seed}"
fi

if [[ "${deterministic}" == "0" ]]
	then
	execstr="$execstr --non-deterministic"
fi

if [[ "${removechrname}" == "1" ]]
	then
	execstr="$execstr --remove-chrname"
fi

if [[ "${addchrname}" == "1" ]]
	then
	execstr="$execstr --add-chrname"
fi

if [ ! -z ${knownsplicesite} ]
	then
	execstr="$execstr --known-splicesite-infile ${knownsplicesite}"
fi

if [ ! -z ${novelspliceinfile} ]
	then
	execstr="$execstr --novel-splicesite-infile ${novelspliceinfile}"
fi

if [[ "${single_end}" == "1" ]]
	then
		if [ -z ${execstr} ]
		then
			hisat2 -p $threads --summary-file "${sample_name}"-summary --dta -x $index -U $file_1 -S "${sample_name}".sam
		else
			hisat2 "${execstr}" -p $threads --summary-file "${sample_name}"-summary --dta -x $index -U $file_1 -S "${sample_name}".sam
		fi
	samtools sort -@ $threads -o "${sample_name}".bam "${sample_name}".sam
else
	if [ -z ${execstr} ]
		then
		hisat2 -p $threads --summary-file "${sample_name}"-summary --dta -x $index -1 $file_1 -2 $file_2 -S "${sample_name}".sam
	else
		hisat2 "${execstr}" -p $threads --summary-file "${sample_name}"-summary --dta -x $index -1 $file_1 -2 $file_2 -S "${sample_name}".sam
	fi
	samtools sort -@ $threads -o "${sample_name}".bam "${sample_name}".sam
fi

rm *.sam

exit 0
