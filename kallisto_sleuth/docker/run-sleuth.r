#!/usr/bin/env Rscript

library("sleuth")

args = commandArgs(trailingOnly=TRUE)

s2c <- read.table(file.path(args[1]), header=TRUE, stringsAsFactors=FALSE)

so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)

type <- colnames(s2c)[2]

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

dir.create(file.path('.', 'plots'))

png('plots/plot_bootstrap.png')
plot_bootstrap(so, sleuth_significant[1,1], units = "est_counts", color_by = type)
dev.off()

png('plots/plot_group_density.png')
plot_group_density(so, use_filtered = TRUE, units = "tpm", trans = "log", grouping = setdiff(colnames(so$sample_to_covariates), "sample"), offset = 0)
dev.off()

png('plots/plot_pca.png')
plot_pca(so, color_by = type)
dev.off()

png('plots/plot_loadings.png')
plot_loadings(so)
dev.off()

for(test in valid_tests){
	plot_name <- paste0('plots/plot_ma_', test, '.png')
	png(plot_name)
	print(plot_ma(so, test))
	dev.off()
}

png('plots/plot_mean_var.png')
plot_mean_var(so)
dev.off()

for(test in valid_tests){
	plot_name <- paste0('plots/plot_qq_', test, '.png')
	png(plot_name)
	print(plot_qq(so, test))	
	dev.off()
}

png('plots/plot_sample_heatmap.png')
plot_sample_heatmap(so)
dev.off()

png('plots/plot_vars.png')
plot_vars(so)
dev.off()

for(test in valid_tests){
	plot_name <- paste0('plots/plot_volcano_', test, '.png')
	png(plot_name)
	print(plot_volcano(so, test))	
	dev.off()
}
