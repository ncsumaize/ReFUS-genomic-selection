#Read in the two hapmap files for training data and for C4 individuals.
#Already fixed rs info to be consistent, but the training data have more SNPs

header.orig = readLines('Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/geno_training/Raw_ReFUStraining_geno_agpv4_8K_sorted_newSNPNames.hmp.txt',
                        n = 1)
snps.orig = read.table('Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/geno_training/Raw_ReFUStraining_geno_agpv4_8K_sorted_newSNPNames.hmp.txt',
                       header = T, comment.char = "", stringsAsFactors = F)

header.new = readLines('Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/REFUSC4final.hmp.txt',
                                     n = 1)
snps.new = read.table('Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/REFUSC4final.hmp.txt',
                      header = T, comment.char = "", stringsAsFactors = F)

#Filter the original SNPs to keep only those maintained in the C4 set
snps.orig = snps.orig[snps.orig$rs. %in% snps.new$rs.,]

#Combine the two sets of individuals
#note that any differences in metadat between the two sets (list alleles in different order) will drop the markers
#we want to be robust to that, so merge new data without their extra metadata info
snps.new =snps.new[colnames(snps.new)[! colnames(snps.new) %in% c("rs.", "alleles", "strand", "assembly.", "center", "protLSID", "assayLSID", "panelLSID" , "QCcode")]]
snps.comb = merge(snps.orig, snps.new, by = c('chrom', 'pos'))
snps.comb[1:20, 800:804]
tail(snps.comb)[, 800:804]
tail(snps.comb)[, 1:20]

#sort them, need to make sure chrom and pos are integers
snps.comb$chrom = as.integer(snps.comb$chrom)
snps.comb$pos = as.integer(snps.comb$pos)
snps.comb = snps.comb[order(snps.comb$chrom, snps.comb$pos),]

#notice that the merge re-arranges the columns, we need to get them back to proper order here
snps.comb = snps.comb[c(c("rs.", "alleles", "chrom", "pos"), colnames(snps.comb)[5:length(colnames(snps.comb))])]

#combine the header info properly
#while we are at it, strip the .single suffix from the new header IDs
header.orig
header.new = sub('rs#\talleles\tchrom\tpos\tstrand\tassembly#\tcenter\tprotLSID\tassayLSID\tpanelLSID\tQCcode', '', header.new)
header.new = gsub('.single', '', header.new)
header.comb = paste0(header.orig, header.new)

comb.name = 'Q:/My Drive/GS_ReFUS_files/Predictions_2018_C4/REFUSC3_4_join.hmp.txt'
writeLines(header.comb, comb.name)
write.table(snps.comb, file = comb.name, append = T, sep = '\t', quote = F, row.names = F, col.names = F)

#some QC checking
#checkit = snps.new[, c(colnames(snps.new[1:12]), "i01_17FL0115.3_i19.single")]
