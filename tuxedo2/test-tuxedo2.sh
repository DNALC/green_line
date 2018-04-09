#!/bin/bash
# Test with Arabidopsis Thaliana 
# hisat2_index=/home/perezde/sample_data/arabidopsis_thaliana/indexes
# file_info=/home/perezde/sample_data/arabidopsis_thaliana/arabidopsis_thaliana_file_info.txt
# annotation=/home/perezde/sample_data/arabidopsis_thaliana/genes/Arabidopsis_thaliana.TAIR10.37.chromosome.all.gff3

# Testi with Caenorhabditis Elegans
hisat2_index=/home/perezde/sample_data/caenorhabditis_elegans/indexes
file_info=/home/perezde/sample_data/caenorhabditis_elegans/caenorhabditis_elegans_file_info.txt
annotation=/home/perezde/sample_data/caenorhabditis_elegans/annotation/Caenorhabditis_elegans.WBcel235.90.chromosome.all.gff3 

# Test with Sorghum Bicolor (paired end)
# hisat2_index=/home/perezde/sample_data/sorghum_bicolor/indexes
# file_info=/home/perezde/sample_data/sorghum_bicolor/sorghum_bicolor_file_info.txt
# annotation=/home/perezde/sample_data/sorghum_bicolor/genes/Sorghum_bicolor.Sorghum_bicolor_v2.37.gff3
# paired_end=true

# Test with Zea Mays (single end)
# Genome is AGPv4
# hisat2_index=/home/perezde/sample_data/zea_mays/indexes
# file_info=/home/perezde/sample_data/zea_mays/zea_mays_file_info_se.txt
# annotation=/home/perezde/sample_data/zea_mays/Zea_mays.AGPv4.37.chromosome.gff3.gz

# Testi with Zea Mays (paired end)
# Genome is AGPv4
# hisat2_index=/home/perezde/sample_data/zea_mays/indexes
# file_info=/home/perezde/sample_data/zea_mays/zea_mays_file_info_pe.txt
# annotation=/home/perezde/sample_data/zea_mays/Zea_mays.AGPv4.37.chromosome.gff3.gz
# paired_end=true
cd /home/perezde/gl/tuxedo2/tuxedo2_data

. ./wrap-tuxedo2.sh
