#!/usr/bin/env Rscript

library("sleuth")

args = commandArgs(trailingOnly=TRUE)
organism <- args[2]

s2c <- read.table(file.path(args[1]), header=TRUE, stringsAsFactors=FALSE)

gene_bd <- read.table("gene_bd", header=TRUE, stringsAsFactors=FALSE)
mart_info <- gene_bd[gene_bd$organism==organism,]
if(nrow(mart_info) != 0) {
	mart <- biomaRt::useMart(biomart=mart_info$biomart, dataset=mart_info$dataset, host=mart_info$host)
	t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id", "external_gene_name"), mart = mart)
	t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id, ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
	so <- sleuth_prep(s2c, target_mapping = t2g, extra_bootstrap_summary = TRUE)
} else {
	so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)
}

type <- colnames(s2c)[3]

formula <- paste0("~", type)
so <- sleuth_fit(so, eval(parse(text=formula)), 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')

sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)

write.csv(sleuth_significant, 'significant.csv')

wald_test <- colnames(design_matrix(so))[2]
so <- sleuth_wt(so, wald_test)

sleuth_save(so, 'sleuth_object.so')

