#Get the genotype data from Thiago's ReFUS C3 training set
#output a tab-separated file with the list of chromosomes and positions
#we can then use this in vcftools to filter the sites in the ReFUS C4 data 
#to keep only the sites used previously. 
#then filter from there.

snps.orig = read.table('Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/geno_training/Raw_ReFUStraining_geno_agpv4_8K_sorted.hmp.txt',
                              header = T, comment.char = "", stringsAsFactors = F)

#the chr and pos info is in AGPv4, which is what we want.

#output tab-delimited file with chrom position
fname = 'Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/genoRefus_original_training_site_info.txt'
write.table(t(c('#chr', 'pos')), file = fname, sep = '\t', quote = F, row.names = F, col.names = F)
write.table(snps.orig[c('chrom', 'pos')],file = fname, append = T, sep = '\t', quote = F, row.names = F, col.names = F)

#Also edit the rs# info in the hapmap file, because it will not match the site names from the vcf file when imported to TASSEL
str(snps.orig)
snps.orig$rs. = paste0('S', snps.orig$chrom, '_', snps.orig$pos)

#get the correct header as raw text from the input file, then output to a new file, then finally add the modified data frame to new output fie
header = readLines('Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/geno_training/Raw_ReFUStraining_geno_agpv4_8K_sorted.hmp.txt',
                                n = 1)
newname = 'Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/geno_training/Raw_ReFUStraining_geno_agpv4_8K_sorted_newSNPNames.hmp.txt'
writeLines(header, newname)
write.table(snps.orig, file = newname, append = T, sep = '\t', quote = F, row.names = F, col.names = F)
