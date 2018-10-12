#!/bin/bash

SINGULARITY_IMAGE=/work/projects/singularity/cyverse/gl-ks-r1.0.simg

mkdir ks-output
mkdir bams
samples=( $samples )

export "transcriptome=${transcriptome}"
export "file_info=${file_info}"
export "transcriptome_annotation=${transcriptome_annotation}"
export "bootstrap=100"
export "seed=${seed}"
export "single_end=${single_end}"
export "multi_condition=${multi_condition}"
export "bias=${bias}"
export "threads=16"
export "plain_text=${plain_text}"
export "fusion=${fusion}"
export "fr=${fr}"
export "rf=${rf}"
export "pseudobam=${pseudobam}"
export "fragment_length=${fragment_length}"
export "standard_deviation=${standard_deviation}"
export "organism=${organism}"
export "shiny_app_name=${shiny_app_name}"

singularity exec $SINGULARITY_IMAGE run-ks.sh
