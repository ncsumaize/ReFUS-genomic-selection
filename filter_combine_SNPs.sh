#!/bin/bash
# Loop to subset each group of SNPs for REFUS C4 GBS to include only ones that are containined in Thiago's ReFUS C3 training data set.
# raw SNP calls are in 8 folders called data1-1 to data1-4 and data2-1 to data2-4
# raw SNP call file is called combined.SNP.vcf within each
# Then combine subsets into a single combined file and do some QC checks on that 

# on Linux make this file executable with chmod 755 filter_combine_SNPs.sh
# then execute with ./combine_filter_SNPs.sh
# a common problem is that Windows introduces weird end of line stuff, you may get this error
# 'carrot-M bad interpreter: No such file...'
# get rid of those things with this command
# dos2unix combine_filter_SNPs.sh

for i in {1..2}
    do
    echo i = $i
    for j in {1..4}
        do
        echo j = $j
	#move to the subset directory
        cd ~/RedRep/ReFUS/data"$i"-"$j"snp
	echo current directory:
	echo $PWD
        #subset the current SNP set to include only those that are also included in training set
	#check if the vcf is already bgzipped or not
	#NOTE SOMEHOW THIS FAILED INSIDE SOME BUT NOT ALL DIRECTORIES, A PARTIAL GZ FILE WAS MADE AND WE LOST A HUGE NUMBER OF SNPS
	#CHECK THE out.log file in each director to see if it worked ok
	if [ ! -f combined.SNP.vcf.gz ]
		then
		bgzip combined.SNP.vcf
	fi 
	#subset the SNPs to include only same ones in training set
	vcftools --gzvcf combined.SNP.vcf.gz --positions ~/RedRep/ReFUS/genoRefus_original_training_site_info.txt --recode -c | bgzip -c > subset.SNP.vcf.gz 
	#make the index
	bcftools index subset.SNP.vcf.gz -f
	done
done

#switch back to the main folder
cd ~/RedRep/ReFUS

#now merge across all eight subsets 
bcftools merge -m all ~/RedRep/ReFUS/data1-1snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data1-2snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data1-3snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data1-4snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data2-1snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data2-2snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data2-3snp/subset.SNP.vcf.gz ~/RedRep/ReFUS/data2-4snp/subset.SNP.vcf.gz  -o  ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --output-type z

#make a new index for the combined file, forcing overwrite of previous index with -f
bcftools index ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz -f

#Do some QC on the merged unfiltered SNP set
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --missing-indv
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --missing-site
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --depth
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --site-mean-depth
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --het
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --hardy
vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz  --out REFUSC4sub --site-quality