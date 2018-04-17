# ReFUS-genomic-selection
Scripts to get from multiplexed sequencing reads to GEBVs and selected individuals via genomic selection in ReFUS population

Step 1. Get fastseq files transferred to a folder inside RedRep directory on Linux machine. Rename the .fastq files to fit pipeline.sh script:
filename = data<lib>_<index>.fastq | meta<lib>_<index>.txt

Example: data1-2.fastq

Step 2. Create meta-data files with matching names with information on the individuals within each sequencing library:

Example meta1-2.txt

Files MUST have these columns:  
unique_id	library_id	person	date_submit	date_return	gbs_protocol	illumina_type	entry	p1_enzyme	p1_recog_site	p1_hang_seq	p1_index	p1_index_seq	p1_expect_seq	p2_enzyme	p2_recog_sit	p2_hang_seq	p2_index	p2_index_seq	p2_expect_seq	comment  
i01_17FL0107-10_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-10	Csp6I	GTAC	C	Pi01	AACAATA	AACAATAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  
i09_17FL0107-11_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-11	Csp6I	GTAC	C	Pi09	CCACCTA	CCACCTAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  
i10_17FL0107-12_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-12	Csp6I	GTAC	C	Pi10	TTGTTTA	TTGTTTAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  

[An example of a grid layout of DNA samples in 96-well plate format](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUS%20C4%20NGS%20Library%20plate%20layout.csv)

[Here is a python script to generate metadata files based on grid layout file](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/Reformat%20plate%20layouts%20to%20metadata%20files%20for%20RedRep.py)  

Step 3. Run the RedRep pipeline:

[Publication by Manching et al. 2017](http://www.g3journal.org/content/7/7/2161)  
[RedRep GitHub page](https://github.com/UD-CBCB/RedRep)  

The result of the pipepline is a series of directories named data1-1snp to data2-4snp, each containing a .vcf file named combined.snp.vcf that has the SNPs called for one index of one library. In this case we have two 192-plex libraries, each has 48 samples in each of 4 index sets.  

Step 4. Filter the raw SNPs to keep only the SNPs previously called on the training data samples (~8k total).  Combine the SNP calls for all samples into one file (REFUSC4.subset.SNP.vcf.gz).

[File with the list of 8k SNPs used to fit estimate the realized relationship matrix in the training data](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/genoRefus_original_training_site_info.txt)

[Bash script to filter SNPs from each set of 8 samples to keep only those included in the original 8k and create a combined file with all samples](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/filter_combine_SNPs.sh)

[Bash script to check depth and missing data rates](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/filter_SNPs_depth.sh)

Step 5. Do initial QC checks of depth and missing call rates across individuals and across markers. To reduce heterozygosity call error, change homozygous calls with depth < 8 to missing. Homozygous calls with depth > 8 should have  

# reads	p(Het mis-call)
1		    1
2		    0.5
3		    0.25
4	      0.125
5		    0.0625
6	      0.03125
7		    0.015625
8		    0.0078125
9		    0.00390625
10	    0.001953125
11	    0.000976563
12	    0.000488281




