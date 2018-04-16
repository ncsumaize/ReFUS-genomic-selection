#!/bin/bash
# Set individual SNP calls to missing if depth or quality of sequence is low

#switch back to the main folder
cd ~/RedRep/ReFUS

#output the individual call depths for analysis:

vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --out REFUSC4sub --geno-depth
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4filt --minDP 4 --recode
vcftools --vcf ~/RedRep/ReFUS/REFUSC4filt.recode.vcf  --out REFUSC4filt --missing-indv
