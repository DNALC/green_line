#!/usr/bin/env Rscript

library(rsconnect)

args = commandArgs(trailingOnly=TRUE)
app_name = args[1]

bioc <- local({
	env <- new.env()
	on.exit(rm(env))
	evalq(source("http://bioconductor.org/biocLite.R", local = TRUE), env)
	biocinstallRepos()
})

options(repos=bioc)

deployApp(app_name)
setProperty("application.instances.template", "xxxlarge", appName=app_name)
deployApp(app_name)
