# ReFUS-genomic-selection
## Scripts to get from multiplexed sequencing reads to GEBVs and selected individuals via genomic selection in ReFUS population

## Step 1.  
Get fastseq files transferred to a folder inside RedRep directory on Linux machine. Rename the .fastq files to fit pipeline.sh script:
<pre>filename = data<lib>_<index>.fastq | meta<lib>_<index>.txt<\pre>

Example: data1-2.fastq

## Step 2.  
Create meta-data files with matching names with information on the individuals within each sequencing library:

Example meta1-2.txt

Files MUST have these columns:  
unique_id	library_id	person	date_submit	date_return	gbs_protocol	illumina_type	entry	p1_enzyme	p1_recog_site	p1_hang_seq	p1_index	p1_index_seq	p1_expect_seq	p2_enzyme	p2_recog_sit	p2_hang_seq	p2_index	p2_index_seq	p2_expect_seq	comment  
i01_17FL0107-10_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-10	Csp6I	GTAC	C	Pi01	AACAATA	AACAATAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  
i09_17FL0107-11_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-11	Csp6I	GTAC	C	Pi09	CCACCTA	CCACCTAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  
i10_17FL0107-12_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-12	Csp6I	GTAC	C	Pi10	TTGTTTA	TTGTTTAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  

[An example of a grid layout of DNA samples in 96-well plate format](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUS%20C4%20NGS%20Library%20plate%20layout.csv)

[Here is a python script to generate metadata files based on grid layout file](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/Reformat%20plate%20layouts%20to%20metadata%20files%20for%20RedRep.py)  

## Step 3.  
Run the RedRep pipeline:

[Publication by Manching et al. 2017](http://www.g3journal.org/content/7/7/2161)  
[RedRep GitHub page](https://github.com/UD-CBCB/RedRep)  

The result of the pipepline is a series of directories named data1-1snp to data2-4snp, each containing a .vcf file named combined.snp.vcf that has the SNPs called for one index of one library. In this case we have two 192-plex libraries, each has 48 samples in each of 4 index sets.  

## Step 4.  
Filter the raw SNPs to keep only the SNPs previously called on the training data samples (~8k total).  Combine the SNP calls for all samples into one file (REFUSC4.subset.SNP.vcf.gz).

[File with the list of 8k SNPs used to fit estimate the realized relationship matrix in the training data](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/genoRefus_original_training_site_info.txt)

[Bash script to filter SNPs from each set of 8 samples to keep only those included in the original 8k and create a combined file with all samples](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/filter_combine_SNPs.sh)

[Bash script to output call depth and genotype calls for QC](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/filter_SNPs_depth.sh)

I had some cases where individual sub-files were not processed properly, there was no error message, but only part of the SNPs were processed and those individuals were systematically missing all markers on some chromosomes. Check the log files in each directory to make sure the numbers of SNPs and individuals retained are reasonable.

## Step 5. 
[Do initial QC checks of depth and missing call rates across individuals and across markers](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUS_C4_GBS_depth_analysis.html). To reduce heterozygosity call error, change homozygous calls with depth < 8 to missing. Homozygous calls with depth >= 8 should have only around 1% chance of het mis-call, the error rate gets much higher for lower depth calls.  

| # reads	| p(Het mis-call) | 
| ------- |:----------------| 
| 1		    | 1               | 
| 2		    | 0.5             | 
| 3		    | 0.25            | 
| 4	      | 0.125           | 
| 5		    | 0.0625          | 
| 6	      | 0.03125         |
| 7		    | 0.015625        |
| 8		    | 0.0078125       |
| 9		    | 0.00390625      |
| 10	    | 0.001953125     |
| 11	    | 0.000976563     |
| 12	    | 0.000488281     | 

Remove SNPs with mean depth > 120 (likely paralogs with multiple areas of alignment) and SNPs with > 50% missing call rate. After filtering SNPs, then remove individuals with > 60% missing data. Then write out two flat files with the names of SNPs and individuals to keep in final data set (REFUSC4_SNPs_in_final_set.txt and REFUSC4_indv_in_final_set.txt). We will use these files in next step.  

## Step 6.  
Transfer the SNP and individual list files to Linux system. Use bash script to keep only the desired SNPs and individuals from the previous vcf file and output as REFUSC4final.recode.vcf. 

vcftools --gzvcf ~/RedRep/ReFUS/REFUSC4.subset.SNP.vcf.gz --keep ReFUSC4_indv_in_final_set.txt --out REFUSC4dropindvs --recode
vcftools --vcf ~/RedRep/ReFUS/REFUSC4dropindvs.recode.vcf --positions ReFUSC4_SNPs_in_final_set.txt --out REFUSC4final --recode

## Step 7.  
Open new vcf in TASSEL and export the data set as HapMap format: REFUSC4final.vcf

## Step 8.  
[R script to edit the training data set genotype file before we can merge with the new cycle samples file](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/Get%20SNP%20site%20list%20from%20training%20data%20to%20filter%20C4%20GBS%20data.R). The previous version had very long marker names tracking the position information from AGPv2, 3, and 4!. Here we trim that to just the usual AGPv4 site names, and this will match with the new file marker names.  

## Step 9.  
[R script to join the C3 training genotype data and current cycle C4 data](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/Join%20ReFUSC3%20training%20and%20C4%20SNPs.R). This will produce the joined genotype data file in HapMap format: REFUSC3_4_join.mp.txt  

## Step 10.  
Open joined HapMap file with both training and C4 individuals in TASSEL. 
  Impute missing data with LDKNNi with default options: High LD sites = 30, Nearest Neighbors = 10, Max distance = 10k.  
  This reduces missing data to 0.00644.  
  Filter out markers with MAF < 0.01, maximum heterozygosity > 0.70
  This leaves 3037 markers. (Output this file as REFUSC3_4_join.imp.hmp.txt)
  Compute kinship matrix using centered IBS option, output matrix as REFUSC3_4_join_impK.txt


## Step 11.  
[R script to take in realized genomic relationship matrix and output in ASReml format with ped file]
(https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/make%20ReFUS%20C3-C4%20Grm%20for%20asreml.Rmd).  

## Step 12.  
[ASReml script to fit multivariate GBLUP model](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUSC3-C4_Gblup_Model.as). Model part 11 is the multivariate GBLUP model we want for both fusarium ear rot and fumonisin content. This model fits the relationship matrix to model the covariances among lines and individuals, with heterogeneous error structures for each site. I had to remove the weighting by ear counts and the GxE term to obtain convergence (but GxE variance was very small).  

[This generates a summary output file with covariance components estimates](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUSC3-C4_Gblup_Model11.asr).

[This also generates a prediction file](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUSC3-C4_Gblup_Model11.pvs)

## Step 13.  
[R script to QC relationship matrix and select optimal subset of crosses with optimal contribution method and index selection](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUS%20C4%20Check%20K%20matrix%20and%20Index%20selections%20for%20paired%20plants%20%204-2018.Rmd). There are some tricky issues here, mostly due to some individuals were removed from genotype set because of high missing data rates. However, we crossed individuals in winter nursery BEFORE we had genotype data. So, we have many paired crosses which involve one parent lacking genotype data. This is frustrating but we have to deal with it as best we can. The approach here is to give each ungenotyped parent a breeding value of zero, then also do an extra shrinkage on the breeding value of the paired cross it was used in. We also have to assume zero covariance of those individuals with other parents, which greatly reduces the effectiveness of our optimal contribution approach, but we don't have any choice. Finally, we use a genetic algorithm to pick the optimal set of ten crosses (from 20 individuals) to use to create the next generation.





