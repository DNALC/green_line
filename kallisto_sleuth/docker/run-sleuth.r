#!/usr/bin/env Rscript

library("sleuth")

args = commandArgs(trailingOnly=TRUE)

s2c <- read.table(file.path(args[1]), header=TRUE, stringsAsFactors=FALSE)

so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)

type <- colnames(s2c)[3]

formula <- paste0("~", type)
so <- sleuth_fit(so, eval(parse(text=formula)), 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')

sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)

write.csv(sleuth_significant, 'significant.csv')

tests <- eval(parse(text=paste0("unique(s2c[2])$", type)))
valid_tests <- c()
for (test in tests) {
	tryCatch({
		test_name <- paste0(type, test)
		so <- sleuth_wt(so, test_name)
		valid_tests <- c(valid_tests, test_name)
	},
	error=function(err){})
}

sleuth_save(so, 'sleuth_object.so')

