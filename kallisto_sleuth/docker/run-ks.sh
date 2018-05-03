#!/bin/bash

run-kallisto.sh 
run-sleuth.r kallisto_output_info.txt $organism
cleanup.sh
