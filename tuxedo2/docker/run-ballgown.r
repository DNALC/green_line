#!/usr/bin/env Rscript

library(ballgown)
library(RSkittleBrewer)
library(genefilter)
library(plyr)
library(dplyr)
library(devtools)
library(ggplot2)

pheno_data = read.table('phenodata', header = TRUE)

type <- colnames(pheno_data)[2]

bg = ballgown(dataDir = "ballgown", samplePattern = "", pData = pheno_data)

bg_filt = subset(bg, "rowVars(texpr(bg)) > 1", genomesubset = TRUE)

results_transcripts = stattest(bg_filt, feature='transcript', covariate=type, getFC=TRUE, meas='FPKM')
results_genes = stattest(bg_filt, feature='gene', covariate=type, getFC=TRUE, meas='FPKM')

results_transcripts = data.frame(geneNames=ballgown::geneNames(bg_filt), geneIDs=ballgown::geneIDs(bg_filt), results_transcripts)

fpkms = texpr(bg_filt,meas="FPKM")

transcripts_ids <- ballgown::transcriptNames(bg_filt)
transcripts_index <- grep("transcript:", ballgown::transcriptNames(bg_filt))
transcripts_ids <- transcripts_ids[transcripts_index]

count = count(pheno_data, eval(parse(text=type)))

prev_lim <- 1
res <- data.frame()
for (i in 1:nrow(count)) {
	fpkm <- fpkms[transcripts_index, prev_lim:(prev_lim + as.integer(count[i,2]) - 1)]
	fpkm <- rowMeans(fpkm)

	prev_lim <- prev_lim + as.integer(count[i,2])
	fpkm <- sapply(fpkm, function(x) log2(x + 1))
	df <- data.frame(transcripts_ids, count[i,1], fpkm)
	colnames(df) <- c("ids", type, "expression")

	res <- rbind(res, df)
}

p <- ggplot(res, aes(expression))
p <- p + geom_density(aes_string(colour = type, fill = type), alpha = 0.2)
png('plots/density.png')
p
dev.off()

results_transcripts$mean <- rowMeans(texpr(bg_filt))
p <- ggplot(results_transcripts, aes(log2(mean), log2(fc), colour = qval < 0.5)) 
p <- geom_point()
p <- ggplot(results_transcripts, aes(log2(mean), log2(fc), colour = qval < 0.5)) 
p <- p + geom_point()
p <- p + geom_hline(yintercept=0)
png('plots/ma.png')
p
dev.off()
