#!/bin/bash
# Set individual SNP calls to missing if depth or quality of sequence is low

#switch back to the main folder
cd ~/RedRep/ReFUS

#output the individual call depths for analysis:
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --out REFUSC4sub --geno-depth

#output the genotype calls for analysis - these are in format 0/0, 0/1, 1/1, not sure how to get 0,1,2 format
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --out REFUSC4sub --extract-FORMAT-info GT

#output the sequence quality for analysis:
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --out REFUSC4sub --get-INFO GC

#after additional filtering in R, we have a list of individuals and markers to keep in final data set
#use these to subset to final vcf version
#NOTE - this originally failed when I used --recode-bcf in first line and read in the bcf in 2nd line
#Error: invalid type for integer size
#Problem solved by using vcf instead of bcf as intermediate file format
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --keep ReFUSC4_indv_in_final_set.txt --out REFUSC4dropindvs --recode
vcftools --vcf ~/RedRep/ReFUS/REFUSC4dropindvs.recode.vcf --positions ReFUSC4_SNPs_in_final_set.txt --out REFUSC4final --recode


#a sample of setting calls with depth of 4 to missing and then checking the missing data per individual 
#vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4filt --minDP 4 --recode
#vcftools --vcf ~/RedRep/ReFUS/REFUSC4filt.recode.vcf  --out REFUSC4filt --missing-indv
