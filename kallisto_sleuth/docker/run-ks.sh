#!/bin/bash

run-kallisto.sh 
run-sleuth.r kallisto_output_info.txt $organism 

if [ -z $shiny_app_name ]
then
	shiny_app_name="shiny_app"
fi

mkdir $shiny_app_name
mkdir $shiny_app_name/data
	mkdir $shiny_app_name/www

if [ -f sleuth_object.so ]
then
	cp /usr/local/bin/app.R $shiny_app_name/
	cp /usr/local/bin/dnasubway-icon.png $shiny_app_name/www
	cp sleuth_object.so $shiny_app_name/data
	Rscript /usr/local/bin/shiny-apps-setup.r
	deploy-shiny-app.r $shiny_app_name
fi

cleanup.sh
