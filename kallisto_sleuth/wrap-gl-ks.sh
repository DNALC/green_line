#!/bin/bash

mkdir ks-output
mkdir bams
samples=( $samples )

echo "transcriptome=${transcriptome}" > envs
echo "file_info=${file_info}" >> envs
echo "transcriptome_annotation=${transcriptome_annotation}" >> envs
echo "bootstrap=100" >> envs
echo "seed=${seed}" >> envs
echo "single_end=${single_end}" >> envs
echo "multi_condition=${multi_condition}" >> envs
echo "bias=${bias}" >> envs
echo "plain_text=${plain_text}" >> envs
echo "fusion=${fusion}" >> envs
echo "fr=${fr}" >> envs
echo "rf=${rf}" >> envs
echo "pseudobam=${pseudobam}" >> envs
echo "fragment_length=${fragment_length}" >> envs
echo "standard_deviation=${standard_deviation}" >> envs
echo "organism=${organism}" >> envs

docker run -v $PWD:/root --rm --env-file envs --entrypoint run-ks.sh gl-ks
